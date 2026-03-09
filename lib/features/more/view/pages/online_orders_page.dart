import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/common_scaffold.dart';
import '../../../../core/repositories/order_repository.dart' as repo;
import '../../viewmodel/online_orders_viewmodel.dart';
import '../../model/online_order_model.dart';
import '../../../dashboard/view/widgets/chat_support_button.dart';
import '../../../dashboard/view/widgets/platform_tab_bar.dart';
import '../../../dashboard/view/widgets/orders_chart_section.dart';
import '../widgets/online_orders_filter_section.dart';
import '../widgets/online_orders_data_table.dart';

/// Online Orders Activity page
class OnlineOrdersPage extends ConsumerStatefulWidget {
  const OnlineOrdersPage({super.key});

  @override
  ConsumerState<OnlineOrdersPage> createState() => _OnlineOrdersPageState();
}

class _OnlineOrdersPageState extends ConsumerState<OnlineOrdersPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final viewModel = ref.watch(onlineOrdersViewModelProvider);
    final viewModelNotifier = ref.read(onlineOrdersViewModelProvider.notifier);

    return CommonScaffold(
      activeItemId: 'online_orders',
      selectedOutlet: viewModel.selectedOutlet,
      availableOutlets: viewModel.availableOutlets,
      onOutletSelected: viewModelNotifier.setSelectedOutlet,
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
    final viewModel = ref.watch(onlineOrdersViewModelProvider);
    final viewModelNotifier = ref.read(onlineOrdersViewModelProvider.notifier);

    // Convert stores to RestaurantModel for widget compatibility
    final restaurantModels = viewModel.stores
        .map((store) => RestaurantModel(id: store.id, name: store.name))
        .toList();

    // Find selected restaurant model
    final selectedRestaurantModel = viewModel.selectedStoreId != null
        ? restaurantModels
              .where((r) => r.id == viewModel.selectedStoreId)
              .firstOrNull
        : null;

    // Convert orders to OnlineOrderModel for widget compatibility
    final onlineOrders = viewModel.orders
        .map(
          (order) => OnlineOrderModel(
            orderNo: order.orderNumber ?? '',
            outletName:
                viewModel.stores
                    .where((s) => s.id == order.storeId)
                    .firstOrNull
                    ?.name ??
                'Unknown',
            orderFrom: order.channel,
            orderType: order.channel,
            customerName: 'Guest',
            dateTime: order.createdAt,
            total: order.netAmount,
            status: _mapOrderStatus(order.status),
          ),
        )
        .toList();

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
                    platforms: viewModel.platforms,
                    selectedPlatformId: viewModel.selectedPlatformId,
                    onPlatformChanged: viewModelNotifier.setSelectedPlatform,
                  ),
                  // Chart section
                  OrdersChartSection(
                    isExpanded: viewModel.isChartExpanded,
                    onToggle: viewModelNotifier.toggleChartExpansion,
                  ),
                  // Filters section
                  OnlineOrdersFilterSection(
                    restaurants: restaurantModels,
                    selectedRestaurant: selectedRestaurantModel,
                    selectedRecordType: viewModel.selectedRecordType,
                    selectedStatus: viewModel.selectedStatus,
                    orderNoFilter: viewModel.orderNoFilter,
                    startDate: viewModel.startDate,
                    endDate: viewModel.endDate,
                    showDateRange: viewModel.showDateRange,
                    onRestaurantChanged: (restaurant) {
                      if (restaurant != null) {
                        viewModelNotifier.setSelectedRestaurant(
                          restaurant.name,
                        );
                      }
                    },
                    onRecordTypeChanged:
                        viewModelNotifier.setSelectedRecordType,
                    onStatusChanged: viewModelNotifier.setSelectedStatus,
                    onOrderNoChanged: viewModelNotifier.setOrderNoFilter,
                    onStartDateChanged: viewModelNotifier.setStartDate,
                    onEndDateChanged: viewModelNotifier.setEndDate,
                    onApply: viewModelNotifier.applyFilters,
                    onShowAll: viewModelNotifier.showAll,
                  ),
                  // Data table header
                  const OnlineOrdersTableHeader(),
                  // Data table content
                  OnlineOrdersDataTable(
                    orders: onlineOrders,
                    isLoading: viewModel.isLoading,
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

  /// Maps repository OrderStatus to UI OrderStatus
  OrderStatus _mapOrderStatus(repo.OrderStatus status) {
    switch (status) {
      case repo.OrderStatus.pending:
        return OrderStatus.waitingForAcceptance;
      case repo.OrderStatus.confirmed:
        return OrderStatus.accepted;
      case repo.OrderStatus.preparing:
        return OrderStatus.preparingFoodKotCreated;
      case repo.OrderStatus.ready:
        return OrderStatus.foodIsReady;
      case repo.OrderStatus.completed:
        return OrderStatus.delivered;
      case repo.OrderStatus.cancelled:
        return OrderStatus.all;
      case repo.OrderStatus.all:
        return OrderStatus.all;
    }
  }
}
