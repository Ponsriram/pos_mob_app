import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_app/core/repositories/dashboard_repository.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../../../../core/widgets/common_scaffold.dart';
import '../../viewmodel/dashboard_viewmodel.dart';
import '../widgets/outlet_statistics_section.dart';
import '../widgets/stats_grid.dart';
import '../widgets/total_sales_card.dart';

/// Main dashboard page displaying sales statistics and outlet information
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardViewModelProvider);
    final viewModel = ref.read(dashboardViewModelProvider.notifier);

    // Listen for errors to show snackbar
    ref.listen(dashboardViewModelProvider, (prev, next) {
      if (next.error != null &&
          (prev?.error == null || prev?.error != next.error)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            action: SnackBarAction(
              label: 'Dismiss',
              onPressed: () => viewModel.clearError(),
            ),
          ),
        );
      }
    });

    return CommonScaffold(
      activeItemId: 'dashboard',
      selectedOutlet: state.selectedOutletName,
      availableOutlets: state.availableOutlets,
      onOutletSelected: viewModel.setSelectedOutlet,
      onLightBulbTap: () {},
      body: _buildBody(context, ref, state, viewModel),
      bottomNavigationBar: _buildBottomNav(state, viewModel),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    DashboardState state,
    DashboardViewModel viewModel,
  ) {
    if (state.isLoading && state.stats == DashboardStats.empty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: viewModel.refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, state, viewModel),
            const SizedBox(height: 16),
            _buildTotalSalesCard(state),
            const SizedBox(height: 16),
            _buildStatsGrid(state),
            const SizedBox(height: 24),
            _buildOutletStatistics(state, viewModel),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    DashboardState state,
    DashboardViewModel viewModel,
  ) {
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
          _buildDateSelector(context, state, viewModel),
        ],
      ),
    );
  }

  Widget _buildDateSelector(
    BuildContext context,
    DashboardState state,
    DashboardViewModel viewModel,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => _showDatePicker(context, state, viewModel),
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
              state.formattedDate,
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

  Widget _buildTotalSalesCard(DashboardState state) {
    final stats = state.stats;
    return TotalSalesCard(
      totalSales: stats.totalSales.toStringAsFixed(2),
      totalOutlets: state.stores.length,
      totalOrders: stats.totalOrders,
      onChartTap: () {},
      onMoreTap: () {},
    );
  }

  Widget _buildStatsGrid(DashboardState state) {
    return StatsGridNew(stats: state.stats);
  }

  Widget _buildOutletStatistics(
    DashboardState state,
    DashboardViewModel viewModel,
  ) {
    return OutletStatisticsSectionNew(
      tabLabels: state.statsTabLabels,
      activeTabIndex: state.activeStatsTab,
      outlets: state.outletStats,
      columnHeader: state.activeTabColumnHeader,
      valueGetter: viewModel.getOutletValue,
      onTabChanged: (index) => viewModel.setActiveStatsTab(index),
    );
  }

  Widget _buildBottomNav(DashboardState state, DashboardViewModel viewModel) {
    return BottomNavBar(
      currentIndex: state.currentNavIndex,
      onTap: (index) => viewModel.setCurrentNavIndex(index),
    );
  }

  void _showDatePicker(
    BuildContext context,
    DashboardState state,
    DashboardViewModel viewModel,
  ) async {
    final colorScheme = Theme.of(context).colorScheme;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: state.selectedDate,
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
      viewModel.setSelectedDate(picked);
    }
  }
}
