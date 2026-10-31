// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../ai_skills_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AiSkillsStore)
final aiSkillsStoreProvider = AiSkillsStoreProvider._();

final class AiSkillsStoreProvider
    extends $AsyncNotifierProvider<AiSkillsStore, List<AiSkill>> {
  AiSkillsStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiSkillsStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiSkillsStoreHash();

  @$internal
  @override
  AiSkillsStore create() => AiSkillsStore();
}

String _$aiSkillsStoreHash() => r'5966e4ea06238dd21684d437ca52d23559308d90';

abstract class _$AiSkillsStore extends $AsyncNotifier<List<AiSkill>> {
  FutureOr<List<AiSkill>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<AiSkill>>, List<AiSkill>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<AiSkill>>, List<AiSkill>>,
              AsyncValue<List<AiSkill>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
