import 'package:flutter/foundation.dart';
import 'package:dompetqu/core/utils/isolate_utils.dart';
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

  /// Versi sinkron: `edges` di-parse langsung di isolate pemanggil.
  ///
  /// Pakai [fromJsonAsync] pada jalur async (alur normal `transactionsPage`)
  /// agar payload halaman besar tidak memblokir UI isolate.
  factory TransactionPage.fromJson(Map<String, dynamic> json) {
    return TransactionPage(
      edges: _parseEdges(_readEdges(json)),
      pageInfo: _readPageInfo(json),
    );
  }

  /// Versi async: memfilter `edges` di isolate terpisah lewat [compute].
  ///
  /// Dipisah dari [fromJson] karena `compute` mengembalikan `Future`, sedangkan
  /// factory sinkron tidak bisa `await`.
  static Future<TransactionPage> fromJsonAsync(
    Map<String, dynamic> json,
  ) async {
    final edges = await _parseEdgesInIsolate(_readEdges(json));
    return TransactionPage(edges: edges, pageInfo: _readPageInfo(json));
  }

  static List<dynamic> _readEdges(Map<String, dynamic> json) {
    final rawEdges = json['edges'];
    if (rawEdges is! List) {
      throw const FormatException('TransactionPage: `edges` harus berupa list');
    }
    return rawEdges;
  }

  static TransactionPageInfo _readPageInfo(Map<String, dynamic> json) {
    final rawPageInfo = json['pageInfo'];
    if (rawPageInfo is! Map<String, dynamic>) {
      throw const FormatException('TransactionPage: `pageInfo` wajib diisi');
    }
    return TransactionPageInfo.fromJson(rawPageInfo);
  }

  static List<TransactionEdge> _parseEdges(List<dynamic> rawEdges) {
    return rawEdges
        .map((e) => TransactionEdge.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  /// Parsing daftar `edges` di isolate terpisah agar UI isolate tidak diblokir
  /// saat payload halaman transaksi besar (biasanya beratus-ratus item).
  ///
  /// [rawEdges] adalah `List<dynamic>` mentah dari JSON — fungsi ini dipindah
  /// ke isolate lain via [compute] (top-level dart:isolate), lalu hasilnya
  /// dikonversi kembali menjadi `List<TransactionEdge>` di UI isolate (konversi
  /// per-item ringan dan aman dilakukan di sini karena objek hasil decode sudah
  /// terpisah).
  static Future<List<TransactionEdge>> _parseEdgesInIsolate(
    List<dynamic> rawEdges,
  ) async {
    final parsed = await compute(parseTransactionPageJson, rawEdges);
    return _parseEdges(parsed as List<dynamic>);
  }
}
