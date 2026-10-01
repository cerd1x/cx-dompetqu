// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assets_remote_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(assetsRemoteSource)
final assetsRemoteSourceProvider = AssetsRemoteSourceProvider._();

final class AssetsRemoteSourceProvider
    extends
        $FunctionalProvider<
          AssetsRemoteSource,
          AssetsRemoteSource,
          AssetsRemoteSource
        >
    with $Provider<AssetsRemoteSource> {
  AssetsRemoteSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assetsRemoteSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assetsRemoteSourceHash();

  @$internal
  @override
  $ProviderElement<AssetsRemoteSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AssetsRemoteSource create(Ref ref) {
    return assetsRemoteSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AssetsRemoteSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AssetsRemoteSource>(value),
    );
  }
}

String _$assetsRemoteSourceHash() =>
    r'fc3bb9089a2809690d5efbeecfc4546b76bbe38c';
