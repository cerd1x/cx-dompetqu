// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cookie_aware_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Client HTTP yang mengelola cookie session (persist antar request).

@ProviderFor(cookieAwareClient)
final cookieAwareClientProvider = CookieAwareClientProvider._();

/// Client HTTP yang mengelola cookie session (persist antar request).

final class CookieAwareClientProvider
    extends
        $FunctionalProvider<
          CookieAwareClient,
          CookieAwareClient,
          CookieAwareClient
        >
    with $Provider<CookieAwareClient> {
  /// Client HTTP yang mengelola cookie session (persist antar request).
  CookieAwareClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cookieAwareClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cookieAwareClientHash();

  @$internal
  @override
  $ProviderElement<CookieAwareClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CookieAwareClient create(Ref ref) {
    return cookieAwareClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CookieAwareClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CookieAwareClient>(value),
    );
  }
}

String _$cookieAwareClientHash() => r'4b18b60cd43ceba067555ef8a2750e1925bbbbc3';
