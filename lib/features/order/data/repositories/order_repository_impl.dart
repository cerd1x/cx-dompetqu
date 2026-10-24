import '../../domain/repositories/order_repository.dart';
import '../datasources/order_datasource.dart';

class OrderRepositoryImpl implements OrderRepository {
  const OrderRepositoryImpl(this._remoteSource);

  final OrderDataSource _remoteSource;

  @override
  Future<bool> createDebtPayment({
    required num totalAmount,
    required String currency,
    required String customerId,
    required String description,
    String paymentMethod = 'cash',
  }) => _remoteSource.createDebtPayment(
    totalAmount: totalAmount,
    currency: currency,
    customerId: customerId,
    description: description,
    paymentMethod: paymentMethod,
  );

  @override
  Future<bool> createProductSale({
    required String productId,
    required int itemCount,
    required num totalAmount,
    required String currency,
    String? paymentMethod,
    String? customerId,
    String? description,
    String? payWithAssetId,
    String? payToAssetId,
    String? paymentStatus,
  }) {
    final effectivePayWithAssetId =
        (payWithAssetId != null && payWithAssetId.isNotEmpty)
        ? payWithAssetId
        : ((payToAssetId != null && payToAssetId.isNotEmpty) ? payToAssetId : null);
    return _remoteSource.createProductSale(
      productId: productId,
      itemCount: itemCount,
      totalAmount: totalAmount,
      currency: currency,
      paymentMethod: paymentMethod,
      customerId: customerId,
      description: description,
      payWithAssetId: effectivePayWithAssetId,
      payToAssetId: effectivePayWithAssetId,
      paymentStatus: paymentStatus,
    );
  }

  @override
  Future<bool> createExpense({
    required num totalAmount,
    required String currency,
    required int itemCount,
    String? description,
    String? paymentMethod,
    String? customerId,
    String? payWithAssetId,
    String? payToAssetId,
  }) => _remoteSource.createExpense(
    totalAmount: totalAmount,
    currency: currency,
    itemCount: itemCount,
    description: description,
    paymentMethod: paymentMethod,
    customerId: customerId,
    payWithAssetId: payWithAssetId,
    payToAssetId: payToAssetId,
  );

  @override
  Future<bool> createLoan({
    required num totalAmount,
    required String currency,
    required int itemCount,
    String? paymentMethod,
    String? customerId,
    String? description,
    String? payWithAssetId,
    String? paymentStatus,
  }) => _remoteSource.createLoan(
    totalAmount: totalAmount,
    currency: currency,
    itemCount: itemCount,
    paymentMethod: paymentMethod,
    customerId: customerId,
    description: description,
    payWithAssetId: payWithAssetId,
    paymentStatus: paymentStatus,
  );
}
