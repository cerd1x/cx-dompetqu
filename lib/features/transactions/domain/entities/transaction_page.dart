import 'transaction.dart';

class TransactionPage {
  const TransactionPage({
    required this.items,
    required this.hasNextPage,
    required this.nextCursor,
  });

  final List<Transaction> items;
  final bool hasNextPage;
  final String? nextCursor;
}
