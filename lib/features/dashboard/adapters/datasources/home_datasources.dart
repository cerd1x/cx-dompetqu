import 'package:dompetqu/features/assets/adapters/models/asset.dart';
import 'package:dompetqu/features/assets/adapters/models/asset_mutation.dart';
import 'package:dompetqu/features/contacts/adapters/models/contact.dart';
import 'package:dompetqu/features/contacts/adapters/models/contact_page.dart';
import 'package:dompetqu/features/inventory/data/models/product.dart';
import 'package:dompetqu/features/statistics/data/models/statistics.dart';
import 'package:dompetqu/features/transactions/data/models/transaction.dart';
import 'package:dompetqu/features/transactions/data/models/transaction_page.dart';

abstract interface class AssetsDataSource {
  Future<List<Asset>> assets();
  Future<Asset> create({
    required String name,
    required String type,
    required String balance,
  });
  Future<Asset> update(
    String id, {
    String? name,
    String? type,
    String? balance,
  });
  Future<bool> delete(String name);
  Future<Asset> addBalance(String assetId, String amount);
  Future<({Asset from, Asset to})> swapBalance(
    String fromAssetId,
    String toAssetId,
    String amount,
  );
  Future<List<AssetMutation>> assetMutations(String assetId);
}

abstract interface class ContactsDataSource {
  Future<List<Contact>> contacts();
  Future<ContactPage> contactsPage({
    int? first,
    String? after,
    int? last,
    String? before,
  });
  Future<Contact> create({
    required String name,
    String? email,
    String? phone,
    List<String>? phones,
    String? group,
  });
  Future<Contact> update(
    String id, {
    String? name,
    String? email,
    String? phone,
    List<String>? phones,
  });
  Future<bool> delete(String id);
}

abstract interface class InventoryDataSource {
  Future<List<Product>> products();
  Future<Product> create({
    required String name,
    String? description,
    required num price,
    num? capital,
    int stock = 0,
    bool trackStock = false,
  });
  Future<Product> update(
    String id, {
    String? name,
    String? description,
    num? price,
    num? capital,
    int? stock,
    bool? trackStock,
  });
  Future<bool> delete(String id);
}

abstract interface class StatisticsDataSource {
  Future<Statistics> statistics();
}

abstract interface class TransactionsDataSource {
  Future<List<Transaction>> transactions();
  Future<TransactionPage> transactionsPage({
    int? first,
    String? after,
    int? last,
    String? before,
  });

  /// Ubah status pembayaran satu transaksi — padanan mutation
  /// `updateTransaction` (`UpdateTransactionInput.paymentStatus`) di
  /// `services/domain/transactions`.
  Future<Transaction> updatePaymentStatus(
    String id, {
    required String paymentStatus,
    String? customerId,
  });
}
