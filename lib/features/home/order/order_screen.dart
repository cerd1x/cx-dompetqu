import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/dompet_brand.dart';
import '../../../core/theme/widgets/dompet_gradient_background.dart';
import '../models/product.dart';
import '../widgets/bottom_bar.dart';
import 'BookkeepingTab.dart';
import 'DebtTab.dart';
import 'ExpenseForm.dart';
import 'LoanForm.dart';
import 'order_tab.dart';
import 'SaleForm.dart';

/// Layar buat transaksi/order — padanan
/// `_routes/dompet/create-transaction/+page.svelte` (Sale/Expense/Loan),
/// ditambah tab laporan **Bookkeeping** (buku besar) dan **Debt** (utang).
class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({
    super.key,
    this.initialTab = OrderTab.bookkeeping,
    this.product,
    this.embedded = false,
  });

  /// Tab yang aktif saat layar dibuka — dipilih lewat nama enum
  /// (`OrderTab.sale`, `OrderTab.expense`, dst).
  final OrderTab initialTab;

  /// Produk yang dibeli dari tombol "Buy" di detail produk; dipakai form
  /// [OrderTab.sale].
  final Product? product;

  /// Saat `true`, layar ini dipasang sebagai tab di dalam `HomeShell` sehingga
  /// latar, safe area, dan navigasi ditangani oleh shell (tanpa tombol back).
  final bool embedded;

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  late OrderTab _tab = widget.initialTab;

  @override
  void didUpdateWidget(covariant OrderScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTab != widget.initialTab) _tab = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        // header section
        _buildHeader(context),
        const SizedBox(height: 8),
        // form section — IndexedStack menjaga state tiap tab tetap hidup
        Expanded(
          child: IndexedStack(
            index: _tab.index,
            children: [
              // laporan: manages its own scroll + filter state
              const _ReportBody(child: BookkeepingTab()),
              const _ReportBody(child: DebtTab()),
              _ScrollingForm(child: SaleForm(product: widget.product)),
              const _ScrollingForm(child: ExpenseForm()),
              const _ScrollingForm(child: LoanForm()),
            ],
          ),
        ),
        // tab selector section — sticky di bawah konten
        TabBottomBar(child: _buildTabSelector()),
      ],
    );

    // Sebagai tab di HomeShell, shell sudah menyediakan Scaffold, gradient, dan
    // safe area — cukup kirim kontennya apa adanya.
    if (widget.embedded) return content;

    return Scaffold(
      body: DompetGradientBackground(child: SafeArea(child: content)),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final entry in OrderTab.values)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: GestureDetector(
                  onTap: () => setState(() => _tab = entry),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: _tab == entry
                          ? const LinearGradient(
                              colors: [Color(0xFFF97316), Color(0xFFEC4899)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )
                          : null,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          entry.icon,
                          size: 15,
                          color: _tab == entry ? Colors.white : Colors.white38,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          entry.label,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _tab == entry ? Colors.white : Colors.white38,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(widget.embedded ? 20 : 8, 8, 16, 8),
      child: Row(
        children: [
          // back button section
          if (!widget.embedded) ...[
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => context.pop(),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.06),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Row(
              children: [
                Icon(_tab.icon, size: 20, color: DompetBrand.gold),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _tab.isForm ? 'Create Transaction' : _tab.label,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          if (widget.product != null)
            Text(
              widget.product!.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: Colors.white38),
            ),
        ],
      ),
    );
  }
}

class _ScrollingForm extends StatelessWidget {
  const _ScrollingForm({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: child,
    );
  }
}

/// Wrapper untuk tab laporan (Bookkeeping/Debt) — tanpa `SingleChildScrollView`
/// karena tab itu sudah punya daftar/scroll sendiri.
class _ReportBody extends StatelessWidget {
  const _ReportBody({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: child,
    );
  }
}

