import 'package:dompetqu/features/assets/domain/entities/asset.dart' as domain;
import 'package:dompetqu/features/assets/domain/entities/asset_mutation.dart'
    as domain;
import 'package:dompetqu/features/contacts/domain/entities/contact.dart'
    as domain;
import 'package:dompetqu/features/contacts/domain/entities/contact_page.dart'
    as domain;
import 'package:dompetqu/features/dashboard/domain/repositories/home_repository.dart';
import 'package:dompetqu/features/inventory/domain/entities/product.dart'
    as domain;
import 'package:dompetqu/features/statistics/domain/entities/statistics.dart'
    as domain;
import 'package:dompetqu/features/transactions/domain/entities/transaction.dart'
    as domain;
import 'package:dompetqu/features/transactions/domain/entities/transaction_page.dart'
    as domain;
import '../datasources/home_datasources.dart';
import '../mappers/home_model_mapper.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(
    this._assets,
    this._contacts,
    this._inventory,
    this._statistics,
    this._transactions,
  );

  final AssetsDataSource _assets;
  final ContactsDataSource _contacts;
  final InventoryDataSource _inventory;
  final StatisticsDataSource _statistics;
  final TransactionsDataSource _transactions;

  @override
  Future<List<domain.Asset>> assets() async =>
      (await _assets.assets()).map((model) => model.toEntity()).toList();

  @override
  Future<domain.Asset> createAsset({
    required String name,
    required String type,
    required String balance,
  }) async => (await _assets.create(
    name: name,
    type: type,
    balance: balance,
  )).toEntity();

  @override
  Future<domain.Asset> updateAsset(
    String id, {
    String? name,
    String? type,
    String? balance,
  }) async => (await _assets.update(
    id,
    name: name,
    type: type,
    balance: balance,
  )).toEntity();

  @override
  Future<bool> deleteAsset(String name) => _assets.delete(name);

  @override
  Future<domain.Asset> addBalance(String assetId, String amount) async =>
      (await _assets.addBalance(assetId, amount)).toEntity();

  @override
  Future<({domain.Asset from, domain.Asset to})> swapBalance(
    String fromAssetId,
    String toAssetId,
    String amount,
  ) async {
    final result = await _assets.swapBalance(fromAssetId, toAssetId, amount);
    return (from: result.from.toEntity(), to: result.to.toEntity());
  }

  @override
  Future<List<domain.AssetMutation>> assetMutations(String assetId) async =>
      (await _assets.assetMutations(
        assetId,
      )).map((model) => model.toEntity()).toList();

  @override
  Future<List<domain.Contact>> contacts() async =>
      (await _contacts.contacts()).map((model) => model.toEntity()).toList();

  @override
  Future<domain.ContactPage> contactsPage({
    int? first,
    String? after,
    int? last,
    String? before,
  }) async => (await _contacts.contactsPage(
    first: first,
    after: after,
    last: last,
    before: before,
  )).toEntity();

  @override
  Future<domain.Contact> createContact({
    required String name,
    String? email,
    String? phone,
    List<String>? phones,
    String? group,
  }) async => (await _contacts.create(
    name: name,
    email: email,
    phone: phone,
    phones: phones,
    group: group,
  )).toEntity();

  @override
  Future<domain.Contact> updateContact(
    String id, {
    String? name,
    String? email,
    String? phone,
    List<String>? phones,
  }) async => (await _contacts.update(
    id,
    name: name,
    email: email,
    phone: phone,
    phones: phones,
  )).toEntity();

  @override
  Future<bool> deleteContact(String id) => _contacts.delete(id);

  @override
  Future<List<domain.Product>> products() async =>
      (await _inventory.products()).map((model) => model.toEntity()).toList();

  @override
  Future<domain.Product> createProduct({
    required String name,
    String? description,
    required num price,
    num? capital,
    int stock = 0,
    bool trackStock = false,
  }) async => (await _inventory.create(
    name: name,
    description: description,
    price: price,
    capital: capital,
    stock: stock,
    trackStock: trackStock,
  )).toEntity();

  @override
  Future<domain.Product> updateProduct(
    String id, {
    String? name,
    String? description,
    num? price,
    num? capital,
    int? stock,
    bool? trackStock,
  }) async => (await _inventory.update(
    id,
    name: name,
    description: description,
    price: price,
    capital: capital,
    stock: stock,
    trackStock: trackStock,
  )).toEntity();

  @override
  Future<bool> deleteProduct(String id) => _inventory.delete(id);

  @override
  Future<domain.Statistics> statistics() async =>
      (await _statistics.statistics()).toEntity();

  @override
  Future<List<domain.Transaction>> transactions() async =>
      (await _transactions.transactions())
          .map((model) => model.toEntity())
          .toList();

  @override
  Future<domain.TransactionPage> transactionsPage({
    int? first,
    String? after,
    int? last,
    String? before,
  }) async => (await _transactions.transactionsPage(
    first: first,
    after: after,
    last: last,
    before: before,
  )).toEntity();
}
