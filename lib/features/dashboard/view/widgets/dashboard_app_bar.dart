import 'package:flutter/material.dart';

/// Custom app bar for the dashboard screen
class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String selectedOutlet;
  final VoidCallback onMenuTap;
  final VoidCallback? onOutletTap;
  final VoidCallback? onLightBulbTap;
  final VoidCallback? onNotificationTap;

  const DashboardAppBar({
    super.key,
    required this.selectedOutlet,
    required this.onMenuTap,
    this.onOutletTap,
    this.onLightBulbTap,
    this.onNotificationTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: _buildMenuButton(context),
      title: _buildOutletSelector(context),
      titleSpacing: 0,
      actions: _buildActions(context),
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      onPressed: onMenuTap,
      icon: Icon(Icons.menu, color: colorScheme.primary),
    );
  }

  Widget _buildOutletSelector(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onOutletTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedOutlet,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
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

  List<Widget> _buildActions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return [
      IconButton(
        onPressed: onLightBulbTap,
        icon: Icon(Icons.lightbulb_outline, color: const Color(0xFFFFC107)),
      ),
      IconButton(
        onPressed: onNotificationTap,
        icon: Icon(
          Icons.notifications_outlined,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    ];
  }
}
