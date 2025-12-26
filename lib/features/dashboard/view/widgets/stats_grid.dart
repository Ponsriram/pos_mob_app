import 'package:flutter/material.dart';
import '../../model/dashboard_stats_model.dart';
import 'stat_card.dart';

/// A grid widget displaying all dashboard statistics in a 2-column layout
class StatsGrid extends StatelessWidget {
  final DashboardStatsModel stats;

  const StatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildRow(
            _buildOnlineSalesCard(colorScheme),
            _buildCashCollectedCard(colorScheme),
          ),
          const SizedBox(height: 12),
          _buildRow(
            _buildNetSalesCard(colorScheme),
            _buildExpensesCard(colorScheme),
          ),
          const SizedBox(height: 12),
          _buildRow(
            _buildTaxesCard(colorScheme),
            _buildDiscountsCard(colorScheme),
          ),
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

  Widget _buildOnlineSalesCard(ColorScheme colorScheme) {
    return StatCard(
      icon: Icons.wifi_tethering,
      iconBackgroundColor: colorScheme.primary,
      title: 'Online Sales',
      amount: stats.onlineSales,
      infoText: '${stats.onlineSalesPercent} of sales',
    );
  }

  Widget _buildCashCollectedCard(ColorScheme colorScheme) {
    return StatCard(
      icon: Icons.account_balance_wallet_outlined,
      iconBackgroundColor: colorScheme.tertiary,
      title: 'Cash Collected',
      amount: stats.cashCollected,
      infoText:
          '${stats.cashCollectedPercent} of total sales (excluding online orders)',
    );
  }

  Widget _buildNetSalesCard(ColorScheme colorScheme) {
    return StatCard(
      icon: Icons.bar_chart,
      iconBackgroundColor: colorScheme.secondary,
      title: 'Net Sales',
      amount: stats.netSales,
      infoText: 'Of ${stats.netSalesOutlets} outlets',
      showMoreButton: true,
    );
  }

  Widget _buildExpensesCard(ColorScheme colorScheme) {
    return StatCard(
      icon: Icons.receipt_long_outlined,
      iconBackgroundColor: colorScheme.primaryContainer,
      title: 'Expenses',
      amount: stats.expenses,
      infoText: 'Expenses recorded',
    );
  }

  Widget _buildTaxesCard(ColorScheme colorScheme) {
    return StatCard(
      icon: Icons.receipt_outlined,
      iconBackgroundColor: colorScheme.outline,
      title: 'Taxes',
      amount: stats.taxes,
      infoText: 'Taxes recorded',
    );
  }

  Widget _buildDiscountsCard(ColorScheme colorScheme) {
    return StatCard(
      icon: Icons.local_offer_outlined,
      iconBackgroundColor: colorScheme.error,
      title: 'Discounts',
      amount: stats.discounts,
      infoText: '${stats.discountsPercent} Discounts given',
    );
  }
}
