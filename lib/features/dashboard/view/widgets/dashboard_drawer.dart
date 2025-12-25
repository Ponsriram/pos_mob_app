import 'package:flutter/material.dart';
import '../../model/drawer_menu_item_model.dart';

/// Navigation drawer for the dashboard screen
class DashboardDrawer extends StatelessWidget {
  final List<DrawerMenuItemModel> menuItems;
  final Function(int)? onItemTap;

  const DashboardDrawer({super.key, required this.menuItems, this.onItemTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Drawer(
      backgroundColor: colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  return _buildMenuItem(context, menuItems[index], index);
                },
              ),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    DrawerMenuItemModel item,
    int index,
  ) {
    if (item.isSectionHeader) {
      return _buildSectionHeader(context, item.title);
    }

    return _buildMenuTile(context, item, index);
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurfaceVariant,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMenuTile(
    BuildContext context,
    DrawerMenuItemModel item,
    int index,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isActive = item.isActive;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? colorScheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        onTap: () => onItemTap?.call(index),
        leading: Icon(
          item.icon,
          color: isActive
              ? colorScheme.onPrimary
              : colorScheme.onSurfaceVariant,
          size: 22,
        ),
        title: Text(
          item.title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isActive ? colorScheme.onPrimary : colorScheme.onSurface,
          ),
        ),
        subtitle: item.subtitle != null
            ? Text(
                item.subtitle!,
                style: TextStyle(
                  fontSize: 12,
                  color: isActive
                      ? colorScheme.onPrimary.withOpacity(0.8)
                      : colorScheme.onSurfaceVariant,
                ),
              )
            : null,
        trailing: item.isExpandable
            ? Icon(
                Icons.chevron_right,
                color: isActive
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
                size: 20,
              )
            : null,
        dense: true,
        visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Need Help',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.headset_mic_outlined,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '07969 223344',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
