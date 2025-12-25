import 'package:flutter/material.dart';

/// Bottom navigation bar item data
class BottomNavItem {
  final IconData icon;
  final String label;
  final bool hasBadge;

  const BottomNavItem({
    required this.icon,
    required this.label,
    this.hasBadge = false,
  });
}

/// Custom bottom navigation bar for the POS app
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const BottomNavBar({super.key, required this.currentIndex, this.onTap});

  static const List<BottomNavItem> items = [
    BottomNavItem(icon: Icons.bar_chart, label: 'Sales'),
    BottomNavItem(
      icon: Icons.smart_toy_outlined,
      label: 'AI Agent',
      hasBadge: true,
    ),
    BottomNavItem(icon: Icons.more_horiz, label: 'More'),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          items.length,
          (index) => _buildNavItem(context, items[index], index),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, BottomNavItem item, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final isActive = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap?.call(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIconContainer(context, item, isActive),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconContainer(
    BuildContext context,
    BottomNavItem item,
    bool isActive,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    Widget iconWidget = Icon(
      item.icon,
      color: isActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
      size: 24,
    );

    // Wrap with badge if needed
    if (item.hasBadge) {
      iconWidget = Stack(
        clipBehavior: Clip.none,
        children: [
          iconWidget,
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: colorScheme.surface, width: 1.5),
              ),
            ),
          ),
        ],
      );
    }

    // Active indicator pill
    if (isActive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: iconWidget,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: iconWidget,
    );
  }
}
