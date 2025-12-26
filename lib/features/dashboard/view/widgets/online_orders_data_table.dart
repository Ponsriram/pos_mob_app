import 'package:flutter/material.dart';
import '../../model/online_order_model.dart';

/// Data table header for online orders
class OnlineOrdersTableHeader extends StatelessWidget {
  const OnlineOrdersTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.5),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _buildHeaderCell(textTheme, colorScheme, 'Order No.', width: 80),
              _buildHeaderCellWithSubtitle(
                textTheme,
                colorScheme,
                'Outlet Name',
                'Order From',
                width: 100,
              ),
              _buildHeaderCellWithSubtitle(
                textTheme,
                colorScheme,
                'Order Type',
                'Rider Details',
                width: 100,
              ),
              _buildHeaderCell(
                textTheme,
                colorScheme,
                'Customer Details',
                width: 120,
              ),
              _buildHeaderCell(textTheme, colorScheme, 'OTP', width: 60),
              _buildHeaderCell(textTheme, colorScheme, 'Date Time', width: 100),
              _buildHeaderCell(textTheme, colorScheme, 'Total', width: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCell(
    TextTheme textTheme,
    ColorScheme colorScheme,
    String title, {
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: Text(
        title,
        style: textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildHeaderCellWithSubtitle(
    TextTheme textTheme,
    ColorScheme colorScheme,
    String title,
    String subtitle, {
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          Text(
            subtitle,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

/// Data table showing online orders
class OnlineOrdersDataTable extends StatelessWidget {
  final List<OnlineOrderModel> orders;
  final bool isLoading;

  const OnlineOrdersDataTable({
    super.key,
    required this.orders,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(color: colorScheme.primary),
      );
    }

    if (orders.isEmpty) {
      return _buildEmptyState(context, colorScheme, textTheme);
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return _buildOrderRow(context, orders[index], colorScheme, textTheme);
      },
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Search icon in circle
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search,
                size: 40,
                color: colorScheme.primary.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Record Found',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We could not find what you searched for Try searching again',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderRow(
    BuildContext context,
    OnlineOrderModel order,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colorScheme.outline.withValues(alpha: 0.1)),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _buildCell(textTheme, colorScheme, order.orderNo, width: 80),
              _buildCellWithSubtitle(
                textTheme,
                colorScheme,
                order.outletName,
                order.orderFrom,
                width: 100,
              ),
              _buildCellWithSubtitle(
                textTheme,
                colorScheme,
                order.orderType,
                order.riderDetails ?? '-',
                width: 100,
              ),
              _buildCell(
                textTheme,
                colorScheme,
                order.customerName,
                width: 120,
              ),
              _buildCell(textTheme, colorScheme, order.otp ?? '-', width: 60),
              _buildCell(
                textTheme,
                colorScheme,
                _formatDateTime(order.dateTime),
                width: 100,
              ),
              _buildCell(textTheme, colorScheme, '₹${order.total}', width: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCell(
    TextTheme textTheme,
    ColorScheme colorScheme,
    String text, {
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildCellWithSubtitle(
    TextTheme textTheme,
    ColorScheme colorScheme,
    String title,
    String subtitle, {
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 11,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}\n'
        '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
