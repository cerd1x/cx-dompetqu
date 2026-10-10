// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller percakapan AI. AutoDispose: riwayat bersih tiap sheet
/// ditutup (tidak ada listener) — hemat memori & mulai fresh.
///
/// Memakai package `google_generative_ai` (Gemini) langsung dengan API key
/// & model yang dikonfigurasi di halaman Settings.

@ProviderFor(AiController)
final aiControllerProvider = AiControllerProvider._();

/// Controller percakapan AI. AutoDispose: riwayat bersih tiap sheet
/// ditutup (tidak ada listener) — hemat memori & mulai fresh.
///
/// Memakai package `google_generative_ai` (Gemini) langsung dengan API key
/// & model yang dikonfigurasi di halaman Settings.
final class AiControllerProvider
    extends $NotifierProvider<AiController, AiState> {
  /// Controller percakapan AI. AutoDispose: riwayat bersih tiap sheet
  /// ditutup (tidak ada listener) — hemat memori & mulai fresh.
  ///
  /// Memakai package `google_generative_ai` (Gemini) langsung dengan API key
  /// & model yang dikonfigurasi di halaman Settings.
  AiControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiControllerHash();

  @$internal
  @override
  AiController create() => AiController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiState>(value),
    );
  }
}

String _$aiControllerHash() => r'8f503f35e4fcff1cc0d1cb31c6401428573aa0dc';

/// Controller percakapan AI. AutoDispose: riwayat bersih tiap sheet
/// ditutup (tidak ada listener) — hemat memori & mulai fresh.
///
/// Memakai package `google_generative_ai` (Gemini) langsung dengan API key
/// & model yang dikonfigurasi di halaman Settings.

abstract class _$AiController extends $Notifier<AiState> {
  AiState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AiState, AiState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AiState, AiState>,
              AiState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
