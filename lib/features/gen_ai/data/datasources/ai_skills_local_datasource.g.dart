// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_skills_local_datasource.dart';

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
    r'a75e90c7521ec7a00a8cbee4cb7d9e2ed1f70f4a';
