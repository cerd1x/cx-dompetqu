// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../ai_skills_local_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(aiSkillsLocalDatasource)
final aiSkillsLocalDatasourceProvider = AiSkillsLocalDatasourceProvider._();

final class AiSkillsLocalDatasourceProvider
    extends
        $FunctionalProvider<
          AiSkillsLocalDatasource,
          AiSkillsLocalDatasource,
          AiSkillsLocalDatasource
        >
    with $Provider<AiSkillsLocalDatasource> {
  AiSkillsLocalDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiSkillsLocalDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiSkillsLocalDatasourceHash();

  @$internal
  @override
  $ProviderElement<AiSkillsLocalDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AiSkillsLocalDatasource create(Ref ref) {
    return aiSkillsLocalDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiSkillsLocalDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiSkillsLocalDatasource>(value),
    );
  }
}

String _$aiSkillsLocalDatasourceHash() =>
    r'85358980cebc61b95076054937a797c624e6bcb9';
