import 'package:flutter/material.dart';

import '../../../core/theme/dompet_brand.dart';
import '../../../core/theme/widgets/dompet_card.dart';
import '../../../core/utils/formatters.dart';
import '../assets/assets_screen.dart';
import '../widgets/search_field.dart';

class _Holding {
  const _Holding({
    required this.name,
    required this.symbol,
    required this.amount,
    required this.value,
    required this.change,
    required this.changePercent,
    required this.type,
  });

  final String name;
  final String symbol;
  final num amount;
  final num value;
  final num change;
  final num changePercent;
  final String type;

  IconData get icon => switch (type) {
    'stock' => Icons.show_chart,
    'crypto' => Icons.currency_bitcoin,
    'mutual' => Icons.donut_large,
    _ => Icons.location_city_outlined,
  };

  Color get badgeColor => switch (type) {
    'stock' => const Color(0xFF60A5FA),
    'crypto' => const Color(0xFFFBBF24),
    'mutual' => const Color(0xFF34D399),
    _ => const Color(0xFFA78BFA),
  };
}

const _holdings = [
  _Holding(
    name: 'Bitcoin',
    symbol: 'BTC',
    amount: 0.42,
    value: 285000000,
    change: 2500000,
    changePercent: 0.89,
    type: 'crypto',
  ),
  _Holding(
    name: 'Ethereum',
    symbol: 'ETH',
    amount: 5.5,
    value: 142000000,
    change: -1800000,
    changePercent: -1.25,
    type: 'crypto',
  ),
  _Holding(
    name: 'Saham BBCA',
    symbol: 'BBCA',
    amount: 500,
    value: 52500000,
    change: 750000,
    changePercent: 1.45,
    type: 'stock',
  ),
  _Holding(
    name: 'Saham TLKM',
    symbol: 'TLKM',
    amount: 2000,
    value: 8200000,
    change: -120000,
    changePercent: -1.44,
    type: 'stock',
  ),
  _Holding(
    name: 'Reksadana Syariah',
    symbol: 'RDS',
    amount: 1500,
    value: 18750000,
    change: 125000,
    changePercent: 0.67,
    type: 'mutual',
  ),
  _Holding(
    name: 'Tanah Kavling',
    symbol: 'TNH',
    amount: 1,
    value: 95000000,
    change: 5000000,
    changePercent: 5.56,
    type: 'property',
  ),
];

const _typeColors = {
  'stock': Color(0xFF3B82F6),
  'crypto': Color(0xFFF97316),
  'mutual': Color(0xFF22C55E),
  'property': Color(0xFFA855F7),
};

class _Project {
  const _Project(this.name, this.client, this.value, this.progress);
  final String name;
  final String client;
  final num value;
  final int progress;
}

const _projects = [
  _Project('Dompet Qu - Finance App', 'PT Fintech Indo', 185000000, 75),
  _Project('Togel Analyzer Dashboard', 'Personal Project', 95000000, 45),
  _Project('E-Commerce Storefront', 'PT Retail Maju', 250000000, 100),
  _Project('POS System Restoran', 'RM Padang Sejahtera', 75000000, 95),
  _Project('Company Profile Website', 'CV Karya Bersama', 35000000, 100),
  _Project('Mobile App Laundry', 'Laundry Kilat', 120000000, 30),
];

/// Padanan `_portofolio/PortfolioPage.svelte` (mock data — belum ada backend).
class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  int _tab = 0;
  String _search = '';
  String _typeFilter = 'all';
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<_Holding> get _filteredHoldings {
    final q = _search.trim().toLowerCase();
    return _holdings.where((h) {
      if (_typeFilter != 'all' && h.type != _typeFilter) return false;
      if (q.isEmpty) return true;
      return h.name.toLowerCase().contains(q) ||
          h.symbol.toLowerCase().contains(q);
    }).toList();
  }

  num get _totalValue => _holdings.fold<num>(0, (s, h) => s + h.value);

  num get _totalChange => _holdings.fold<num>(0, (s, h) => s + h.change);

  num get _totalChangePercent =>
      _totalValue > 0 ? (_totalChange / (_totalValue - _totalChange)) * 100 : 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        border: const Border(
          bottom: BorderSide(color: Color(0x4DFBBF24), width: 2),
        ),
        color: const Color(0xFF111111).withValues(alpha: 0.7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // header section
          _PortfolioHeader(),
          // content section — IndexedStack menjaga state tiap tab tetap hidup
          Expanded(
            child: IndexedStack(
              index: _tab,
              children: [
                const AssetsScreen(embedded: true),
                _buildInvestment(),
                _buildBusiness(),
              ],
            ),
          ),
          // tab bar section
          _PortfolioTabBar(
            current: _tab,
            onChanged: (i) => setState(() => _tab = i),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestment() {
    final filtered = _filteredHoldings;
    final total = _totalValue;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: [
        // summary section
        _SummaryCard(
          value: formatMoney(total, 'IDR'),
          change: formatMoney(_totalChange, 'IDR'),
          changePercent: _totalChangePercent,
          isUp: _totalChange >= 0,
        ),
        const SizedBox(height: 12),
        // allocation section
        _AllocationBar(holdings: _holdings, total: total),
        const SizedBox(height: 12),
        // search section
        Row(
          children: [
            Expanded(
              child: SearchField(
                controller: _searchCtrl,
                hint: 'Search holdings...',
                onChanged: (v) => setState(() => _search = v),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // filter chips section
        _FilterChips(
          selected: _typeFilter,
          onChanged: (v) => setState(() => _typeFilter = v),
        ),
        const SizedBox(height: 12),
        // holdings list section
        Text(
          'Holdings (${filtered.length})',
          style: const TextStyle(fontSize: 12, color: Colors.white38),
        ),
        const SizedBox(height: 6),
        if (filtered.isEmpty)
          const EmptyPortfolio()
        else
          for (var i = 0; i < filtered.length; i++) ...[
            _HoldingItem(holding: filtered[i]),
            if (i != filtered.length - 1) const SizedBox(height: 8),
          ],
      ],
    );
  }

  Widget _buildBusiness() {
    const metrics = [
      (label: 'Total Revenue', value: 'Rp 892.500.000', change: '+12.5%'),
      (label: 'Net Profit', value: 'Rp 345.200.000', change: '+8.3%'),
      (label: 'Active Projects', value: '12', change: '+3'),
      (label: 'Total Clients', value: '28', change: '+5'),
    ];
    final activeProjects = _projects
        .where((p) => p.progress < 100)
        .take(3)
        .toList();
    final totalProjectValue = _projects.fold<num>(0, (s, p) => s + p.value);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: [
        // metrics grid section
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.9,
          children: [
            for (final m in metrics)
              DompetCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m.value,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      m.label,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white38,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      m.change,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF34D399),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        // project pipeline section
        DompetCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Project Pipeline',
                style: TextStyle(fontSize: 12, color: Colors.white38),
              ),
              const SizedBox(height: 10),
              for (final p in activeProjects) ...[
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              value: p.progress / 100,
                              minHeight: 5,
                              backgroundColor: Colors.white10,
                              valueColor: const AlwaysStoppedAnimation(
                                Color(0xFFA855F7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      formatMoney(p.value, 'IDR'),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white38,
                      ),
                    ),
                  ],
                ),
                if (p != activeProjects.last) const SizedBox(height: 10),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        // total portfolio section
        DompetCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TOTAL PORTFOLIO',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white38,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatMoney(totalProjectValue, 'IDR'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const Text(
                '+18.5%',
                style: TextStyle(fontSize: 12, color: Color(0xFF34D399)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PortfolioHeader extends StatelessWidget {
  const _PortfolioHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        'Portfolio',
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _PortfolioTabBar extends StatelessWidget {
  const _PortfolioTabBar({required this.current, required this.onChanged});

  final int current;
  final ValueChanged<int> onChanged;

  static const _tabs = [
    (label: 'Assets', icon: Icons.account_balance_wallet_outlined),
    (label: 'Investment', icon: Icons.show_chart),
    (label: 'Business', icon: Icons.business_center_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          for (var i = 0; i < _tabs.length; i++)
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => onChanged(i),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: current == i
                        ? DompetBrand.purple.withValues(alpha: 0.3)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _tabs[i].icon,
                        size: 16,
                        color: current == i
                            ? const Color(0xFFDDD6FE)
                            : Colors.white38,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _tabs[i].label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: current == i
                              ? const Color(0xFFDDD6FE)
                              : Colors.white38,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.value,
    required this.change,
    required this.changePercent,
    required this.isUp,
  });

  final String value;
  final String change;
  final num changePercent;
  final bool isUp;

  @override
  Widget build(BuildContext context) {
    final upColor = const Color(0xFF34D399);
    final downColor = DompetBrand.pink;
    final color = isUp ? upColor : downColor;

    return DompetCard(
      variant: DompetCardVariant.csGlassCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PORTFOLIO VALUE',
            style: TextStyle(
              fontSize: 10,
              color: Colors.white38,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                isUp ? Icons.trending_up : Icons.trending_down,
                size: 18,
                color: color,
              ),
              const SizedBox(width: 4),
              Text(change, style: TextStyle(fontSize: 13, color: color)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${changePercent >= 0 ? '+' : ''}${changePercent.toStringAsFixed(2)}%',
                  style: TextStyle(fontSize: 11, color: color),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'All Time',
                style: TextStyle(fontSize: 11, color: Colors.white38),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AllocationBar extends StatelessWidget {
  const _AllocationBar({required this.holdings, required this.total});

  final List<_Holding> holdings;
  final num total;

  Map<String, num> get _distribution {
    final map = <String, num>{};
    for (final h in holdings) {
      map[h.type] = (map[h.type] ?? 0) + h.value;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final dist = _distribution;

    return DompetCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Asset Allocation',
            style: TextStyle(fontSize: 12, color: Colors.white38),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 10,
              child: Row(
                children: [
                  for (final entry in dist.entries)
                    if (total > 0)
                      Expanded(
                        flex: (entry.value / total * 1000).round(),
                        child: Container(color: _typeColors[entry.key]),
                      ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 14,
            runSpacing: 4,
            children: [
              for (final entry in dist.entries)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _typeColors[entry.key],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      entry.key[0].toUpperCase() + entry.key.substring(1),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white38,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      total > 0
                          ? '${(entry.value / total * 100).toStringAsFixed(1)}%'
                          : '0%',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.selected, required this.onChanged});

  final String selected;
  final ValueChanged<String> onChanged;

  static const _types = ['all', 'stock', 'crypto', 'mutual', 'property'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final type in _types) ...[
            _chip(type),
            if (type != _types.last) const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }

  Widget _chip(String type) {
    final active = selected == type;
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () => onChanged(type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: active
                ? DompetBrand.pink.withValues(alpha: 0.6)
                : Colors.white12,
          ),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          type == 'all' ? 'All' : type[0].toUpperCase() + type.substring(1),
          style: TextStyle(
            fontSize: 11,
            color: active ? const Color(0xFFFDBA74) : Colors.white38,
          ),
        ),
      ),
    );
  }
}

class _HoldingItem extends StatelessWidget {
  const _HoldingItem({required this.holding});

  final _Holding holding;

  @override
  Widget build(BuildContext context) {
    final isUp = holding.change >= 0;
    return DompetCard(
      variant: DompetCardVariant.csGlassSurface,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          // icon section
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: DompetBrand.purple.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Icon(holding.icon, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 12),
          // info section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        holding.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: holding.badgeColor),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        holding.symbol,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: holding.badgeColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${holding.amount} ${holding.symbol}',
                  style: const TextStyle(fontSize: 11, color: Colors.white38),
                ),
              ],
            ),
          ),
          // value section
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatMoney(holding.value, 'IDR'),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${isUp ? '+' : ''}${formatMoney(holding.change, 'IDR')} '
                '(${isUp ? '+' : ''}${holding.changePercent.toStringAsFixed(2)}%)',
                style: TextStyle(
                  fontSize: 10,
                  color: isUp ? const Color(0xFF34D399) : DompetBrand.pink,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EmptyPortfolio extends StatelessWidget {
  const EmptyPortfolio({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Text(
          'No holdings found',
          style: TextStyle(color: Colors.white38, fontSize: 12),
        ),
      ),
    );
  }
}
