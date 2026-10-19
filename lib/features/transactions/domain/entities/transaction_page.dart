import 'package:freezed_annotation/freezed_annotation.dart';

import 'transaction.dart';

part 'generated/transaction_page.freezed.dart';

/// Satu halaman transaksi pada domain — padanan data model
/// `features/transactions/data/models/transaction_page.dart` (tanpa JSON:
/// konversi ada di mapper/repository, bukan di domain).
@freezed
abstract class TransactionPage with _$TransactionPage {
  const factory TransactionPage({
    required List<Transaction> items,
    required bool hasNextPage,
    required String? nextCursor,
  }) = _TransactionPage;

  const TransactionPage._();
}
