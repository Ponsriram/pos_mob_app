import 'package:flutter/material.dart';
import '../../../../core/widgets/common_scaffold.dart';
import '../../viewmodel/online_orders_viewmodel.dart';
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
        return CommonScaffold(
          activeItemId: 'online_orders',
          selectedOutlet: _viewModel.selectedOutlet,
          availableOutlets: _viewModel.availableOutlets,
          onOutletSelected: _viewModel.setSelectedOutlet,
          onLightBulbTap: () {},
          backgroundColor: colorScheme.surface,
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
}
