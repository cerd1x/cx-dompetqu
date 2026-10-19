import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/openrouter_model.freezed.dart';

/// Satu model yang tersedia di katalog OpenRouter.
@freezed
abstract class OpenRouterModel with _$OpenRouterModel {
  const factory OpenRouterModel({
    required String id,
    required String name,
    int? contextLength,
  }) = _OpenRouterModel;

  const OpenRouterModel._();
}
