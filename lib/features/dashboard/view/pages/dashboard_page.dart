import 'package:flutter/material.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../../model/drawer_menu_item_model.dart';
import '../../viewmodel/dashboard_viewmodel.dart';
import '../widgets/dashboard_app_bar.dart';
import '../widgets/dashboard_drawer.dart';
import '../widgets/outlet_statistics_section.dart';
import '../widgets/stats_grid.dart';
import '../widgets/total_sales_card.dart';
import 'online_orders_page.dart';
import 'running_orders_page.dart';

/// Main dashboard page displaying sales statistics and outlet information
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final DashboardViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = DashboardViewModel();
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
          bottomNavigationBar: _buildBottomNav(),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return DashboardAppBar(
      selectedOutlet: _viewModel.selectedOutlet,
      onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      onOutletTap: _showOutletPicker,
      onLightBulbTap: () {},
    );
  }

  Widget _buildDrawer() {
    final menuItems = DrawerMenuItemModel.getDefaultMenuItems();
    return DashboardDrawer(
      menuItems: menuItems,
      activeItemId: 'dashboard',
      onItemTap: (itemId) {
        Navigator.pop(context);
        _handleDrawerNavigation(itemId);
      },
    );
  }

  void _handleDrawerNavigation(String itemId) {
    switch (itemId) {
      case 'running_orders':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RunningOrdersPage()),
        );
        break;
      case 'online_orders':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OnlineOrdersPage()),
        );
        break;
      // Add more cases for other menu items as needed
      default:
        // Handle other menu items or do nothing
        break;
    }
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildTotalSalesCard(),
          const SizedBox(height: 16),
          _buildStatsGrid(),
          const SizedBox(height: 24),
          _buildOutletStatistics(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Dashboard',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          _buildDateSelector(),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: _showDatePicker,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _viewModel.formattedDate,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              color: colorScheme.onSurfaceVariant,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSalesCard() {
    final stats = _viewModel.stats;
    return TotalSalesCard(
      totalSales: stats.totalSales,
      totalOutlets: stats.totalOutlets,
      totalOrders: stats.totalOrders,
      onChartTap: () {},
      onMoreTap: () {},
    );
  }

  Widget _buildStatsGrid() {
    return StatsGrid(stats: _viewModel.stats);
  }

  Widget _buildOutletStatistics() {
    return OutletStatisticsSection(
      tabLabels: _viewModel.statsTabLabels,
      activeTabIndex: _viewModel.activeStatsTab,
      outlets: _viewModel.outletStats,
      columnHeader: _viewModel.activeTabColumnHeader,
      valueGetter: _viewModel.getOutletValue,
      onTabChanged: (index) => _viewModel.setActiveStatsTab(index),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavBar(
      currentIndex: _viewModel.currentNavIndex,
      onTap: (index) => _viewModel.setCurrentNavIndex(index),
    );
  }

  void _showDatePicker() async {
    final colorScheme = Theme.of(context).colorScheme;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _viewModel.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: colorScheme.primary,
              onPrimary: colorScheme.onPrimary,
              surface: colorScheme.surface,
              onSurface: colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _viewModel.setSelectedDate(picked);
    }
  }

  void _showOutletPicker() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Select Outlet',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const Divider(height: 1),
            ...List.generate(_viewModel.availableOutlets.length, (index) {
              final outlet = _viewModel.availableOutlets[index];
              final isSelected = outlet == _viewModel.selectedOutlet;
              return ListTile(
                onTap: () {
                  _viewModel.setSelectedOutlet(outlet);
                  Navigator.pop(context);
                },
                leading: Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                title: Text(
                  outlet,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}
