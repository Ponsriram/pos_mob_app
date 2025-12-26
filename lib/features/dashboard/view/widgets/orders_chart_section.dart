import 'package:flutter/material.dart';

/// Expandable chart section showing order statistics
class OrdersChartSection extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;

  const OrdersChartSection({
    super.key,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: colorScheme.primary, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with toggle
          _buildHeader(context, colorScheme, textTheme),
          // Chart content (when expanded)
          if (isExpanded) _buildChartContent(context, colorScheme, textTheme),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Chart icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.show_chart,
                color: colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            // Title
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Last 5 Days Orders ',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    TextSpan(
                      text: isExpanded ? '(Hide Chart)' : '(Show Chart)',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Toggle icon
            Icon(
              isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartContent(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          // Chart area (placeholder)
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Chart line placeholder
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
                const SizedBox(height: 16),
                // X-axis labels
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _buildDateLabels(colorScheme, textTheme),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Legend
          _buildLegend(colorScheme, textTheme),
        ],
      ),
    );
  }

  List<Widget> _buildDateLabels(ColorScheme colorScheme, TextTheme textTheme) {
    final now = DateTime.now();
    final labels = <Widget>[];

    for (int i = 4; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      labels.add(
        Text(
          '${date.day}-${_getMonthName(date.month)}',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontSize: 11,
          ),
        ),
      );
    }

    return labels;
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  Widget _buildLegend(ColorScheme colorScheme, TextTheme textTheme) {
    final legendItems = [
      _LegendItem('FoodPanda', colorScheme.primary),
      _LegendItem('Home Website', colorScheme.primary),
      _LegendItem('Zomato', colorScheme.error),
      _LegendItem('Swiggy', colorScheme.secondary),
      _LegendItem('Dunzo_old', colorScheme.tertiary),
      _LegendItem('Uber Eats', colorScheme.error),
      _LegendItem('Call Center', colorScheme.primary),
      _LegendItem('Uengage', colorScheme.errorContainer),
      _LegendItem('Chowman Web', colorScheme.secondary),
      _LegendItem('Thrive', colorScheme.tertiary),
      _LegendItem('Menu QR Code', colorScheme.outline),
      _LegendItem('Magicpin', colorScheme.primary),
      _LegendItem('Dotpe', colorScheme.tertiary),
      _LegendItem('Talabat', colorScheme.primary),
      _LegendItem('NoonFoods', colorScheme.tertiary),
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: legendItems.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: item.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              item.name,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _LegendItem {
  final String name;
  final Color color;

  _LegendItem(this.name, this.color);
}
