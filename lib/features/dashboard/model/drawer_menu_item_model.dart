import 'package:flutter/material.dart';

/// Model representing a menu item in the dashboard drawer
class DrawerMenuItemModel {
  final String title;
  final IconData icon;
  final bool isExpandable;
  final bool isActive;
  final String? subtitle;
  final List<DrawerMenuItemModel>? children;
  final bool isSectionHeader;
  final VoidCallback? onTap;

  const DrawerMenuItemModel({
    required this.title,
    required this.icon,
    this.isExpandable = false,
    this.isActive = false,
    this.subtitle,
    this.children,
    this.isSectionHeader = false,
    this.onTap,
  });

  /// Get the default drawer menu items
  static List<DrawerMenuItemModel> getDefaultMenuItems() {
    return [
      const DrawerMenuItemModel(
        title: 'Dashboard',
        icon: Icons.dashboard_outlined,
        isActive: true,
      ),
      const DrawerMenuItemModel(
        title: 'Daily Operations',
        icon: Icons.access_time,
        isSectionHeader: true,
      ),
      const DrawerMenuItemModel(
        title: 'Running Orders',
        icon: Icons.access_time_outlined,
      ),
      const DrawerMenuItemModel(title: 'Online Orders', icon: Icons.language),
      const DrawerMenuItemModel(
        title: 'Menu & Store Actions',
        icon: Icons.storefront_outlined,
      ),
      const DrawerMenuItemModel(
        title: 'Menu',
        icon: Icons.restaurant_menu_outlined,
        isExpandable: true,
      ),
      const DrawerMenuItemModel(
        title: 'Inventory',
        icon: Icons.inventory_2_outlined,
        isExpandable: true,
      ),
      const DrawerMenuItemModel(
        title: 'Reports',
        icon: Icons.assessment_outlined,
      ),
      const DrawerMenuItemModel(
        title: 'Management',
        icon: Icons.manage_accounts_outlined,
        isExpandable: true,
      ),
      const DrawerMenuItemModel(
        title: 'CRM',
        icon: Icons.people_outline,
        isExpandable: true,
      ),
      const DrawerMenuItemModel(
        title: 'Edit Profile',
        icon: Icons.person_outline,
      ),
      const DrawerMenuItemModel(
        title: 'Desktop Application',
        icon: Icons.desktop_windows_outlined,
        subtitle: 'Version - 119.0.2',
      ),
      const DrawerMenuItemModel(
        title: 'Terms & Conditions',
        icon: Icons.description_outlined,
      ),
      const DrawerMenuItemModel(
        title: 'Privacy Policy',
        icon: Icons.privacy_tip_outlined,
      ),
      const DrawerMenuItemModel(title: 'Logout', icon: Icons.logout),
    ];
  }
}
