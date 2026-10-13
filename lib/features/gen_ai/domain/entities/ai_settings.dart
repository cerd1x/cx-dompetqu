const String kDefaultAiModel = 'gemini-2.5-flash';

class AiSettings {
  const AiSettings({this.apiKey = '', this.model = 'gemini-2.5-flash'});

  final String apiKey;
  final String model;

  AiSettings copyWith({String? apiKey, String? model}) =>
      AiSettings(apiKey: apiKey ?? this.apiKey, model: model ?? this.model);
}
