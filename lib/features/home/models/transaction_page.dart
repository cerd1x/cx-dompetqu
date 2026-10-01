import 'transaction.dart';

/// Navigasi halaman — padanan `PageInfo` di schema GraphQL.
class TransactionPageInfo {
  const TransactionPageInfo({
    required this.hasNextPage,
    required this.hasPreviousPage,
    this.startCursor,
    this.endCursor,
  });

  final bool hasNextPage;
  final bool hasPreviousPage;
  final String? startCursor;
  final String? endCursor;

  factory TransactionPageInfo.fromJson(Map<String, dynamic> json) =>
      TransactionPageInfo(
        hasNextPage: json['hasNextPage'] as bool? ?? false,
        hasPreviousPage: json['hasPreviousPage'] as bool? ?? false,
        startCursor: json['startCursor']?.toString(),
        endCursor: json['endCursor']?.toString(),
      );
}

/// Satu baris halaman beserta cursor opaque-nya — padanan `TransactionEdge`.
class TransactionEdge {
  const TransactionEdge({required this.cursor, required this.node});

  final String cursor;
  final Transaction node;

  factory TransactionEdge.fromJson(Map<String, dynamic> json) {
    final node = json['node'];
    if (node is! Map<String, dynamic>) {
      throw const FormatException('TransactionEdge: `node` wajib diisi');
    }
    return TransactionEdge(
      cursor: json['cursor']?.toString() ?? '',
      node: Transaction.fromJson(node),
    );
  }
}

/// Satu halaman transaksi — padanan `TransactionPage` yang diekspos sebagai
/// `TransactionConnection` lewat query `transactionConnection`.
///
/// Kursor bersifat opaque (base64url dari posisi createdAt+id) dan **tidak boleh**
/// dibuat-buat di sisi klien: teruskan apa adanya ke [cursor] berikutnya.
class TransactionPage {
  const TransactionPage({required this.edges, required this.pageInfo});

  const TransactionPage.empty()
      : edges = const [],
        pageInfo = const TransactionPageInfo(
          hasNextPage: false,
          hasPreviousPage: false,
        );

  final List<TransactionEdge> edges;
  final TransactionPageInfo pageInfo;

  /// Transaksi pada halaman ini, urut `createdAt DESC, id DESC` (terbaru dulu).
  List<Transaction> get items =>
      edges.map((e) => e.node).toList(growable: false);

  /// Cursor tiap edge, sejajar dengan [items].
  List<String> get cursors =>
      edges.map((e) => e.cursor).toList(growable: false);

  bool get hasNextPage => pageInfo.hasNextPage;
  bool get hasPreviousPage => pageInfo.hasPreviousPage;

  /// Cursor untuk halaman berikutnya (null jika tidak ada halaman lagi).
  String? get nextCursor => pageInfo.endCursor;

  /// Cursor untuk halaman sebelumnya (null jika sudah di awal).
  String? get previousCursor => pageInfo.startCursor;

  bool get isEmpty => edges.isEmpty;

  factory TransactionPage.fromJson(Map<String, dynamic> json) {
    final rawEdges = json['edges'];
    if (rawEdges is! List) {
      throw const FormatException('TransactionPage: `edges` harus berupa list');
    }
    final rawPageInfo = json['pageInfo'];
    if (rawPageInfo is! Map<String, dynamic>) {
      throw const FormatException('TransactionPage: `pageInfo` wajib diisi');
    }
    return TransactionPage(
      edges: rawEdges
          .map((e) => TransactionEdge.fromJson(e as Map<String, dynamic>))
          .toList(growable: false),
      pageInfo: TransactionPageInfo.fromJson(rawPageInfo),
    );
  }
}