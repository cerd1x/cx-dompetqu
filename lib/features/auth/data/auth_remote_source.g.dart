// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_remote_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authRemoteSource)
final authRemoteSourceProvider = AuthRemoteSourceProvider._();

final class AuthRemoteSourceProvider
    extends
        $FunctionalProvider<
          AuthRemoteSource,
          AuthRemoteSource,
          AuthRemoteSource
        >
    with $Provider<AuthRemoteSource> {
  AuthRemoteSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRemoteSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRemoteSourceHash();

  @$internal
  @override
  $ProviderElement<AuthRemoteSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRemoteSource create(Ref ref) {
    return authRemoteSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRemoteSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRemoteSource>(value),
    );
  }
}

String _$authRemoteSourceHash() => r'c189c3301f36d40ce74848a517fe62f0000991cd';
