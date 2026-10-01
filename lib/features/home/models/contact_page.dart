import 'contact.dart';

/// Navigasi halaman — padanan `PageInfo` di schema GraphQL.
class ContactPageInfo {
  const ContactPageInfo({
    required this.hasNextPage,
    required this.hasPreviousPage,
    this.startCursor,
    this.endCursor,
  });

  final bool hasNextPage;
  final bool hasPreviousPage;
  final String? startCursor;
  final String? endCursor;

  factory ContactPageInfo.fromJson(Map<String, dynamic> json) => ContactPageInfo(
        hasNextPage: json['hasNextPage'] as bool? ?? false,
        hasPreviousPage: json['hasPreviousPage'] as bool? ?? false,
        startCursor: json['startCursor']?.toString(),
        endCursor: json['endCursor']?.toString(),
      );
}

/// Satu baris halaman beserta cursor opaque-nya — padanan `ContactEdge`.
class ContactEdge {
  const ContactEdge({required this.cursor, required this.node});

  final String cursor;
  final Contact node;

  factory ContactEdge.fromJson(Map<String, dynamic> json) {
    final node = json['node'];
    if (node is! Map<String, dynamic>) {
      throw const FormatException('ContactEdge: `node` wajib diisi');
    }
    return ContactEdge(
      cursor: json['cursor']?.toString() ?? '',
      node: Contact.fromJson(node),
    );
  }
}

/// Satu halaman kontak — padanan `ContactPage` (`contact-page.model.ts`) yang
/// diekspos sebagai `ContactConnection` lewat query `contactConnection`.
///
/// Kursor bersifat opaque (base64url dari posisi id) dan **tidak boleh**
/// dibuat-buat di sisi klien: teruskan apa adanya ke [cursor] berikutnya.
class ContactPage {
  const ContactPage({required this.edges, required this.pageInfo});

  const ContactPage.empty()
      : edges = const [],
        pageInfo = const ContactPageInfo(
          hasNextPage: false,
          hasPreviousPage: false,
        );

  final List<ContactEdge> edges;
  final ContactPageInfo pageInfo;

  /// Kontak pada halaman ini, urut `id DESC` (terbaru dulu).
  List<Contact> get items =>
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

  factory ContactPage.fromJson(Map<String, dynamic> json) {
    final rawEdges = json['edges'];
    if (rawEdges is! List) {
      throw const FormatException('ContactPage: `edges` harus berupa list');
    }
    final rawPageInfo = json['pageInfo'];
    if (rawPageInfo is! Map<String, dynamic>) {
      throw const FormatException('ContactPage: `pageInfo` wajib diisi');
    }
    return ContactPage(
      edges: rawEdges
          .map((e) => ContactEdge.fromJson(e as Map<String, dynamic>))
          .toList(growable: false),
      pageInfo: ContactPageInfo.fromJson(rawPageInfo),
    );
  }
}
