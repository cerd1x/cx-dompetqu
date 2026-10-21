// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../session_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State session global — padanan session/`userStore` di web.

@ProviderFor(SessionStore)
final sessionStoreProvider = SessionStoreProvider._();

/// State session global — padanan session/`userStore` di web.
final class SessionStoreProvider
    extends $NotifierProvider<SessionStore, SessionState> {
  /// State session global — padanan session/`userStore` di web.
  SessionStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionStoreHash();

  @$internal
  @override
  SessionStore create() => SessionStore();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionState>(value),
    );
  }
}

String _$sessionStoreHash() => r'2e1d8e11c2e0fcafd66cf0b3ea2fca1c6bda2003';

/// State session global — padanan session/`userStore` di web.

abstract class _$SessionStore extends $Notifier<SessionState> {
  SessionState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SessionState, SessionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SessionState, SessionState>,
              SessionState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
