import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/logger/app_logger.dart';
import '../data/killswitch_remote_source.dart';

part 'killswitch_controller.g.dart';

/// State layar kill switch.
class KillswitchState {
  const KillswitchState({
    this.entries = const [],
    this.loading = true,
    this.mutating = false,
    this.error,
  });

  /// Daftar operation yang sedang dimatikan.
  final List<KillswitchEntry> entries;

  /// `true` saat memuat daftar (pertama kali / refresh).
  final bool loading;

  /// `true` saat operasi disable/enable sedang berjalan.
  final bool mutating;

  /// Pesan error terakhir (untuk ditampilkan di UI).
  final String? error;

  KillswitchState copyWith({
    List<KillswitchEntry>? entries,
    bool? loading,
    bool? mutating,
    String? error,
    bool clearError = false,
  }) => KillswitchState(
    entries: entries ?? this.entries,
    loading: loading ?? this.loading,
    mutating: mutating ?? this.mutating,
    error: clearError ? null : (error ?? this.error),
  );
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
    state = state.copyWith(loading: true, clearError: true);
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
    state = state.copyWith(mutating: true, clearError: true);
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
    state = state.copyWith(mutating: true, clearError: true);
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
