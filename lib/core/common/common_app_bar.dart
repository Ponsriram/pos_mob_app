import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_app/core/providers/theme_provider.dart';
import 'package:pos_app/features/dashboard/view/pages/notification_page.dart';

/// Custom app bar for the dashboard screen
class CommonAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String selectedOutlet;
  final VoidCallback onMenuTap;
  final VoidCallback? onOutletTap;
  final VoidCallback? onLightBulbTap;
  final String? subTitle;

  const CommonAppBar({
    super.key,
    required this.selectedOutlet,
    required this.onMenuTap,
    this.onOutletTap,
    this.onLightBulbTap,
    this.subTitle,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final themeNotifier = ref.read(themeModeNotifierProvider.notifier);

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: _buildMenuButton(context, colorScheme),
      title: _buildOutletSelector(context, colorScheme),
      titleSpacing: 0,
      actions: _buildActions(context, colorScheme, themeNotifier),
    );
  }

  Widget _buildMenuButton(BuildContext context, ColorScheme colorScheme) {
    return IconButton(
      onPressed: onMenuTap,
      icon: Icon(Icons.menu, color: colorScheme.primary),
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
    ThemeModeNotifier themeNotifier,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      IconButton(
        onPressed: () {
          themeNotifier.toggleTheme();
        },
        icon: Icon(
          isDark ? Icons.light_mode : Icons.dark_mode,
          color: isDark
              ? const Color(0xFFFFC107)
              : colorScheme.onSurfaceVariant,
        ),
      ),
      IconButton(
        onPressed: onLightBulbTap,
        icon: const Icon(Icons.lightbulb_outline, color: Color(0xFFFFC107)),
      ),
      IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationPage()),
          );
        },
        icon: Icon(
          Icons.notifications_outlined,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    ];
  }
}
