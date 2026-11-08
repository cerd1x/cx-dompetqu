// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../reports_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ReportsStore)
final reportsStoreProvider = ReportsStoreProvider._();

final class ReportsStoreProvider
    extends $NotifierProvider<ReportsStore, ReportsState> {
  ReportsStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportsStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportsStoreHash();

  @$internal
  @override
  ReportsStore create() => ReportsStore();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReportsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReportsState>(value),
    );
  }
}

String _$reportsStoreHash() => r'b68ce16ac0fa48b9835762f597675b8e136d202b';

abstract class _$ReportsStore extends $Notifier<ReportsState> {
  ReportsState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ReportsState, ReportsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ReportsState, ReportsState>,
              ReportsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
