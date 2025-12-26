import 'package:flutter/material.dart';

/// Tab bar widget for switching between Running Orders and Running Tables
class RunningOrdersTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const RunningOrdersTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: colorScheme.outline.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: [
          _buildTab(
            context,
            index: 0,
            label: 'Running Orders',
            isSelected: selectedIndex == 0,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          const SizedBox(width: 24),
          _buildTab(
            context,
            index: 1,
            label: 'Running Tables',
            isSelected: selectedIndex == 1,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
        ],
      ),
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required int index,
    required String label,
    required bool isSelected,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return GestureDetector(
      onTap: () => onTabChanged(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? colorScheme.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: isSelected
                ? colorScheme.onSurface
                : colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
