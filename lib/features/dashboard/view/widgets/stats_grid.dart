import 'package:flutter/material.dart';
import '../../model/dashboard_stats_model.dart';
import 'package:pos_app/core/models/dashboard_models.dart';
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

/// A grid widget displaying dashboard statistics using DashboardStats from repository
class StatsGridNew extends StatelessWidget {
  final DashboardStats stats;

  const StatsGridNew({super.key, required this.stats});

  String _formatCurrency(double value) {
    return value.toStringAsFixed(2);
  }

  String _calcPercent(double part, double total) {
    if (total == 0) return '0%';
    return '${(part / total * 100).toStringAsFixed(1)}%';
  }

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
      amount: _formatCurrency(stats.onlineSales),
      infoText: '${_calcPercent(stats.onlineSales, stats.totalSales)} of sales',
    );
  }

  Widget _buildCashCollectedCard(ColorScheme colorScheme) {
    return StatCard(
      icon: Icons.account_balance_wallet_outlined,
      iconBackgroundColor: colorScheme.tertiary,
      title: 'Cash Collected',
      amount: _formatCurrency(stats.cashSales),
      infoText:
          '${_calcPercent(stats.cashSales, stats.totalSales)} of total sales (excluding online orders)',
    );
  }

  Widget _buildNetSalesCard(ColorScheme colorScheme) {
    return StatCard(
      icon: Icons.bar_chart,
      iconBackgroundColor: colorScheme.secondary,
      title: 'Net Sales',
      amount: _formatCurrency(stats.netSales),
      infoText: 'Net sales',
      showMoreButton: true,
    );
  }

  Widget _buildExpensesCard(ColorScheme colorScheme) {
    return StatCard(
      icon: Icons.receipt_long_outlined,
      iconBackgroundColor: colorScheme.primaryContainer,
      title: 'Expenses',
      amount: '0.00',
      infoText: 'Expenses recorded',
    );
  }

  Widget _buildTaxesCard(ColorScheme colorScheme) {
    return StatCard(
      icon: Icons.receipt_outlined,
      iconBackgroundColor: colorScheme.outline,
      title: 'Taxes',
      amount: _formatCurrency(stats.taxCollected),
      infoText: 'Taxes recorded',
    );
  }

  Widget _buildDiscountsCard(ColorScheme colorScheme) {
    return StatCard(
      icon: Icons.local_offer_outlined,
      iconBackgroundColor: colorScheme.error,
      title: 'Discounts',
      amount: _formatCurrency(stats.totalDiscounts),
      infoText:
          '${_calcPercent(stats.totalDiscounts, stats.totalSales)} Discounts given',
    );
  }
}

