import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/common_scaffold.dart';
import '../../viewmodel/running_orders_viewmodel.dart';
import '../../../dashboard/view/widgets/chat_support_button.dart';
import '../../../dashboard/view/widgets/order_category_card.dart';
import '../../../dashboard/view/widgets/order_summary_bottom_bar.dart';
import '../widgets/running_orders_tab_bar.dart';

/// Main page for displaying running orders
class RunningOrdersPage extends ConsumerStatefulWidget {
  const RunningOrdersPage({super.key});

  @override
  ConsumerState<RunningOrdersPage> createState() => _RunningOrdersPageState();
}

class _RunningOrdersPageState extends ConsumerState<RunningOrdersPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(runningOrdersViewModelProvider);

    return CommonScaffold(
      activeItemId: 'running_orders',
      selectedOutlet: state.selectedOutlet,
      availableOutlets: state.availableOutlets,
      onOutletSelected: ref
          .read(runningOrdersViewModelProvider.notifier)
          .setSelectedOutlet,
      onLightBulbTap: () {},
      body: _buildBody(),
      bottomNavigationBar: OrderSummaryBottomBar(
        totalOrders: state.selectedTabIndex == 0
            ? state.totalOrderCount
            : state.totalTableCount,
        totalAmount: state.totalEstimatedAmount,
        orderLabel: state.selectedTabIndex == 0
            ? 'Total Running Orders'
            : 'Total Running Tables',
        amountLabel: 'Estimated Total',
      ),
      floatingActionButton: ChatSupportButton(
        onTap: () {
          // Handle chat support tap
        },
      ),
    );
  }

  Widget _buildBody() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final state = ref.watch(runningOrdersViewModelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with back button, title and refresh button
        _buildHeader(colorScheme, textTheme),
        const SizedBox(height: 8),
        // Tab bar
        RunningOrdersTabBar(
          selectedIndex: state.selectedTabIndex,
          onTabChanged: (index) {
            ref
                .read(runningOrdersViewModelProvider.notifier)
                .setSelectedTabIndex(index);
          },
        ),
        // Content based on selected tab
        Expanded(
          child: state.selectedTabIndex == 0
              ? _buildRunningOrdersList()
              : _buildRunningTablesList(),
        ),
      ],
    );
  }

  Widget _buildHeader(ColorScheme colorScheme, TextTheme textTheme) {
    final state = ref.watch(runningOrdersViewModelProvider);
    final isOrdersTab = state.selectedTabIndex == 0;
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
              ref.read(runningOrdersViewModelProvider.notifier).refreshOrders();
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
    final state = ref.watch(runningOrdersViewModelProvider);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: state.orderCategories.length,
      itemBuilder: (context, index) {
        return OrderCategoryCard(
          category: state.orderCategories[index],
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
    final state = ref.watch(runningOrdersViewModelProvider);

    // Show empty state when no tables
    if (state.totalTableCount == 0) {
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
}
