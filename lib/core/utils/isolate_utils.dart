/// Utilitas pemrosesan berat di isolates terpisah agar UI isolate tidak
/// membeku saat parsing JSON massal (daftar transaksi/order besar).
///
/// Fungsi di sini harus top-level / static agar bisa dipindahkan antar isolate
/// lewat [dart:isolate compute]. Jangan melewatkan instance `GraphQLClient`,
/// `HttpClient`, atau objek stateful lain — buat ulang di dalam fungsi isolate
/// bila butuh jaringan di sana.
library;

import 'dart:convert';

/// Parsing massal daftar transaksi dari JSON mentah di isolate terpisah.
///
/// [jsonList] berupa `List<dynamic>` hasil `jsonDecode` dari response server.
/// Mengembalikan `List<Map<String, dynamic>>` yang siap dikonversi oleh
/// `Transaction.fromJson` / `TransactionEdge.fromJson` di UI isolate.
List<Map<String, dynamic>> parseTransactionPageJson(List<dynamic> jsonList) {
  return jsonList
      .whereType<Map<String, dynamic>>()
      .toList(growable: false);
}

/// Dekode JSON string ke objek Dart di isolate terpisah.
///
/// Cocok untuk body response HTTP/GraphQL yang besar. Hasilnya adalah
/// `Map<String, dynamic>` atau `List<dynamic>` sesuai struktur JSON.
dynamic decodeJson(String json) {
  return jsonDecode(json);
}
