import 'package:dompetqu/features/assets/domain/models/asset.dart';
import 'package:dompetqu/features/assets/domain/models/asset_mutation.dart';
import 'package:dompetqu/features/contacts/domain/models/contact.dart';
import 'package:dompetqu/features/contacts/domain/models/contact_page.dart';
import 'package:dompetqu/features/inventory/domain/entities/product.dart';
import 'package:dompetqu/features/statistics/domain/entities/statistics.dart';
import 'package:dompetqu/features/transactions/domain/entities/transaction.dart';
import 'package:dompetqu/features/transactions/domain/entities/transaction_page.dart';

abstract interface class HomeRepository {
  Future<List<Asset>> assets();
  Future<Asset> createAsset({
    required String name,
    required String type,
    required String balance,
  });
  Future<Asset> updateAsset(
    String id, {
    String? name,
    String? type,
    String? balance,
  });
  Future<bool> deleteAsset(String name);
  Future<Asset> addBalance(String assetId, String amount);
  Future<({Asset from, Asset to})> swapBalance(
    String fromAssetId,
    String toAssetId,
    String amount,
  );
  Future<List<AssetMutation>> assetMutations(String assetId);

  Future<List<Contact>> contacts();
  Future<ContactPage> contactsPage({
    int? first,
    String? after,
    int? last,
    String? before,
  });
  Future<Contact> createContact({
    required String name,
    String? email,
    String? phone,
    List<String>? phones,
    String? group,
  });
  Future<Contact> updateContact(
    String id, {
    String? name,
    String? email,
    String? phone,
    List<String>? phones,
  });
  Future<bool> deleteContact(String id);

  Future<List<Product>> products();
  Future<Product> createProduct({
    required String name,
    String? description,
    required num price,
    num? capital,
    int stock = 0,
    bool trackStock = false,
  });
  Future<Product> updateProduct(
    String id, {
    String? name,
    String? description,
    num? price,
    num? capital,
    int? stock,
    bool? trackStock,
  });
  Future<bool> deleteProduct(String id);

  Future<Statistics> statistics();
  Future<List<Transaction>> transactions();
  Future<TransactionPage> transactionsPage({
    int? first,
    String? after,
    int? last,
    String? before,
  });

  /// Ubah status pembayaran transaksi (`paid`/`unpaid`) — padanan mutation
  /// `updateTransaction` di `services/domain/transactions`.
  Future<Transaction> updatePaymentStatus(
    String id, {
    required String paymentStatus,
    String? customerId,
  });
}
