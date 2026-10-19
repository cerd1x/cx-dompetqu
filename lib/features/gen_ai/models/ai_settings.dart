import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/ai_settings.freezed.dart';

const String kAiApiKeyPrefsKey = 'ai_api_key';
const String kAiModelPrefsKey = 'ai_model';
const String kDefaultAiModel = 'gemini-2.5-flash';

/// Pengaturan AI (API key & model Gemini) — dipakai `ai_settings_controller`
/// dan form di `ai_settings_sheet`.
@freezed
abstract class AiSettings with _$AiSettings {
  const factory AiSettings({
    @Default('') String apiKey,
    @Default(kDefaultAiModel) String model,
  }) = _AiSettings;
}
