/// Tipe aset — padanan nilai kolom `type` aset di backend
/// (`bank`/`ewallet`/`cash`/`crypto`/`loan`).
///
/// [rawValue] harus sama persis dengan wire value backend karena dikirim apa
/// adanya ke GraphQL dan disimpan apa adanya. Nilai baru di backend wajib
/// dicocokkan di sini, bukan sebaliknya.
enum AssetType {
  bank('bank'),
  ewallet('ewallet'),
  cash('cash'),
  crypto('crypto'),
  loan('loan');

  const AssetType(this.rawValue);

  /// Nilai wire ke backend (lowercase, tanpa spasi).
  final String rawValue;

  /// Label Bahasa Indonesia untuk ditampilkan di UI.
  String get label => switch (this) {
    AssetType.bank => 'Bank',
    AssetType.ewallet => 'E-Wallet',
    AssetType.cash => 'Cash',
    AssetType.crypto => 'Crypto',
    AssetType.loan => 'Loan',
  };

  /// Parse wire value dari backend; `null` bila nilainya belum dikenal.
  ///
  /// Sengaja tidak fallback ke nilai default: bila backend menambah tipe baru,
  /// data lama harus tetap terbaca apa adanya daripada disamarkan jadi tipe lain.
  static AssetType? fromRaw(String? raw) {
    final value = raw?.toLowerCase();
    for (final type in AssetType.values) {
      if (type.rawValue == value) return type;
    }
    return null;
  }
}
