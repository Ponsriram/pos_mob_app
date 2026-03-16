import 'package:flutter/material.dart';
import '../../../../core/common/common_scaffold.dart';
import '../../model/online_order_model.dart';
import '../../../dashboard/view/widgets/chat_support_button.dart';
import '../../../dashboard/view/widgets/platform_tab_bar.dart';
import '../../../dashboard/view/widgets/orders_chart_section.dart';
import '../widgets/online_orders_filter_section.dart';
import '../widgets/online_orders_data_table.dart';

/// Online Orders Activity page
class OnlineOrdersPage extends StatefulWidget {
  const OnlineOrdersPage({super.key});

  @override
  State<OnlineOrdersPage> createState() => _OnlineOrdersPageState();
}

class _OnlineOrdersPageState extends State<OnlineOrdersPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return CommonScaffold(
      activeItemId: 'online_orders',
      selectedOutlet: 'All Outlets',
      availableOutlets: const ['All Outlets'],
      onOutletSelected: (_) {},
      onLightBulbTap: () {},
      backgroundColor: colorScheme.surface,
      body: _buildBody(),
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
    const List<RestaurantModel> restaurantModels = [];
    const RestaurantModel? selectedRestaurantModel = null;
    const List<OnlineOrderModel> onlineOrders = [];

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
                    platforms: const [],
                    selectedPlatformId: 'all',
                    onPlatformChanged: (_) {},
                  ),
                  // Chart section
                  OrdersChartSection(isExpanded: false, onToggle: () {}),
                  // Filters section
                  OnlineOrdersFilterSection(
                    restaurants: restaurantModels,
                    selectedRestaurant: selectedRestaurantModel,
                    selectedRecordType: RecordType.last2DaysRecords,
                    selectedStatus: OrderStatus.all,
                    orderNoFilter: '',
                    startDate: DateTime.now(),
                    endDate: DateTime.now(),
                    showDateRange: false,
                    onRestaurantChanged: (_) {},
                    onRecordTypeChanged: (_) {},
                    onStatusChanged: (_) {},
                    onOrderNoChanged: (_) {},
                    onStartDateChanged: (_) {},
                    onEndDateChanged: (_) {},
                    onApply: () {},
                    onShowAll: () {},
                  ),
                  // Data table header
                  const OnlineOrdersTableHeader(),
                  // Data table content
                  OnlineOrdersDataTable(orders: onlineOrders, isLoading: false),
                ],
              ),
            ),
          ),
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
}
