// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller percakapan AI. Riwayat bersih ketika sheet ditutup.

@ProviderFor(AiController)
final aiControllerProvider = AiControllerProvider._();

/// Controller percakapan AI. Riwayat bersih ketika sheet ditutup.
final class AiControllerProvider
    extends $NotifierProvider<AiController, AiState> {
  /// Controller percakapan AI. Riwayat bersih ketika sheet ditutup.
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

String _$aiControllerHash() => r'd9b3f7eee873d619064f494900cbba4ab9c2b496';

/// Controller percakapan AI. Riwayat bersih ketika sheet ditutup.

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
