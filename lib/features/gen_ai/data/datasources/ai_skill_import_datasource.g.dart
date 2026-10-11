// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_skill_import_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(aiSkillImportDatasource)
final aiSkillImportDatasourceProvider = AiSkillImportDatasourceProvider._();

final class AiSkillImportDatasourceProvider
    extends
        $FunctionalProvider<
          AiSkillImportDatasource,
          AiSkillImportDatasource,
          AiSkillImportDatasource
        >
    with $Provider<AiSkillImportDatasource> {
  AiSkillImportDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiSkillImportDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiSkillImportDatasourceHash();

  @$internal
  @override
  $ProviderElement<AiSkillImportDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AiSkillImportDatasource create(Ref ref) {
    return aiSkillImportDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiSkillImportDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiSkillImportDatasource>(value),
    );
  }
}

String _$aiSkillImportDatasourceHash() =>
    r'772e1166b0231f1f5fe4697cbebdb5d7a659e51b';
