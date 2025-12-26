import 'package:flutter/material.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../../../../core/widgets/common_scaffold.dart';
import '../../viewmodel/running_orders_viewmodel.dart';
import '../../../dashboard/view/widgets/chat_support_button.dart';
import '../../../dashboard/view/widgets/order_category_card.dart';
import '../../../dashboard/view/widgets/order_summary_bottom_bar.dart';
import '../widgets/running_orders_tab_bar.dart';

/// Main page for displaying running orders
class RunningOrdersPage extends StatefulWidget {
  const RunningOrdersPage({super.key});

  @override
  State<RunningOrdersPage> createState() => _RunningOrdersPageState();
}

class _RunningOrdersPageState extends State<RunningOrdersPage> {
  late final RunningOrdersViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = RunningOrdersViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return CommonScaffold(
          activeItemId: 'running_orders',
          selectedOutlet: _viewModel.selectedOutlet,
          availableOutlets: _viewModel.availableOutlets,
          onOutletSelected: _viewModel.setSelectedOutlet,
          onLightBulbTap: () {},
          body: _buildBody(),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OrderSummaryBottomBar(
                totalOrders: _viewModel.selectedTabIndex == 0
                    ? _viewModel.totalOrderCount
                    : _viewModel.totalTableCount,
                totalAmount: _viewModel.totalEstimatedAmount,
                orderLabel: _viewModel.selectedTabIndex == 0
                    ? 'Total Running Orders'
                    : 'Total Running Tables',
                amountLabel: 'Estimated Total',
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
    final isOrdersTab = _viewModel.selectedTabIndex == 0;
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
            isOrdersTab ? 'Running Orders' : 'Running Table',
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Show empty state when no tables
    if (_viewModel.totalTableCount == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Table with umbrella icon
            Icon(
              Icons.table_restaurant_outlined,
              size: 100,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No Running Table Found',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    // TODO: Build actual tables list when data is available
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 0,
      itemBuilder: (context, index) {
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildBottomNav() {
    return const BottomNavBar(currentIndex: 0);
  }
}
