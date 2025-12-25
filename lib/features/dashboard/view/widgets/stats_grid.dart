import 'package:flutter/material.dart';
import '../../model/dashboard_stats_model.dart';
import 'stat_card.dart';

/// A grid widget displaying all dashboard statistics in a 2-column layout
class StatsGrid extends StatelessWidget {
  final DashboardStatsModel stats;

  const StatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildRow(_buildOnlineSalesCard(), _buildCashCollectedCard()),
          const SizedBox(height: 12),
          _buildRow(_buildNetSalesCard(), _buildExpensesCard()),
          const SizedBox(height: 12),
          _buildRow(_buildTaxesCard(), _buildDiscountsCard()),
        ],
      ),
    );
  }

  Widget _buildRow(Widget left, Widget right) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 12),
        Expanded(child: right),
      ],
    );
  }

  Widget _buildOnlineSalesCard() {
    return StatCard(
      icon: Icons.wifi_tethering,
      iconBackgroundColor: const Color(0xFF4CAF50),
      title: 'Online Sales',
      amount: stats.onlineSales,
      infoText: '${stats.onlineSalesPercent} of sales',
    );
  }

  Widget _buildCashCollectedCard() {
    return StatCard(
      icon: Icons.account_balance_wallet_outlined,
      iconBackgroundColor: const Color(0xFFFFC107),
      title: 'Cash Collected',
      amount: stats.cashCollected,
      infoText:
          '${stats.cashCollectedPercent} of total sales (excluding online orders)',
    );
  }

  Widget _buildNetSalesCard() {
    return StatCard(
      icon: Icons.bar_chart,
      iconBackgroundColor: const Color(0xFFFF9800),
      title: 'Net Sales',
      amount: stats.netSales,
      infoText: 'Of ${stats.netSalesOutlets} outlets',
      showMoreButton: true,
    );
  }

  Widget _buildExpensesCard() {
    return StatCard(
      icon: Icons.receipt_long_outlined,
      iconBackgroundColor: const Color(0xFF2196F3),
      title: 'Expenses',
      amount: stats.expenses,
      infoText: 'Expenses recorded',
    );
  }

  Widget _buildTaxesCard() {
    return StatCard(
      icon: Icons.receipt_outlined,
      iconBackgroundColor: const Color(0xFF607D8B),
      title: 'Taxes',
      amount: stats.taxes,
      infoText: 'Taxes recorded',
    );
  }

  Widget _buildDiscountsCard() {
    return StatCard(
      icon: Icons.local_offer_outlined,
      iconBackgroundColor: const Color(0xFFE91E63),
      title: 'Discounts',
      amount: stats.discounts,
      infoText: '${stats.discountsPercent} Discounts given',
    );
  }
}
