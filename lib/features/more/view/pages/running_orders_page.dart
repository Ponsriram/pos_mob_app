import 'package:flutter/material.dart';
import '../../../../core/common/common_scaffold.dart';
import '../../../dashboard/view/widgets/chat_support_button.dart';
import '../../../dashboard/view/widgets/order_category_card.dart';
import '../../../dashboard/view/widgets/order_summary_bottom_bar.dart';
import '../../../dashboard/model/order_category_model.dart';
import '../widgets/running_orders_tab_bar.dart';

/// Main page for displaying running orders
class RunningOrdersPage extends StatefulWidget {
  const RunningOrdersPage({super.key});

  @override
  State<RunningOrdersPage> createState() => _RunningOrdersPageState();
}

class _RunningOrdersPageState extends State<RunningOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      activeItemId: 'running_orders',
      selectedOutlet: 'All Outlets',
      availableOutlets: const ['All Outlets'],
      onOutletSelected: (_) {},
      onLightBulbTap: () {},
      body: _buildBody(),
      bottomNavigationBar: const OrderSummaryBottomBar(
        totalOrders: 0,
        totalAmount: 0.0,
        orderLabel: 'Total Running Orders',
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with back button, title and refresh button
        _buildHeader(colorScheme, textTheme),
        const SizedBox(height: 8),
        // Tab bar
        RunningOrdersTabBar(selectedIndex: 0, onTabChanged: (_) {}),
        // Content based on selected tab
        Expanded(child: _buildRunningOrdersList()),
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
              () {}();
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
      itemCount: 0,
      itemBuilder: (context, index) {
        final categories = <OrderCategoryModel>[];
        return OrderCategoryCard(category: categories[index], onTap: () {});
      },
    );
  }
}
