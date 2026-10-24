abstract interface class OrderRepository {
  Future<bool> createDebtPayment({
    required num totalAmount,
    required String currency,
    required String customerId,
    required String description,
    String paymentMethod = 'cash',
  });

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
    // Status pembayaran (`paid`/`unpaid`) — padanan `paymentStatus` di
    // `CreateOrderProductSaleInput` backend; default DB `unpaid`.
    String? paymentStatus,
  });

  Future<bool> createExpense({
    required num totalAmount,
    required String currency,
    required int itemCount,
    String? description,
    String? paymentMethod,
    String? customerId,
    String? payWithAssetId,
    String? payToAssetId,
  });

  Future<bool> createLoan({
    required num totalAmount,
    required String currency,
    required int itemCount,
    String? paymentMethod,
    String? customerId,
    String? description,
    String? payWithAssetId,
    // Status pembayaran (`paid`/`unpaid`) — padanan `paymentStatus` di
    // `CreateOrderLoanInput` backend; default DB `unpaid`.
    String? paymentStatus,
  });
}
