import 'package:flutter_test/flutter_test.dart';

import 'package:cx_dompetqiu/features/assets/adapters/models/asset.dart' as data;
import 'package:cx_dompetqiu/features/assets/adapters/models/asset_mutation.dart'
    as data;
import 'package:cx_dompetqiu/features/assets/domain/models/asset.dart'
    as domain;
import 'package:cx_dompetqiu/features/assets/domain/models/asset_type.dart';
import 'package:cx_dompetqiu/features/assets/view/stores/assets_store.dart';

void main() {
  group('Skenario tipe aset', () {
    test('fromRaw mengenali semua wire value dan mengabaikan kapitalisasi', () {
      expect(AssetType.fromRaw('bank'), AssetType.bank);
      expect(AssetType.fromRaw('EWALLET'), AssetType.ewallet);
      expect(AssetType.fromRaw('Cash'), AssetType.cash);
      expect(AssetType.fromRaw('crypto'), AssetType.crypto);
      expect(AssetType.fromRaw('loan'), AssetType.loan);
    });

    test('fromRaw mengembalikan null untuk tipe tak dikenal', () {
      expect(AssetType.fromRaw('saham'), isNull);
      expect(AssetType.fromRaw(null), isNull);
    });

    test('label tiap tipe terbaca di UI', () {
      expect(
        AssetType.values.map((e) => e.label).toList(),
        ['Bank', 'E-Wallet', 'Cash', 'Crypto', 'Loan'],
      );
    });
  });

  group('Skenario parsing aset', () {
    test('Asset.fromJson mengubah id numerik menjadi string', () {
      final asset = data.Asset.fromJson({
        'id': 42,
        'name': 'BCA',
        'type': 'bank',
        'balance': 'IDR 1.500.000',
      });

      expect(asset.id, '42');
      expect(asset.name, 'BCA');
      expect(asset.type, 'bank');
      expect(asset.balance, 'IDR 1.500.000');
    });

    test('Asset.fromJson memakai default saat field opsional hilang', () {
      final asset = data.Asset.fromJson({'id': 'a1', 'name': 'Dompet'});

      expect(asset.type, 'ewallet');
      expect(asset.balance, 'IDR 0');
    });

    test('AssetMutation.fromJson menormalkan angka dan tanggal', () {
      final mutation = data.AssetMutation.fromJson({
        'id': 'm1',
        'type': 'topup',
        'amount': 25000,
        'currency': 'IDR',
        'balanceBefore': 10000,
        'balanceAfter': 35000,
        'description': null,
        'createdAt': '2026-02-03T04:05:06.000Z',
      });

      expect(mutation.amount, '25000');
      expect(mutation.balanceBefore, '10000');
      expect(mutation.balanceAfter, '35000');
      expect(mutation.description, isNull);
      expect(mutation.createdAt, DateTime.utc(2026, 2, 3, 4, 5, 6));
    });

    test('AssetMutation.fromJson menganggap createdAt null sebagai null', () {
      final mutation = data.AssetMutation.fromJson({
        'id': 'm2',
        'type': 'adjust',
        'amount': null,
        'currency': 'IDR',
        'balanceBefore': null,
        'balanceAfter': null,
        'createdAt': null,
      });

      expect(mutation.amount, '');
      expect(mutation.balanceBefore, '');
      expect(mutation.balanceAfter, '');
      expect(mutation.createdAt, isNull);
    });
  });

  group('Skenario pencarian aset', () {
    final items = [
      const domain.Asset(id: '1', name: 'BCA Tahapan', type: 'bank'),
      const domain.Asset(id: '2', name: 'GoPay', type: 'ewallet'),
      const domain.Asset(id: '3', name: 'Dompet Tunai', type: 'cash'),
    ];

    test('query kosong mengembalikan semua item', () {
      final state = AssetsState(items: items);

      expect(state.filtered, items);
    });

    test('mencari berdasarkan nama tanpa peduli huruf besar/kecil', () {
      final state = AssetsState(items: items, searchQuery: '  gopay ');

      expect(state.filtered.map((a) => a.id), ['2']);
    });

    test('mencari berdasarkan tipe aset', () {
      final state = AssetsState(items: items, searchQuery: 'BANK');

      expect(state.filtered.map((a) => a.id), ['1']);
    });

    test('query tanpa hasil mengembalikan list kosong', () {
      final state = AssetsState(items: items, searchQuery: 'tidak-ada');

      expect(state.filtered, isEmpty);
    });

    test('copyWith mempertahankan nilai yang tidak diubah', () {
      final state = AssetsState(items: items, searchQuery: 'bank');

      final updated = state.copyWith(loading: false);

      expect(updated.items, items);
      expect(updated.searchQuery, 'bank');
      expect(updated.loading, isFalse);
    });
  });
}
