import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/app_settings.freezed.dart';

/// Pengaturan aplikasi yang dipakai lintas fitur (tema, mata uang).
@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(true) bool darkMode,
    @Default('IDR') String currency,
  }) = _AppSettings;

  const AppSettings._();
}
