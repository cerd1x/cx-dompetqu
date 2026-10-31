// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../ai_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Store percakapan AI. Riwayat bersih ketika sheet ditutup.

@ProviderFor(AiStore)
final aiStoreProvider = AiStoreProvider._();

/// Store percakapan AI. Riwayat bersih ketika sheet ditutup.
final class AiStoreProvider extends $NotifierProvider<AiStore, AiState> {
  /// Store percakapan AI. Riwayat bersih ketika sheet ditutup.
  AiStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiStoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiStoreHash();

  @$internal
  @override
  AiStore create() => AiStore();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiState>(value),
    );
  }
}

String _$aiStoreHash() => r'd7083890382a2ee025b5737809bf5996eec4ff7c';

/// Store percakapan AI. Riwayat bersih ketika sheet ditutup.

abstract class _$AiStore extends $Notifier<AiState> {
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
