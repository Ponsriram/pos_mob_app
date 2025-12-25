import 'package:flutter/material.dart';
import '../../model/outlet_stats_model.dart';

/// Section displaying outlet-wise statistics with scrollable tabs
class OutletStatisticsSection extends StatelessWidget {
  final List<String> tabLabels;
  final int activeTabIndex;
  final List<OutletStatsModel> outlets;
  final String columnHeader;
  final String Function(OutletStatsModel) valueGetter;
  final ValueChanged<int>? onTabChanged;

  const OutletStatisticsSection({
    super.key,
    required this.tabLabels,
    required this.activeTabIndex,
    required this.outlets,
    required this.columnHeader,
    required this.valueGetter,
    this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          _buildTabs(context),
          _buildTable(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.bar_chart, color: colorScheme.primary, size: 20),
          const SizedBox(width: 8),
          Text(
            'Outlet Wise Statistics',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: List.generate(
            tabLabels.length,
            (index) => _buildTab(context, tabLabels[index], index),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, String label, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final isActive = index == activeTabIndex;

    return GestureDetector(
      onTap: () => onTabChanged?.call(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? colorScheme.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isActive
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
    return Column(
      children: [
        _buildTableHeader(context),
        ...outlets.map((outlet) => _buildTableRow(context, outlet)),
      ],
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
      ),
      child: Row(
        children: [
          const Spacer(),
          Text(
            columnHeader,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(BuildContext context, OutletStatsModel outlet) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colorScheme.outline.withOpacity(0.1)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: outlet.isTotal
                  ? colorScheme.onSurface
                  : colorScheme.onSurfaceVariant,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    outlet.outletName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: outlet.isTotal
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!outlet.isTotal) ...[
                  const SizedBox(width: 4),
                  Icon(Icons.open_in_new, size: 14, color: colorScheme.outline),
                ],
              ],
            ),
          ),
          Text(
            valueGetter(outlet),
            style: TextStyle(
              fontSize: 14,
              fontWeight: outlet.isTotal ? FontWeight.w600 : FontWeight.normal,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
