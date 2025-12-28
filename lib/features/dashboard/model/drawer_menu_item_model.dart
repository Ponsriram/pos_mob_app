import 'package:flutter/material.dart';

/// Enum for menu item types
enum MenuItemType { regular, sectionHeader, expandableSection, subMenuItem }

/// Model representing a menu item in the dashboard drawer
class DrawerMenuItemModel {
  final String id;
  final String title;
  final IconData? icon;
  final MenuItemType type;
  final bool isActive;
  final String? subtitle;
  final List<DrawerMenuItemModel>? children;
  final VoidCallback? onTap;
  final bool hasBetaTag;
  final bool hasArrow;

  const DrawerMenuItemModel({
    required this.id,
    required this.title,
    this.icon,
    this.type = MenuItemType.regular,
    this.isActive = false,
    this.subtitle,
    this.children,
    this.onTap,
    this.hasBetaTag = false,
    this.hasArrow = false,
  });

  bool get isSectionHeader => type == MenuItemType.sectionHeader;
  bool get isExpandable => type == MenuItemType.expandableSection;
  bool get isSubMenuItem => type == MenuItemType.subMenuItem;

  /// Get the default drawer menu items
  static List<DrawerMenuItemModel> getDefaultMenuItems() {
    return [
      // Dashboard
      const DrawerMenuItemModel(
        id: 'dashboard',
        title: 'Dashboard',
        icon: Icons.dashboard_outlined,
      ),

      // Daily Operations Section
      const DrawerMenuItemModel(
        id: 'daily_operations_header',
        title: 'Daily Operations',
        type: MenuItemType.sectionHeader,
      ),
      const DrawerMenuItemModel(
        id: 'running_orders',
        title: 'Running Orders',
        icon: Icons.access_time_outlined,
      ),
      const DrawerMenuItemModel(
        id: 'online_orders',
        title: 'Online Orders',
        icon: Icons.language,
      ),
      const DrawerMenuItemModel(
        id: 'menu_store_actions',
        title: 'Menu & Store Actions',
        icon: Icons.restaurant_menu_outlined,
      ),

      // Menu Section (Expandable)
      DrawerMenuItemModel(
        id: 'menu',
        title: 'Menu',
        icon: Icons.restaurant_menu_outlined,
        type: MenuItemType.expandableSection,
        children: const [
          DrawerMenuItemModel(
            id: 'store_status_tracking',
            title: 'Store Status Tracking',
            icon: Icons.store_outlined,
            type: MenuItemType.subMenuItem,
          ),
          DrawerMenuItemModel(
            id: 'item_out_of_stock',
            title: 'Item Out-of-Stock Tracking',
            icon: Icons.inventory_outlined,
            type: MenuItemType.subMenuItem,
          ),
          DrawerMenuItemModel(
            id: 'thirdparty_config',
            title: 'Thirdparty Configurations',
            icon: Icons.settings_applications_outlined,
            type: MenuItemType.subMenuItem,
          ),
        ],
      ),

      // Inventory Section (Expandable)
      DrawerMenuItemModel(
        id: 'inventory',
        title: 'Inventory',
        icon: Icons.inventory_2_outlined,
        type: MenuItemType.expandableSection,
        children: const [
          DrawerMenuItemModel(
            id: 'outlet_type',
            title: 'Outlet Type',
            icon: Icons.storefront_outlined,
            type: MenuItemType.subMenuItem,
          ),
          DrawerMenuItemModel(
            id: 'pending_purchases',
            title: 'Pending Purchases after Sale',
            icon: Icons.receipt_long_outlined,
            type: MenuItemType.subMenuItem,
          ),
        ],
      ),

      // Reports Section Header
      const DrawerMenuItemModel(
        id: 'reports_header',
        title: 'Reports',
        type: MenuItemType.sectionHeader,
      ),

      // Management Section (Expandable)
      DrawerMenuItemModel(
        id: 'management',
        title: 'Management',
        icon: Icons.manage_accounts_outlined,
        type: MenuItemType.expandableSection,
        children: [
          DrawerMenuItemModel(
            id: 'user_management',
            title: 'User Management',
            icon: Icons.people_alt_outlined,
            type: MenuItemType.expandableSection,
            hasArrow: true,
            children: const [
              DrawerMenuItemModel(
                id: 'biller_group',
                title: 'Biller Group Management',
                type: MenuItemType.subMenuItem,
              ),
              DrawerMenuItemModel(
                id: 'admin_group',
                title: 'Admin Group Management',
                type: MenuItemType.subMenuItem,
              ),
              DrawerMenuItemModel(
                id: 'cloud_access',
                title: 'Cloud Access',
                type: MenuItemType.subMenuItem,
              ),
            ],
          ),
          DrawerMenuItemModel(
            id: 'user_logs',
            title: 'User Logs',
            icon: Icons.assignment_ind_outlined,
            type: MenuItemType.expandableSection,
            hasArrow: true,
            children: const [
              DrawerMenuItemModel(
                id: 'notification',
                title: 'Notification',
                type: MenuItemType.subMenuItem,
              ),
              DrawerMenuItemModel(
                id: 'menu_trigger_logs',
                title: 'Menu Trigger Logs',
                type: MenuItemType.subMenuItem,
              ),
              DrawerMenuItemModel(
                id: 'online_store_logs',
                title: 'Online Store Logs',
                type: MenuItemType.subMenuItem,
              ),
              DrawerMenuItemModel(
                id: 'online_item_logs',
                title: 'Online Item On/Off Logs',
                type: MenuItemType.subMenuItem,
              ),
            ],
          ),
          const DrawerMenuItemModel(
            id: 'franchise_management',
            title: 'Franchise Management',
            icon: Icons.business_outlined,
            type: MenuItemType.subMenuItem,
          ),
          const DrawerMenuItemModel(
            id: 'create_zone',
            title: 'Create Zone',
            icon: Icons.add_location_alt_outlined,
            type: MenuItemType.subMenuItem,
          ),
          const DrawerMenuItemModel(
            id: 'delete_outlet',
            title: 'Delete Outlet',
            icon: Icons.delete_outline,
            type: MenuItemType.subMenuItem,
          ),
          const DrawerMenuItemModel(
            id: 'petpooja_apps',
            title: 'PetPooja APPs',
            icon: Icons.apps_outlined,
            type: MenuItemType.subMenuItem,
          ),
        ],
      ),

      // CRM Section (Expandable)
      DrawerMenuItemModel(
        id: 'crm',
        title: 'CRM',
        icon: Icons.people_outline,
        type: MenuItemType.expandableSection,
        children: const [
          DrawerMenuItemModel(
            id: 'reputation',
            title: 'Reputation',
            icon: Icons.star_border_outlined,
            type: MenuItemType.subMenuItem,
            hasBetaTag: true,
          ),
          DrawerMenuItemModel(
            id: 'marketing_automation',
            title: 'Marketing Automation',
            icon: Icons.campaign_outlined,
            type: MenuItemType.subMenuItem,
          ),
        ],
      ),

      // Bottom Items
      const DrawerMenuItemModel(
        id: 'edit_profile',
        title: 'Edit Profile',
        icon: Icons.person_outline,
      ),
      const DrawerMenuItemModel(
        id: 'desktop_app',
        title: 'Desktop Application',
        icon: Icons.desktop_windows_outlined,
        subtitle: 'Version - 119.0.2',
      ),
      const DrawerMenuItemModel(
        id: 'terms',
        title: 'Terms & Conditions',
        icon: Icons.description_outlined,
      ),
      const DrawerMenuItemModel(
        id: 'privacy',
        title: 'Privacy Policy',
        icon: Icons.privacy_tip_outlined,
      ),
    ];
  }
}
