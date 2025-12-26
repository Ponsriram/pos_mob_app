import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../dashboard/model/drawer_menu_item_model.dart';
import '../../viewmodel/online_orders_viewmodel.dart';
import '../../../dashboard/view/widgets/dashboard_drawer.dart';
import '../../../dashboard/view/widgets/chat_support_button.dart';
import '../../../dashboard/view/widgets/platform_tab_bar.dart';
import '../../../dashboard/view/widgets/orders_chart_section.dart';
import '../widgets/online_orders_filter_section.dart';
import '../widgets/online_orders_data_table.dart';
import '../../../dashboard/view/pages/notification_page.dart';
import 'pending_purchase_page.dart';
import 'running_orders_page.dart';
import 'thirdparty_user_list_page.dart';

/// Online Orders Activity page
class OnlineOrdersPage extends ConsumerStatefulWidget {
  const OnlineOrdersPage({super.key});

  @override
  ConsumerState<OnlineOrdersPage> createState() => _OnlineOrdersPageState();
}

class _OnlineOrdersPageState extends ConsumerState<OnlineOrdersPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final OnlineOrdersViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = OnlineOrdersViewModel();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
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
      },
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
                _viewModel.selectedOutlet,
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
      activeItemId: 'online_orders',
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
        // Already on this page, do nothing
        break;
      case 'thirdparty_config':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ThirdpartyUserListPage(),
          ),
        );
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
        // Header with title and back button
        _buildHeader(colorScheme, textTheme),
        // Main content
        Expanded(
          child: Container(
            color: colorScheme.surfaceContainerLowest,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section title with user icon
                  _buildSectionHeader(colorScheme, textTheme),
                  // Platform tabs
                  PlatformTabBar(
                    platforms: _viewModel.platforms,
                    selectedPlatformId: _viewModel.selectedPlatformId,
                    onPlatformChanged: _viewModel.setSelectedPlatform,
                  ),
                  // Chart section
                  OrdersChartSection(
                    isExpanded: _viewModel.isChartExpanded,
                    onToggle: _viewModel.toggleChartExpansion,
                  ),
                  // Filters section
                  OnlineOrdersFilterSection(
                    restaurants: _viewModel.restaurants,
                    selectedRestaurant: _viewModel.selectedRestaurant,
                    selectedRecordType: _viewModel.selectedRecordType,
                    selectedStatus: _viewModel.selectedStatus,
                    orderNoFilter: _viewModel.orderNoFilter,
                    startDate: _viewModel.startDate,
                    endDate: _viewModel.endDate,
                    showDateRange: _viewModel.showDateRange,
                    onRestaurantChanged: _viewModel.setSelectedRestaurant,
                    onRecordTypeChanged: _viewModel.setSelectedRecordType,
                    onStatusChanged: _viewModel.setSelectedStatus,
                    onOrderNoChanged: _viewModel.setOrderNoFilter,
                    onStartDateChanged: _viewModel.setStartDate,
                    onEndDateChanged: _viewModel.setEndDate,
                    onApply: _viewModel.applyFilters,
                    onShowAll: _viewModel.showAll,
                  ),
                  // Data table header
                  const OnlineOrdersTableHeader(),
                  // Data table content
                  OnlineOrdersDataTable(
                    orders: _viewModel.orders,
                    isLoading: _viewModel.isLoading,
                  ),
                ],
              ),
            ),
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
                size: 24,
              ),
            ),
          ),
          // Title
          Text(
            'Online Orders Activity',
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

  Widget _buildSectionHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text(
            'Online Orders Activity',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          // User icon button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.person_add_outlined,
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
        ],
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
                  groupValue: _viewModel.selectedOutlet,
                  onChanged: (value) {
                    _viewModel.setSelectedOutlet(value!);
                    Navigator.pop(context);
                  },
                ),
                onTap: () {
                  _viewModel.setSelectedOutlet('All Outlets');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Outlet 1'),
                leading: Radio<String>(
                  value: 'Outlet 1',
                  groupValue: _viewModel.selectedOutlet,
                  onChanged: (value) {
                    _viewModel.setSelectedOutlet(value!);
                    Navigator.pop(context);
                  },
                ),
                onTap: () {
                  _viewModel.setSelectedOutlet('Outlet 1');
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
