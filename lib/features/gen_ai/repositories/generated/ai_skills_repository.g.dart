// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../ai_skills_repository.dart';

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
    r'e767dcdfe265fe47a8c290a65ee98c31fb0d11f1';
