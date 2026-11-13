import 'package:flutter_test/flutter_test.dart';

import 'package:cx_dompetqiu/features/inventory/adapters/models/product.dart'
    as data;
import 'package:cx_dompetqiu/features/inventory/domain/models/product.dart';

void main() {
  group('Skenario stok produk', () {
    test('stok rendah hanya bila tracking aktif dan stok < 5', () {
      const low = Product(name: 'Kopi', stock: 4, trackStock: true);
      const boundary = Product(name: 'Kopi', stock: 5, trackStock: true);
      const high = Product(name: 'Kopi', stock: 6, trackStock: true);

      expect(low.isLowStock, isTrue);
      expect(boundary.isLowStock, isFalse);
      expect(high.isLowStock, isFalse);
    });

    test('tanpa tracking stok tidak pernah dianggap rendah', () {
      const product = Product(name: 'Digital', stock: 0, trackStock: false);

      expect(product.isLowStock, isFalse);
      expect(product.stockLabel, 'Unlimited');
    });

    test('label stok menampilkan angka saat tracking aktif', () {
      expect(
        const Product(name: 'Kopi', stock: 3, trackStock: true).stockLabel,
        '3',
      );
    });

    test('default produk', () {
      const product = Product(name: 'Baru');

      expect(product.price, 0);
      expect(product.currency, 'IDR');
      expect(product.stock, 0);
      expect(product.trackStock, isFalse);
      expect(product.id, isNull);
    });
  });

  group('Skenario parsing produk', () {
    test('fromJson mengubah id numerik dan stok pecahan', () {
      final product = data.Product.fromJson({
        'id': 12,
        'name': 'Kopi Susu',
        'price': 25000,
        'capital': 15000,
        'stock': 4.0,
        'trackStock': true,
        'createdAt': '2026-01-02T03:04:05.000Z',
      });

      expect(product.id, '12');
      expect(product.price, 25000);
      expect(product.stock, 4);
      expect(product.isLowStock, isTrue);
      expect(product.createdAt, DateTime.utc(2026, 1, 2, 3, 4, 5));
    });

    test('field opsional hilang memakai default', () {
      final product = data.Product.fromJson({'name': 'Minimal'});

      expect(product.id, isNull);
      expect(product.price, 0);
      expect(product.currency, 'IDR');
      expect(product.stock, 0);
      expect(product.trackStock, isFalse);
      expect(product.createdAt, isNull);
      expect(product.updatedAt, isNull);
    });

    test('tanggal invalid menjadi null', () {
      final product = data.Product.fromJson({
        'name': 'Kopi',
        'createdAt': 'bukan-tanggal',
      });

      expect(product.createdAt, isNull);
    });

    test('stock null menjadi 0', () {
      final product = data.Product.fromJson({'name': 'Kopi', 'stock': null});

      expect(product.stock, 0);
    });
  });
}
