import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/logger/app_logger.dart';
import '../data/killswitch_remote_source.dart';

part 'killswitch_controller.freezed.dart';
part 'killswitch_controller.g.dart';

/// State layar kill switch — daftar operation yang dimatikan beserta status
/// loading/mutating dan pesan error.
@freezed
abstract class KillswitchState with _$KillswitchState {
  const factory KillswitchState({
    /// Daftar operation yang sedang dimatikan.
    @Default([]) List<KillswitchEntry> entries,

    /// `true` saat memuat daftar (pertama kali / refresh).
    @Default(true) bool loading,

    /// `true` saat operasi disable/enable sedang berjalan.
    @Default(false) bool mutating,

    /// Pesan error terakhir (untuk ditampilkan di UI).
    String? error,
  }) = _KillswitchState;
}

/// Kontrol kill switch: memuat daftar, mematikan, dan menghidupkan operation
/// GraphQL melalui endpoint REST `{baseUrl}/admin/killswitch`.
@Riverpod(keepAlive: true)
class KillswitchController extends _$KillswitchController {
  @override
  KillswitchState build() {
    Future.microtask(load);
    return const KillswitchState();
  }

  Future<void>? _inFlight;

  KillswitchRemoteSource get _remote => ref.read(killswitchRemoteSourceProvider);

  /// Muat daftar operation yang dimatikan. Panggilan beruntun di-dedupe.
  Future<void> load() {
    final pending = _inFlight;
    if (pending != null) return pending;
    state = state.copyWith(loading: true, error: null);
    final future = _fetch();
    _inFlight = future;
    future.whenComplete(() {
      if (_inFlight == future) _inFlight = null;
    });
    return future;
  }

  Future<void> _fetch() async {
    try {
      final entries = await _remote.list();
      if (!ref.mounted) return;
      state = state.copyWith(entries: entries, loading: false);
    } catch (e) {
      if (!ref.mounted) return;
      AppLogger.instance.error(
        'Gagal memuat kill switch',
        tag: 'KillswitchController',
        error: e,
      );
      state = state.copyWith(loading: false, error: _msg(e));
    }
  }

  /// Matikan [operation]. Mengembalikan `true` bila sukses.
  Future<bool> disable(String operation, {String? reason}) async {
    state = state.copyWith(mutating: true, error: null);
    try {
      await _remote.disable(operation, reason: reason);
      AppLogger.instance.warn(
        'Operation dimatikan: $operation',
        tag: 'KillswitchController',
      );
      if (ref.mounted) state = state.copyWith(mutating: false);
      await load();
      return true;
    } catch (e) {
      if (ref.mounted) {
        state = state.copyWith(mutating: false, error: _msg(e));
      }
      return false;
    }
  }

  /// Nyalakan kembali [operation]. Mengembalikan `true` bila sukses.
  Future<bool> enable(String operation) async {
    state = state.copyWith(mutating: true, error: null);
    try {
      await _remote.enable(operation);
      AppLogger.instance.info(
        'Operation dihidupkan: $operation',
        tag: 'KillswitchController',
      );
      if (ref.mounted) state = state.copyWith(mutating: false);
      await load();
      return true;
    } catch (e) {
      if (ref.mounted) {
        state = state.copyWith(mutating: false, error: _msg(e));
      }
      return false;
    }
  }

  /// Ambil token admin aktif (untuk indikator di UI).
  bool get hasToken => _remote.hasToken;

  static String _msg(Object e) => e is Exception ? e.toString() : '$e';
}