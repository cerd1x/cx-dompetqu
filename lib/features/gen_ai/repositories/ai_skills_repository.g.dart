// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_skills_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(aiSkillsRepository)
final aiSkillsRepositoryProvider = AiSkillsRepositoryProvider._();

final class AiSkillsRepositoryProvider
    extends
        $FunctionalProvider<
          AiSkillsRepository,
          AiSkillsRepository,
          AiSkillsRepository
        >
    with $Provider<AiSkillsRepository> {
  AiSkillsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiSkillsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiSkillsRepositoryHash();

  @$internal
  @override
  $ProviderElement<AiSkillsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AiSkillsRepository create(Ref ref) {
    return aiSkillsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiSkillsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiSkillsRepository>(value),
    );
  }
}

String _$aiSkillsRepositoryHash() =>
    r'6221263d9e9e0acd71b63867d09bbd1a934303ae';
