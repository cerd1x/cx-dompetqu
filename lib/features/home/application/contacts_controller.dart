import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/logger/app_logger.dart';
import '../data/contacts_remote_source.dart';
import '../models/contact.dart';

part 'contacts_controller.g.dart';

/// Jumlah kontak per halaman saat mode pagination aktif — cerminan
/// `DEFAULT_PAGE_SIZE` di `services/domain/contacts` (`contact-page.model.ts`).
const int kContactsPageSize = 20;

/// State kontak — padanan `contactStore` di web.
class ContactsState {
  const ContactsState({
    this.items = const [],
    this.loading = true,
    this.error,
    this.searchQuery = '',
    this.pageSize = kContactsPageSize,
    this.nextCursor,
    this.hasMore = false,
    this.loadingMore = false,
  });

  final List<Contact> items;
  final bool loading;
  final String? error;
  final String searchQuery;

  /// Jumlah item per halaman yang diminta ke server.
  final int pageSize;

  /// Cursor opaque untuk halaman berikutnya; `null` = mode pagination tidak
  /// aktif (daftar dimuat penuh) atau sudah tidak ada halaman berikutnya.
  final String? nextCursor;

  /// Apakah masih ada halaman berikutnya di server.
  final bool hasMore;

  /// Sedang mengambil halaman berikutnya (konten lama tetap tampil).
  final bool loadingMore;

  List<Contact> get filtered {
    final q = searchQuery.trim().toLowerCase();
    if (q.isEmpty) return items;
    return items.where((c) {
      return c.name.toLowerCase().contains(q) ||
          (c.phone?.contains(q) ?? false) ||
          (c.email?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  ContactsState copyWith({
    List<Contact>? items,
    bool? loading,
    Object? error = _keep,
    String? searchQuery,
    int? pageSize,
    Object? nextCursor = _keep,
    bool? hasMore,
    bool? loadingMore,
  }) => ContactsState(
    items: items ?? this.items,
    loading: loading ?? this.loading,
    error: identical(error, _keep) ? this.error : error as String?,
    searchQuery: searchQuery ?? this.searchQuery,
    pageSize: pageSize ?? this.pageSize,
    nextCursor: identical(nextCursor, _keep) ? this.nextCursor : nextCursor as String?,
    hasMore: hasMore ?? this.hasMore,
    loadingMore: loadingMore ?? this.loadingMore,
  );

  /// Sentinel `copyWith` — bedakan "tidak diubah" dari "di-set jadi `null`".
  static const Object _keep = Object();
}

/// Status hasil merge kontak.
enum MergeStatus {
  /// Update primary + hapus duplikat sukses.
  success,

  /// Data sudah digabung ke primary, tapi duplikat gagal dihapus.
  duplicateLeft,

  /// Update primary gagal — tidak ada perubahan di server.
  failed,
}

/// Hasil [ContactsController.merge] beserta pesan error bila ada.
///
/// Error sifatnya LOKAL (dikonsumsi dialog merge) — tidak ditulis ke
/// `state.error` global agar daftar kontak di belakang dialog tidak
/// ikut berganti menjadi ErrorState karena kegagalan mutasi.
class MergeOutcome {
  const MergeOutcome(this.status, {this.error});

  final MergeStatus status;
  final String? error;
}

/// Jenis pengelompokan deteksi duplikat kontak.
enum DuplicateGroupType {
  /// Serangkaian kontak berbagi nomor telepon yang sama (beda nama).
  phone,

  /// Serangkaian kontak berbagi nama yang sama (beda nomor telepon).
  name,
}

/// Sekumpulan kontak yang saling terduplikasi berdasarkan [key].
///
/// [type] menentukan apakah [key] adalah nomor telepon ([DuplicateGroupType.phone])
/// atau nama ([DuplicateGroupType.name]). [reason] adalah deskripsi singkat
/// kenapa grup ini dianggap duplikat (ditampilkan di dialog investigasi).
class ContactDuplicateGroup {
  const ContactDuplicateGroup({
    required this.type,
    required this.key,
    required this.contacts,
  });

  final DuplicateGroupType type;
  final String key;
  final List<Contact> contacts;

  String get reason => switch (type) {
    DuplicateGroupType.phone => 'Nomor sama: $key',
    DuplicateGroupType.name => 'Nama sama: "$key"',
  };
}

@Riverpod(keepAlive: true)
class ContactsController extends _$ContactsController {
  @override
  ContactsState build() {
    // Defer ke microtask: membaca `state` di dalam `build()` (riverpod 3)
    // melempar "uninitialized provider" karena state belum di-commit.
    Future.microtask(load);
    return const ContactsState();
  }

  Future<void>? _inFlight;

  /// Apakah [_inFlight] adalah load halaman (bukan daftar penuh).
  bool _inFlightPaged = false;

  /// Mode keyset aktif. Saat aktif, `load()` (bootstrap/retry) mewarisi mode
  /// ini dan daftar penuh yang masih in-flight dibuang, supaya tidak menimpa
  /// halaman yang sudah tampil.
  bool _paged = false;

  /// Apakah daftar sedang dimuat per halaman (bukan seluruhnya sekaligus).
  bool get isPaged => _paged;

  /// Muat ulang kontak dari server sesuai mode aktif.
  ///
  /// Mode penuh (default): ambil seluruh kontak — dipakai layar yang butuh
  /// daftar lengkap, mis. deteksi duplikat dan picker customer.
  /// Mode pagination ([loadPage] aktif): muat ulang halaman pertama.
  ///
  /// Fire-and-forget — tidak memblokir frame. Panggilan beruntun saat startup
  /// (microtask dari `build()` + bootstrap) di-dedupe: jika sudah ada load
  /// berjalan, panggilan berikutnya menunggu load tersebut tanpa mengirim
  /// query ganda.
  Future<void> load() {
    if (_paged) return loadPage();
    return _deduped(_fetch, paged: false);
  }

  /// Muat **seluruh** kontak sekali saja, matikan mode pagination, dan isi
  /// cache state dengan daftar lengkap — untuk konsumen yang butuh semua data
  /// (deteksi duplikat, picker customer, atau mencari kontak per id).
  Future<void> loadAll() {
    _paged = false;
    if (_inFlight != null && _inFlightPaged) _inFlight = null;
    return _deduped(_fetch, paged: false);
  }

  /// Pastikan [ContactsState.items] memuat **seluruh** kontak; no-op bila
  /// daftar sudah dimuat penuh. Dipakai layar yang butuh data lengkap
  /// (deteksi duplikat, merge, picker customer) saat list utama memakai
  /// pagination keyset.
  Future<void> ensureAllLoaded() {
    if (!_paged) return Future.value();
    return loadAll();
  }

  Future<void> _deduped(Future<void> Function() task, {required bool paged}) {
    final pending = _inFlight;
    if (pending != null) return pending;
    state = state.copyWith(loading: true, error: null, loadingMore: false);
    final future = task();
    _inFlight = future;
    _inFlightPaged = paged;
    future.whenComplete(() {
      if (_inFlight == future) {
        _inFlight = null;
        _inFlightPaged = false;
      }
    });
    return future;
  }

  Future<void> _fetch() async {
    try {
      final items = await ref.read(contactsRemoteSourceProvider).contacts();
      if (!ref.mounted) return;
      // Sesi pagination yang dimulai selagi request ini berjalan lebih
      // baru — jangan ditimpa dengan daftar penuh.
      if (_paged) return;
      state = state.copyWith(
        items: items,
        loading: false,
        // Daftar dimuat penuh -> mode pagination nonaktif.
        nextCursor: null,
        hasMore: false,
        loadingMore: false,
      );
      AppLogger.instance.success(
        'contacts dimuat (${items.length})',
        tag: 'ContactsController',
      );
    } catch (e) {
      if (!ref.mounted || _paged) return;
      AppLogger.instance.error(
        'Gagal load kontak',
        tag: 'ContactsController',
        error: e,
      );
      state = state.copyWith(loading: false, error: _msg(e));
    }
  }

  /// Muat **halaman pertama** dan aktifkan mode pagination keyset —
  /// padanan `contactsPage()` di `contacts.composition.ts`.
  ///
  /// Bedanya dengan [loadAll]: [loadAll] mengambil seluruh kontak sekaligus
  /// (dibutuhkan deteksi duplikat & picker customer), sedangkan [loadPage]
  /// hanya mengambil [pageSize] data terbaru dan menyimpan cursor untuk
  /// [loadMore]. Konsumen yang butuh kontak di luar halaman yang tampil
  /// harus memanggil [loadAll] lebih dulu.
  ///
  /// Aman dipanggil di `initState`: request daftar penuh yang sudah berjalan
  /// (microtask dari `build()`/bootstrap) tidak akan menimpa halaman ini.
  Future<void> loadPage({int pageSize = kContactsPageSize}) {
    _paged = true;
    // Buang hanya request daftar penuh yang sedang berjalan; load halaman
    // yang sedang berjalan dipakai bersama (dedupe).
    if (_inFlight != null && !_inFlightPaged) _inFlight = null;
    return _deduped(() => _fetchPage(pageSize), paged: true);
  }

  Future<void> _fetchPage(int pageSize) async {
    try {
      final page = await ref
          .read(contactsRemoteSourceProvider)
          .contactsPage(first: pageSize);
      if (!ref.mounted) return;
      state = state.copyWith(
        items: page.items,
        loading: false,
        pageSize: pageSize,
        nextCursor: page.hasNextPage ? page.nextCursor : null,
        hasMore: page.hasNextPage,
      );
      AppLogger.instance.success(
        'halaman kontak dimuat (${page.items.length})',
        tag: 'ContactsController',
      );
    } catch (e) {
      if (!ref.mounted) return;
      AppLogger.instance.error(
        'Gagal load halaman kontak',
        tag: 'ContactsController',
        error: e,
      );
      state = state.copyWith(
        loading: false,
        nextCursor: null,
        hasMore: false,
        error: _msg(e),
      );
    }
  }

  /// Ambil halaman berikutnya dan append ke [ContactsState.items].
  ///
  /// No-op (return `false`) bila sedang loading, belum ada sesi pagination
  /// ([ContactsState.hasMore] false / [ContactsState.nextCursor] null), atau
  /// cursor habis dipakai — jadi aman dipanggil dari `build`/`onScroll`.
  ///
  /// Kegagalan tidak mereset daftar yang sudah tampil: error hanya_log dan
  /// [ContactsState.error] diisi kalau belum ada satu pun kontak, agar layar
  /// tidak berubah jadi ErrorState karena gagal load halaman berikutnya.
  Future<bool> loadMore() {
    if (state.loading || state.loadingMore || !state.hasMore) {
      return Future.value(false);
    }
    final cursor = state.nextCursor;
    if (cursor == null || cursor.isEmpty) return Future.value(false);
    state = state.copyWith(loadingMore: true);
    return _loadMore(cursor);
  }

  Future<bool> _loadMore(String cursor) async {
    try {
      final page = await ref
          .read(contactsRemoteSourceProvider)
          .contactsPage(first: state.pageSize, after: cursor);
      if (!ref.mounted) return false;
      final seen = state.items.map((c) => c.id).toSet();
      state = state.copyWith(
        loadingMore: false,
        items: [
          ...state.items,
          ...page.items.where((c) => !seen.contains(c.id)),
        ],
        nextCursor: page.hasNextPage ? page.nextCursor : null,
        hasMore: page.hasNextPage,
      );
      AppLogger.instance.success(
        'halaman kontak berikutnya dimuat (${page.items.length})',
        tag: 'ContactsController',
      );
      return true;
    } catch (e) {
      if (!ref.mounted) return false;
      AppLogger.instance.error(
        'Gagal load halaman kontak berikutnya',
        tag: 'ContactsController',
        error: e,
      );
      state = state.copyWith(
        loadingMore: false,
        error: state.items.isEmpty ? _msg(e) : null,
      );
      return false;
    }
  }

  void setSearch(String query) => state = state.copyWith(searchQuery: query);

  Future<bool> create({
    required String name,
    String? email,
    String? phone,
    List<String>? phones,
    String? group,
  }) async {
    try {
      final created = await ref
          .read(contactsRemoteSourceProvider)
          .create(name: name, email: email, phone: phone, phones: phones, group: group);
      if (!ref.mounted) return true;
      state = state.copyWith(items: [created, ...state.items]);
      return true;
    } catch (e) {
      if (ref.mounted) state = state.copyWith(error: _msg(e));
      return false;
    }
  }

  Future<bool> update(
    String id, {
    String? name,
    String? email,
    String? phone,
    List<String>? phones,
  }) async {
    try {
      final updated = await ref
          .read(contactsRemoteSourceProvider)
          .update(id, name: name, email: email, phone: phone, phones: phones);
      if (!ref.mounted) return true;
      state = state.copyWith(
        items: state.items.map((c) => c.id == id ? updated : c).toList(),
      );
      return true;
    } catch (e) {
      if (ref.mounted) state = state.copyWith(error: _msg(e));
      return false;
    }
  }

  /// Gabungkan kontak duplikat ke kontak utama.
  ///
  /// [primaryId] dipertahankan dengan nilai akhir [name]/[email]/[phone]
  /// (hasil resolusi dari dialog merge), lalu kontak [duplicateId]
  /// dihapus dari server dan daftar lokal.
  ///
  /// Urutan operasi: update dulu, baru hapus duplikat. Jika update
  /// gagal → [MergeStatus.failed] tanpa efek samping. Jika update sukses
  /// tapi delete gagal → state lokal tetap disinkronkan (primary sudah
  /// berubah di server) dan dikembalikan [MergeStatus.duplicateLeft].
  Future<MergeOutcome> merge({
    required String primaryId,
    required String duplicateId,
    required String name,
    String? email,
    String? phone,
  }) async {
    Contact updated;
    try {
      updated = await ref
          .read(contactsRemoteSourceProvider)
          .update(primaryId, name: name, email: email, phone: phone);
    } catch (e) {
      return MergeOutcome(MergeStatus.failed, error: _msg(e));
    }
    var removed = false;
    try {
      removed = await ref
          .read(contactsRemoteSourceProvider)
          .delete(duplicateId);
    } catch (_) {
      removed = false;
    }
    if (ref.mounted) {
      var items = state.items
          .map((c) => c.id == primaryId ? updated : c)
          .toList();
      if (removed) {
        items = items.where((c) => c.id != duplicateId).toList();
      }
      state = state.copyWith(items: items);
    }
    return MergeOutcome(
      removed ? MergeStatus.success : MergeStatus.duplicateLeft,
    );
  }

  Future<bool> remove(String id) async {
    try {
      final ok = await ref.read(contactsRemoteSourceProvider).delete(id);
      if (ok && ref.mounted) {
        state = state.copyWith(
          items: state.items.where((c) => c.id != id).toList(),
        );
      }
      return ok;
    } catch (e) {
      if (ref.mounted) state = state.copyWith(error: _msg(e));
      return false;
    }
  }

  static String _msg(Object e) => e is Exception ? e.toString() : '$e';

  /// Deteksi kontak duplikat untuk investigasi & penggabungan.
  ///
  /// Mengelompokkan kontak berdasarkan dua kriteria:
  ///
  /// 1. **Nomor telepon sama tapi nama berbeda** (grup [DuplicateGroupType.phone])
  ///    — dua kontak atau lebih memakai [Contact.phone] yang identik namun
  ///    punya nama berbeda (indikasi duplikat yang perlu digabung).
  ///
  /// 2. **Nama sama tapi nomor telepon berbeda** (grup [DuplicateGroupType.name])
  ///    — dua kontak atau lebih memakai [Contact.name] yang identik namun
  ///    punya nomor telepon berbeda (indikasi kontak ganda dengan varian data).
  ///
  /// Jika [excludeId] diberikan, kontak tersebut di-exclude (berguna saat
  /// update — agar kontak yang sedang diedit tidak dianggap duplikat).
  ///
  /// Mengembalikan daftar grup duplikat (hanya yang memenuhi salah satu
  /// kriteria). Grup yang sama bisa tercipta dari kedua kriteria; id kontak
  /// tidak diduplikasi antar grup.
  List<ContactDuplicateGroup> findDuplicates({String? excludeId}) {
    final items = state.items.where((c) => c.id != excludeId).toList();
    final groups = <ContactDuplicateGroup>[];

    // 1) Nomor sama, nama berbeda.
    final byPhone = <String, List<Contact>>{};
    for (final c in items) {
      final p = c.phone?.trim();
      if (p == null || p.isEmpty) continue;
      byPhone.putIfAbsent(p, () => []).add(c);
    }
    for (final entry in byPhone.entries) {
      final contacts = entry.value;
      if (contacts.length < 2) continue;
      final names = contacts.map((c) => c.name.trim().toLowerCase()).toSet();
      if (names.length < 2) continue;
      groups.add(
        ContactDuplicateGroup(
          type: DuplicateGroupType.phone,
          key: entry.key,
          contacts: contacts,
        ),
      );
    }

    // 2) Nama sama, nomor berbeda.
    final byName = <String, List<Contact>>{};
    for (final c in items) {
      final n = c.name.trim();
      if (n.isEmpty) continue;
      byName.putIfAbsent(n, () => []).add(c);
    }
    for (final entry in byName.entries) {
      final contacts = entry.value;
      if (contacts.length < 2) continue;
      final phones = contacts
          .map((c) => c.phone?.trim())
          .where((p) => p != null && p.isNotEmpty)
          .toSet();
      if (phones.length < 2) continue;
      groups.add(
        ContactDuplicateGroup(
          type: DuplicateGroupType.name,
          key: entry.key,
          contacts: contacts,
        ),
      );
    }

    return groups;
  }

  /// Cek apakah nomor telepon sudah terdaftar dengan nama berbeda.
  ///
  /// Jika [excludeId] diberikan, kontak dengan id tersebut di-exclude
  /// (berguna saat update — agar kontak sendiri tidak dianggap duplikat).
  ///
  /// Mengembalikan [Contact] yang sudah ada jika ditemukan duplikat,
  /// atau `null` jika tidak ada duplikat.
  Contact? checkContactsDuplicate({
    required String phone,
    String? excludeId,
  }) {
    final normalizedPhone = phone.trim();
    if (normalizedPhone.isEmpty) return null;

    for (final contact in state.items) {
      if (contact.id == excludeId) continue;
      if (contact.phone == null) continue;
      if (contact.phone!.trim() == normalizedPhone) {
        return contact;
      }
    }
    return null;
  }
}
