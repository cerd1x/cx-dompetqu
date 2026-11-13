import 'package:cx_dompetqiu/features/assets/domain/models/asset.dart';
import 'package:cx_dompetqiu/features/transactions/domain/models/transaction.dart';

/// Kontrak perhitungan statistik keuangan — padanan `statistics_use_cases` web.
abstract interface class StatisticsRepository {
  /// Total pemasukan dari daftar transaksi.
  num totalIncome(List<Transaction> transactions);

  /// Total pengeluaran dari daftar transaksi.
  num totalExpense(List<Transaction> transactions);

  /// Total pinjaman dari daftar transaksi.
  num totalLoan(List<Transaction> transactions);

  /// Keuntungan bersih = totalIncome − totalExpense.
  num netProfit(List<Transaction> transactions);

  /// Total uang tunai dari transaksi dengan metode pembayaran `cash`.
  num totalCash(List<Transaction> transactions);

  /// Total aset dari daftar aset.
  num totalAsset(List<Asset> assets);
}
