// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_skills_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AiSkillsController)
final aiSkillsControllerProvider = AiSkillsControllerProvider._();

final class AiSkillsControllerProvider
    extends $AsyncNotifierProvider<AiSkillsController, List<AiSkill>> {
  AiSkillsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiSkillsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiSkillsControllerHash();

  @$internal
  @override
  AiSkillsController create() => AiSkillsController();
}

String _$aiSkillsControllerHash() =>
    r'6ee61f86777eeee8977021894db946e947468a80';

abstract class _$AiSkillsController extends $AsyncNotifier<List<AiSkill>> {
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
