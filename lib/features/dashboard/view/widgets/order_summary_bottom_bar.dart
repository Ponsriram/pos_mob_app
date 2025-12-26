import 'package:flutter/material.dart';

/// Bottom summary bar showing total orders and amount
class OrderSummaryBottomBar extends StatelessWidget {
  final int totalOrders;
  final double totalAmount;

  const OrderSummaryBottomBar({
    super.key,
    required this.totalOrders,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: 8 + bottomPadding,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Order count section
          _buildStatItem(
            context,
            label: 'Order',
            value: '$totalOrders',
            textTheme: textTheme,
          ),
          // Divider
          Container(
            height: 30,
            width: 1,
            margin: const EdgeInsets.symmetric(horizontal: 32),
            color: colorScheme.primary.withValues(alpha: 0.3),
          ),
          // Amount section
          _buildStatItem(
            context,
            label: '₹',
            value: totalAmount.toStringAsFixed(2),
            textTheme: textTheme,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String label,
    required String value,
    required TextTheme textTheme,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }
}
