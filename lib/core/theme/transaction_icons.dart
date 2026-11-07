import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

/// Tipe transaksi — padanan field `type` di Transaction model.
enum TransactionType {
  income,
  credit,
  debit,
  eb,
  adm,
  transfer,
  expense,
  unknown;

  /// Parse dari string type backend.
  static TransactionType fromString(String type) {
    return switch (type.toLowerCase()) {
      'income' => TransactionType.income,
      'credit' || 'cr' => TransactionType.credit,
      'debit' || 'db' => TransactionType.debit,
      'eb' => TransactionType.eb,
      'adm' => TransactionType.adm,
      'transfer' || 'tf' => TransactionType.transfer,
      'expense' => TransactionType.expense,
      _ => TransactionType.unknown,
    };
  }
}

/// Extension untuk icon, color, dan sign per tipe transaksi.
extension TransactionTypeUI on TransactionType {
  /// Icon hugeicons untuk transaksi.
  List<List<dynamic>> get icon {
    return switch (this) {
      TransactionType.income => HugeIcons.strokeRoundedMoneyReceiveCircle,
      TransactionType.credit => HugeIcons.strokeRoundedCreditCard,
      TransactionType.debit => HugeIcons.strokeRoundedCreditCard,
      TransactionType.eb => HugeIcons.strokeRoundedCloudBackup,
      TransactionType.adm => HugeIcons.strokeRoundedCloudBackup,
      TransactionType.transfer => HugeIcons.strokeRoundedCoinsSwap,
      TransactionType.expense => HugeIcons.strokeRoundedMoneySendCircle,
      TransactionType.unknown => HugeIcons.strokeRoundedCircleQuestionMark,
    };
  }

  /// Warna untuk icon/badge.
  Color get color {
    return switch (this) {
      TransactionType.income ||
      TransactionType.credit => const Color(0xFF34D399),
      TransactionType.expense ||
      TransactionType.debit => const Color(0xFFF87171),
      _ => const Color(0xFFFBBF24),
    };
  }

  /// Sign prefix untuk amount ('+', '-', '').
  String get sign {
    return switch (this) {
      TransactionType.income || TransactionType.credit => '+',
      TransactionType.expense || TransactionType.debit => '-',
      _ => '',
    };
  }
}
