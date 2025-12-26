import 'package:flutter/material.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../../../../core/widgets/common_scaffold.dart';
import '../../viewmodel/dashboard_viewmodel.dart';
import '../widgets/outlet_statistics_section.dart';
import '../widgets/stats_grid.dart';
import '../widgets/total_sales_card.dart';

/// Main dashboard page displaying sales statistics and outlet information
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final DashboardViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = DashboardViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return CommonScaffold(
          activeItemId: 'dashboard',
          selectedOutlet: _viewModel.selectedOutlet,
          availableOutlets: _viewModel.availableOutlets,
          onOutletSelected: _viewModel.setSelectedOutlet,
          onLightBulbTap: () {},
          body: _buildBody(),
          bottomNavigationBar: _buildBottomNav(),
        );
      },
    );
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
}
