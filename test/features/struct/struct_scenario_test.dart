import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:cx_dompetqiu/features/struct/view/screens/struct_detail_screen.dart';
import 'package:cx_dompetqiu/features/transactions/domain/models/transaction.dart';

Transaction _tx({
  required String type,
  required String amount,
  String status = 'success',
  String? description,
}) => Transaction(
  id: 'tx-struct-1',
  type: type,
  amount: amount,
  status: status,
  description: description,
  category: 'Penjualan',
  createdAt: DateTime(2026, 3, 4, 15, 30),
);

Future<void> _pump(WidgetTester tester, Transaction tx) async {
  await tester.pumpWidget(
    MaterialApp(home: StructDetailScreen(transaction: tx)),
  );
  await tester.pump();
}

void main() {
  testWidgets('menampilkan struktur transaksi pemasukan', (tester) async {
    await _pump(
      tester,
      _tx(
        type: 'income',
        amount: 'IDR 150000',
        description: 'Gaji bulanan',
      ),
    );

    expect(find.text('Detail Struktur'), findsOneWidget);
    // Teks muncul di header kartu dan baris detail.
    expect(find.text('Gaji bulanan'), findsWidgets);
    expect(find.text('tx-struct-1'), findsOneWidget);
    expect(find.text('INCOME'), findsOneWidget);
    expect(find.text('SUCCESS'), findsOneWidget);
    expect(find.text('Penjualan'), findsOneWidget);

    // Tombol ada di bawah ListView — gulir sampai terlihat.
    await tester.scrollUntilVisible(
      find.text('Simpan Struktur ke PNG'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Simpan Struktur ke PNG'), findsOneWidget);
  });

  testWidgets('menampilkan struktur transaksi pengeluaran', (tester) async {
    await _pump(
      tester,
      _tx(
        type: 'expense',
        amount: 'IDR 25000',
        status: 'pending',
        description: 'Beli kopi',
      ),
    );

    expect(find.text('Beli kopi'), findsWidgets);
    expect(find.text('EXPENSE'), findsOneWidget);
    expect(find.text('PENDING'), findsOneWidget);
  });

  testWidgets('tipe tak dikenal tetap dirender dengan status apa adanya', (
    tester,
  ) async {
    await _pump(
      tester,
      _tx(type: 'transfer', amount: 'IDR 1000', status: 'failed'),
    );

    expect(find.text('TRANSFER'), findsOneWidget);
    expect(find.text('FAILED'), findsOneWidget);
    // displayName fallback ke kategori bila deskripsi null — tampil di
    // header kartu dan baris detail.
    expect(find.text('Penjualan'), findsWidgets);
  });
}
