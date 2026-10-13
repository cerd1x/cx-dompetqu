class AppSettings {
  const AppSettings({this.darkMode = true, this.currency = 'IDR'});

  final bool darkMode;
  final String currency;

  AppSettings copyWith({bool? darkMode, String? currency}) => AppSettings(
    darkMode: darkMode ?? this.darkMode,
    currency: currency ?? this.currency,
  );
}
