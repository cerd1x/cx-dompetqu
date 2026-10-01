import 'package:flutter/material.dart';

import '../models/product.dart';

/// Tab layar order/transaksi — padanan tab di
/// `_routes/dompet/create-transaction/+page.svelte`.
///
/// [bookkeeping] dan [debt] adalah laporan, [sale]/[expense]/[loan] adalah form
/// pembuatan transaksi. Tab laporan dibuka lebih dulu secara default.
enum OrderTab {
  bookkeeping(label: 'Bookkeeping', icon: Icons.menu_book_outlined),
  debt(label: 'Debt', icon: Icons.receipt_long_outlined),
  sale(label: 'Sale', icon: Icons.sell_outlined),
  expense(label: 'Expense', icon: Icons.money_off_outlined),
  loan(label: 'Loan', icon: Icons.request_quote_outlined);

  const OrderTab({required this.label, required this.icon});

  /// Nama tab yang tampil di header dan pemilih tab.
  final String label;

  /// Ikon pembuka label tab.
  final IconData icon;

  /// Tab form membuat transaksi; tab lain hanya menampilkan laporan.
  bool get isForm => switch (this) {
    OrderTab.sale || OrderTab.expense || OrderTab.loan => true,
    OrderTab.bookkeeping || OrderTab.debt => false,
  };

  /// Tab tujuan untuk nilai query path/url, mis. `/order/sale`.
  String get slug => name;

  /// Men parsingkan kembali nilai [slug] (atau label) menjadi enum.
  ///
  /// Nilai tidak dikenal jatuh ke [fallback] supaya route yang rusak tidak
  /// membuat aplikasi crash.
  static OrderTab fromSlug(
    String? value, {
    OrderTab fallback = OrderTab.bookkeeping,
  }) {
    if (value == null || value.isEmpty) return fallback;
    final q = value.trim().toLowerCase();
    for (final tab in values) {
      if (tab.slug == q || tab.label.toLowerCase() == q) return tab;
    }
    return fallback;
  }
}

/// Argumen navigasi ke `OrderScreen` — Serializable lewat `GoRouter.extra`.
///
/// Setiap tab punya named constructor sehingga pemanggil tidak perlu tahu
/// tab mana yang harus dibuka sekaligus parameter spesifiknya apa:
///
/// ```dart
/// // dari detail produk, buka form Sale yang sudah terisi produknya
/// context.push('/order', extra: OrderRouteArgs.sale(product: product));
///
/// // dari dashboard, buka form Expense kosong
/// context.push('/order', extra: const OrderRouteArgs.expense());
/// ```
class OrderRouteArgs {
  const OrderRouteArgs({required this.tab, this.product});

  /// Membuka tab [OrderTab.sale] tanpa produk terpilih.
  const OrderRouteArgs.sale({this.product}) : tab = OrderTab.sale;

  /// Membuka tab [OrderTab.expense].
  const OrderRouteArgs.expense() : tab = OrderTab.expense, product = null;

  /// Membuka tab [OrderTab.loan].
  const OrderRouteArgs.loan() : tab = OrderTab.loan, product = null;

  /// Membuka tab [OrderTab.debt].
  const OrderRouteArgs.debt() : tab = OrderTab.debt, product = null;

  /// Membuka tab [OrderTab.bookkeeping].
  const OrderRouteArgs.bookkeeping()
    : tab = OrderTab.bookkeeping,
      product = null;

  /// Tab yang harus aktif saat layar dibuka.
  final OrderTab tab;

  /// Produk yang dipakai mengisi form [OrderTab.sale] — dikirim dari tombol
  /// "Buy" di detail produk.
  final Product? product;

  @override
  bool operator ==(Object other) =>
      other is OrderRouteArgs && other.tab == tab && other.product == product;

  @override
  int get hashCode => Object.hash(tab, product);

  @override
  String toString() => 'OrderRouteArgs(tab: $tab, product: ${product?.name})';
}
