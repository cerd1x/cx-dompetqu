/// Metode pembayaran — cerminan enum `PaymentMethodType` di backend
/// (`services/domain/transactions/core/model/transaction.model.ts`) yang juga
/// dipakai GraphQL (`PaymentMethodType` di `shared/infra/graphql/types`).
///
/// [rawValue] harus sama persis dengan wire value backend karena dikirim apa
/// adanya ke GraphQL dan disimpan apa adanya di kolom `payment_method`
/// (tabel `payments` & `orders`). Nilai baru di backend wajib dicocokkan di
/// sini, bukan vice versa.
enum PaymentMethodType {
  cash('cash'),
  bankTransfer('bank_transfer'),
  ewallet('ewallet'),
  creditCard('credit_card'),
  debitCard('debit_card'),
  credit('credit');

  const PaymentMethodType(this.rawValue);

  /// Nilai wire ke backend (snake_case).
  final String rawValue;

  /// Label Bahasa Indonesia untuk ditampilkan di UI.
  String get label => switch (this) {
    PaymentMethodType.cash => 'Tunai',
    PaymentMethodType.bankTransfer => 'Transfer Bank',
    PaymentMethodType.ewallet => 'E-Wallet',
    PaymentMethodType.creditCard => 'Kartu Kredit',
    PaymentMethodType.debitCard => 'Kartu Debit',
    PaymentMethodType.credit => 'Kredit',
  };

  /// Parse wire value dari backend; `null` bila nilainya belum dikenal.
  ///
  /// Sengaja tidak fallback ke nilai default: bila backend menambah metode
  /// baru, data lama harus tetap terbaca apa adanya daripada disamarkan
  /// jadi metode lain.
  static PaymentMethodType? fromRaw(String? raw) {
    for (final method in PaymentMethodType.values) {
      if (method.rawValue == raw) return method;
    }
    return null;
  }
}
