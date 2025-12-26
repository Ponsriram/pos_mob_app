import 'package:flutter/material.dart';
import '../../model/drawer_menu_item_model.dart';

/// Navigation drawer for the dashboard screen
class DashboardDrawer extends StatefulWidget {
  final List<DrawerMenuItemModel> menuItems;
  final Function(String)? onItemTap;
  final String? activeItemId;

  const DashboardDrawer({
    super.key,
    required this.menuItems,
    this.onItemTap,
    this.activeItemId,
  });

  @override
  State<DashboardDrawer> createState() => _DashboardDrawerState();
}

class _DashboardDrawerState extends State<DashboardDrawer> {
  final Set<String> _expandedSections = {};

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Drawer(
      backgroundColor: colorScheme.surface,
      child: Column(
        children: [
          SizedBox(height: topPadding + 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: _buildMenuItems(context, widget.menuItems, 0),
            ),
          ),
          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }

  List<Widget> _buildMenuItems(
    BuildContext context,
    List<DrawerMenuItemModel> items,
    int depth,
  ) {
    final List<Widget> widgets = [];

    for (final item in items) {
      if (item.isSectionHeader) {
        widgets.add(_buildSectionHeader(context, item));
      } else if (item.isExpandable) {
        widgets.add(_buildExpandableSection(context, item, depth));
      } else {
        widgets.add(_buildMenuTile(context, item, depth));
      }
    }

    return widgets;
  }

  Widget _buildSectionHeader(BuildContext context, DrawerMenuItemModel item) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(top: 8),
      color: colorScheme.surfaceContainerHighest,
      child: Text(
        item.title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildExpandableSection(
    BuildContext context,
    DrawerMenuItemModel item,
    int depth,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isExpanded = _expandedSections.contains(item.id);
    final leftPadding = 16.0 + (depth * 16.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              if (isExpanded) {
                _expandedSections.remove(item.id);
              } else {
                _expandedSections.add(item.id);
              }
            });
          },
          child: Padding(
            padding: EdgeInsets.only(
              left: leftPadding,
              right: 16,
              top: 12,
              bottom: 12,
            ),
            child: Row(
              children: [
                if (item.icon != null) ...[
                  Icon(
                    item.icon,
                    size: 22,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded && item.children != null)
          ..._buildMenuItems(context, item.children!, depth + 1),
      ],
    );
  }

  Widget _buildMenuTile(
    BuildContext context,
    DrawerMenuItemModel item,
    int depth,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isActive = widget.activeItemId == item.id;
    final leftPadding = 16.0 + (depth * 16.0);

    return InkWell(
      onTap: () => widget.onItemTap?.call(item.id),
      child: Container(
        padding: EdgeInsets.only(
          left: leftPadding,
          right: 16,
          top: 12,
          bottom: 12,
        ),
        color: isActive
            ? colorScheme.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        child: Row(
          children: [
            if (item.icon != null) ...[
              Icon(
                item.icon,
                size: 22,
                color: isActive
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isActive
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                        ),
                      ),
                      if (item.hasBetaTag) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.tertiary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                size: 12,
                                color: colorScheme.tertiary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Beta',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.tertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (item.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (item.hasArrow)
              Icon(
                Icons.chevron_right,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}
