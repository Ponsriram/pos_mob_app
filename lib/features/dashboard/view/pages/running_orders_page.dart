import 'package:flutter/material.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../../model/drawer_menu_item_model.dart';
import '../../viewmodel/running_orders_viewmodel.dart';
import '../widgets/dashboard_drawer.dart';
import '../widgets/chat_support_button.dart';
import '../widgets/order_category_card.dart';
import '../widgets/order_summary_bottom_bar.dart';
import '../widgets/running_orders_app_bar.dart';
import '../widgets/running_orders_tab_bar.dart';

/// Main page for displaying running orders
class RunningOrdersPage extends StatefulWidget {
  const RunningOrdersPage({super.key});

  @override
  State<RunningOrdersPage> createState() => _RunningOrdersPageState();
}

class _RunningOrdersPageState extends State<RunningOrdersPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final RunningOrdersViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = RunningOrdersViewModel();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: colorScheme.surfaceContainerLowest,
          appBar: _buildAppBar(),
          drawer: _buildDrawer(),
          body: _buildBody(),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OrderSummaryBottomBar(
                totalOrders: _viewModel.totalOrderCount,
                totalAmount: _viewModel.totalEstimatedAmount,
              ),
              _buildBottomNav(),
            ],
          ),
          floatingActionButton: ChatSupportButton(
            onTap: () {
              // Handle chat support tap
            },
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return RunningOrdersAppBar(
      selectedOutlet: _viewModel.selectedOutlet,
      onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      onOutletTap: _showOutletPicker,
      onLightBulbTap: () {},
    );
  }

  Widget _buildDrawer() {
    return DashboardDrawer(
      menuItems: DrawerMenuItemModel.getDefaultMenuItems(),
      onItemTap: (index) {
        Navigator.pop(context);
        // Handle menu item tap
      },
    );
  }

  Widget _buildBody() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with back button, title and refresh button
        _buildHeader(colorScheme, textTheme),
        const SizedBox(height: 8),
        // Tab bar
        RunningOrdersTabBar(
          selectedIndex: _viewModel.selectedTabIndex,
          onTabChanged: (index) {
            _viewModel.setSelectedTabIndex(index);
          },
        ),
        // Content based on selected tab
        Expanded(
          child: _viewModel.selectedTabIndex == 0
              ? _buildRunningOrdersList()
              : _buildRunningTablesList(),
        ),
      ],
    );
  }

  Widget _buildHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          // Back button
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
            'Running Orders',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const Spacer(),
          // Refresh button
          GestureDetector(
            onTap: () {
              _viewModel.refreshOrders();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.sync,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildRunningOrdersList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _viewModel.orderCategories.length,
      itemBuilder: (context, index) {
        return OrderCategoryCard(
          category: _viewModel.orderCategories[index],
          onTap: () {
            // Handle category tap
          },
        );
      },
    );
  }

  Widget _buildRunningTablesList() {
    // Placeholder for Running Tables tab
    return const Center(child: Text('Running Tables'));
  }

  Widget _buildBottomNav() {
    return const BottomNavBar(currentIndex: 0);
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
              ListTile(
                title: const Text('Outlet 2'),
                leading: Radio<String>(
                  value: 'Outlet 2',
                  groupValue: _viewModel.selectedOutlet,
                  onChanged: (value) {
                    _viewModel.setSelectedOutlet(value!);
                    Navigator.pop(context);
                  },
                ),
                onTap: () {
                  _viewModel.setSelectedOutlet('Outlet 2');
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
