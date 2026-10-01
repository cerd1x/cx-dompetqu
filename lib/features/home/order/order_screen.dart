import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/widgets/dompet_gradient_background.dart';
import '../models/product.dart';
import 'ExpenseForm.dart';
import 'LoanForm.dart';
import 'SaleForm.dart';

enum _OrderTab { sale, expense, loan }

/// Layar buat transaksi/order dengan 3 tab — padanan
/// `_routes/dompet/create-transaction/+page.svelte` (Sale/Expense/Loan).
class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key, this.product});

  /// Produk yang dibeli dari tombol "Buy" di detail produk.
  final Product? product;

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  _OrderTab _tab = _OrderTab.sale;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DompetGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // header section
              _buildHeader(context),
              // tab selector section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _TabSelector(
                  tab: _tab,
                  onChanged: (t) => setState(() => _tab = t),
                ),
              ),
              const SizedBox(height: 12),
              // form section — IndexedStack menjaga state tiap tab tetap hidup
              Expanded(
                child: IndexedStack(
                  index: _tab.index,
                  children: [
                    _ScrollingForm(child: SaleForm(product: widget.product)),
                    const _ScrollingForm(child: ExpenseForm()),
                    const _ScrollingForm(child: LoanForm()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          // back button section
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => context.pop(),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.06),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Create Transaction',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
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

/// Segmented tab Sale/Expense/Loan — padanan tab `create-transaction/+page.svelte`.
class _TabSelector extends StatelessWidget {
  const _TabSelector({required this.tab, required this.onChanged});

  final _OrderTab tab;
  final ValueChanged<_OrderTab> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = {
      _OrderTab.sale: 'Sale',
      _OrderTab.expense: 'Expense',
      _OrderTab.loan: 'Loan',
    };
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          for (final entry in tabs.entries)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(entry.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    gradient: tab == entry.key
                        ? const LinearGradient(
                            colors: [Color(0xFFF97316), Color(0xFFEC4899)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    entry.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: tab == entry.key ? Colors.white : Colors.white38,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
