import 'package:flutter/material.dart';

/// Reusable app bar widget for the POS app
class PosAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String selectedOutlet;
  final VoidCallback? onMenuTap;
  final VoidCallback? onOutletTap;
  final VoidCallback? onLightBulbTap;
  final VoidCallback? onNotificationTap;
  final bool showMenuButton;
  final bool showOutletSelector;
  final bool showThemeToggle;
  final bool showLightBulb;
  final bool showNotification;

  const PosAppBar({
    super.key,
    this.selectedOutlet = 'All Outlets',
    this.onMenuTap,
    this.onOutletTap,
    this.onLightBulbTap,
    this.onNotificationTap,
    this.showMenuButton = true,
    this.showOutletSelector = true,
    this.showThemeToggle = true,
    this.showLightBulb = true,
    this.showNotification = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: showMenuButton
          ? IconButton(
              onPressed: onMenuTap,
              icon: Icon(Icons.menu, color: colorScheme.primary),
            )
          : null,
      title: showOutletSelector
          ? _buildOutletSelector(context, colorScheme)
          : null,
      titleSpacing: 0,
      actions: _buildActions(context, colorScheme, isDark),
    );
  }

  Widget _buildOutletSelector(BuildContext context, ColorScheme colorScheme) {
    return GestureDetector(
      onTap: onOutletTap,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 220),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                selectedOutlet,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActions(
    BuildContext context,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    final List<Widget> actions = [];

    if (showThemeToggle) {
      actions.add(
        IconButton(
          onPressed: () {
            // Theme toggle is a no-op without a state management layer
          },
          icon: Icon(
            isDark ? Icons.light_mode : Icons.dark_mode,
            color: isDark ? const Color(0xFFFFC107) : colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    if (showLightBulb) {
      actions.add(
        IconButton(
          onPressed: onLightBulbTap,
          icon: const Icon(Icons.lightbulb_outline, color: Color(0xFFFFC107)),
        ),
      );
    }

    if (showNotification) {
      actions.add(
        IconButton(
          onPressed: onNotificationTap,
          icon: Icon(
            Icons.notifications_outlined,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return actions;
  }
}
