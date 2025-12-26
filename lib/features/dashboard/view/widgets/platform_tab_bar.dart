import 'package:flutter/material.dart';
import '../../model/online_order_model.dart';

/// Horizontal scrollable tab bar for platform selection
class PlatformTabBar extends StatelessWidget {
  final List<OrderPlatformModel> platforms;
  final String selectedPlatformId;
  final ValueChanged<String> onPlatformChanged;

  const PlatformTabBar({
    super.key,
    required this.platforms,
    required this.selectedPlatformId,
    required this.onPlatformChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: colorScheme.outline.withValues(alpha: 0.1)),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            ...platforms.map(
              (platform) => _buildPlatformTab(
                context,
                platform: platform,
                isSelected: platform.id == selectedPlatformId,
                colorScheme: colorScheme,
              ),
            ),
            // Arrow indicator for more platforms
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformTab(
    BuildContext context, {
    required OrderPlatformModel platform,
    required bool isSelected,
    required ColorScheme colorScheme,
  }) {
    return GestureDetector(
      onTap: () => onPlatformChanged(platform.id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? colorScheme.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (platform.icon != null) ...[
              _buildPlatformIcon(platform, isSelected, colorScheme),
              const SizedBox(width: 8),
            ],
            Text(
              platform.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? colorScheme.onSurface
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformIcon(
    OrderPlatformModel platform,
    bool isSelected,
    ColorScheme colorScheme,
  ) {
    // Special styling for different platforms
    Color iconBgColor;
    Color iconColor;

    switch (platform.id) {
      case 'all':
        iconBgColor = colorScheme.surfaceContainerHighest;
        iconColor = colorScheme.onSurfaceVariant;
        break;
      case 'foodpanda':
        iconBgColor = colorScheme.errorContainer;
        iconColor = colorScheme.error;
        break;
      case 'home_website':
        iconBgColor = colorScheme.primaryContainer;
        iconColor = colorScheme.primary;
        break;
      case 'zomato':
        iconBgColor = colorScheme.errorContainer;
        iconColor = colorScheme.error;
        break;
      default:
        iconBgColor = colorScheme.secondaryContainer;
        iconColor = colorScheme.secondary;
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: iconBgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(platform.icon, size: 18, color: iconColor),
    );
  }
}
