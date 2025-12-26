import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../dashboard/model/drawer_menu_item_model.dart';
import '../../../dashboard/view/widgets/dashboard_drawer.dart';
import '../../../dashboard/view/widgets/chat_support_button.dart';
import '../../../dashboard/view/pages/notification_page.dart';
import 'online_orders_page.dart';
import 'pending_purchase_page.dart';
import 'running_orders_page.dart';

/// Thirdparty User List page
class ThirdpartyUserListPage extends ConsumerStatefulWidget {
  const ThirdpartyUserListPage({super.key});

  @override
  ConsumerState<ThirdpartyUserListPage> createState() =>
      _ThirdpartyUserListPageState();
}

class _ThirdpartyUserListPageState
    extends ConsumerState<ThirdpartyUserListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedOutlet = 'All Outlets';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(colorScheme),
      drawer: _buildDrawer(),
      body: _buildBody(),
      floatingActionButton: ChatSupportButton(
        onTap: () {
          // Handle chat support tap
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ColorScheme colorScheme) {
    final themeNotifier = ref.read(themeModeNotifierProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        icon: Icon(Icons.menu, color: colorScheme.primary),
      ),
      title: _buildOutletSelector(colorScheme),
      titleSpacing: 0,
      actions: [
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
          onPressed: () {},
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
      ],
    );
  }

  Widget _buildOutletSelector(ColorScheme colorScheme) {
    return GestureDetector(
      onTap: _showOutletPicker,
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
                _selectedOutlet,
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

  Widget _buildDrawer() {
    final menuItems = DrawerMenuItemModel.getDefaultMenuItems();
    return DashboardDrawer(
      menuItems: menuItems,
      activeItemId: 'thirdparty_config',
      onItemTap: (itemId) {
        Navigator.pop(context);
        _handleDrawerNavigation(itemId);
      },
    );
  }

  void _handleDrawerNavigation(String itemId) {
    switch (itemId) {
      case 'dashboard':
        Navigator.pop(context); // Go back to dashboard
        break;
      case 'running_orders':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RunningOrdersPage()),
        );
        break;
      case 'online_orders':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnlineOrdersPage()),
        );
        break;
      case 'thirdparty_config':
        // Already on this page, do nothing
        break;
      case 'pending_purchases':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PendingPurchasePage(),
          ),
        );
        break;
      default:
        break;
    }
  }

  Widget _buildBody() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with back arrow and title
        _buildHeader(colorScheme, textTheme),
        // Main content with empty state
        Expanded(
          child: Container(
            color: colorScheme.surfaceContainerLowest,
            child: _buildEmptyState(colorScheme, textTheme),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: colorScheme.outline.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),

              child: Icon(
                Icons.arrow_back,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
          // Title on left
          Text(
            'Thirdparty User List',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration with decorative circles
            SizedBox(
              height: 150,
              width: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Decorative pink circles
                  Positioned(
                    top: 10,
                    left: 30,
                    child: _buildDecorativeCircle(20),
                  ),
                  Positioned(
                    top: 5,
                    right: 40,
                    child: _buildDecorativeCircle(24),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 20,
                    child: _buildDecorativeCircle(16),
                  ),
                  Positioned(
                    top: 40,
                    right: 25,
                    child: _buildDecorativeCircle(18),
                  ),
                  Positioned(
                    bottom: 50,
                    right: 35,
                    child: _buildDecorativeCircle(12),
                  ),
                  // Main icon - document with magnifying glass
                  Center(
                    child: Icon(
                      Icons.find_in_page_outlined,
                      size: 80,
                      color: colorScheme.outline.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // "Record Not Found" text
            Text(
              'Record Not Found',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDecorativeCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFFCDD2).withValues(alpha: 0.6),
      ),
    );
  }

  void _showOutletPicker() {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('All Outlets'),
                leading: Radio<String>(
                  value: 'All Outlets',
                  groupValue: _selectedOutlet,
                  onChanged: (value) {
                    setState(() {
                      _selectedOutlet = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
                onTap: () {
                  setState(() {
                    _selectedOutlet = 'All Outlets';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Outlet 1'),
                leading: Radio<String>(
                  value: 'Outlet 1',
                  groupValue: _selectedOutlet,
                  onChanged: (value) {
                    setState(() {
                      _selectedOutlet = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
                onTap: () {
                  setState(() {
                    _selectedOutlet = 'Outlet 1';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
