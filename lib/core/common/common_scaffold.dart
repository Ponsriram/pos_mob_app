import 'package:flutter/material.dart';
import '../../features/dashboard/model/drawer_menu_item_model.dart';
import '../../features/dashboard/view/widgets/dashboard_drawer.dart';
import 'common_app_bar.dart';
import 'drawer_navigation.dart';
import 'show_outlet_picker.dart';

/// A common scaffold widget that includes the app bar and drawer
/// used across multiple pages in the app.
class CommonScaffold extends StatefulWidget {
  /// The unique identifier for the current page (used to highlight active drawer item)
  final String activeItemId;

  /// The currently selected outlet name
  final String selectedOutlet;

  /// List of available outlets for the picker
  final List<String> availableOutlets;

  /// Callback when an outlet is selected
  final void Function(String outlet) onOutletSelected;

  /// Callback when the lightbulb button is tapped
  final VoidCallback? onLightBulbTap;

  /// The main content of the page
  final Widget body;

  /// Optional bottom navigation bar
  final Widget? bottomNavigationBar;

  /// Optional floating action button
  final Widget? floatingActionButton;

  /// Optional background color (defaults to colorScheme.surfaceContainerLowest)
  final Color? backgroundColor;

  /// Optional custom callback for drawer navigation (if not provided, uses default navigation)
  final void Function(BuildContext context, String itemId)? onDrawerItemTap;

  const CommonScaffold({
    super.key,
    required this.activeItemId,
    required this.selectedOutlet,
    required this.availableOutlets,
    required this.onOutletSelected,
    required this.body,
    this.onLightBulbTap,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.backgroundColor,
    this.onDrawerItemTap,
  });

  @override
  State<CommonScaffold> createState() => _CommonScaffoldState();
}

class _CommonScaffoldState extends State<CommonScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:
          widget.backgroundColor ?? colorScheme.surfaceContainerLowest,
      appBar: CommonAppBar(
        selectedOutlet: widget.selectedOutlet,
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
        onOutletTap: () => _showOutletPicker(context),
        onLightBulbTap: widget.onLightBulbTap,
      ),
      drawer: _buildDrawer(context),
      body: widget.body,
      bottomNavigationBar: widget.bottomNavigationBar,
      floatingActionButton: widget.floatingActionButton,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final menuItems = DrawerMenuItemModel.getDefaultMenuItems();
    return DashboardDrawer(
      menuItems: menuItems,
      activeItemId: widget.activeItemId,
      onItemTap: (itemId) {
        Navigator.pop(context);
        if (widget.onDrawerItemTap != null) {
          widget.onDrawerItemTap!(context, itemId);
        } else {
          handleDrawerNavigation(
            context,
            currentItemId: widget.activeItemId,
            targetItemId: itemId,
          );
        }
      },
    );
  }

  void _showOutletPicker(BuildContext context) {
    showOutletPicker(
      context: context,
      availableOutlets: widget.availableOutlets,
      selectedOutlet: widget.selectedOutlet,
      onOutletSelected: widget.onOutletSelected,
    );
  }
}
