import 'package:flutter/material.dart';
import '../../../../core/widgets/common_scaffold.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../dashboard/view/widgets/chat_support_button.dart';
import '../../viewmodel/pending_purchase_viewmodel.dart';
import '../widgets/pending_purchase_filter_section.dart';

/// Purchase Pending After Sales Or Transfer page
class PendingPurchasePage extends StatefulWidget {
  const PendingPurchasePage({super.key});

  @override
  State<PendingPurchasePage> createState() => _PendingPurchasePageState();
}

class _PendingPurchasePageState extends State<PendingPurchasePage> {
  late final PendingPurchaseViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = PendingPurchaseViewModel();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return CommonScaffold(
          activeItemId: 'pending_purchases',
          selectedOutlet: _viewModel.selectedOutlet,
          availableOutlets: _viewModel.outlets,
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
        // Header with back button and title
        _buildHeader(colorScheme, textTheme),
        // Filter section
        PendingPurchaseFilterSection(
          restaurants: _viewModel.restaurants,
          selectedRestaurant: _viewModel.selectedRestaurant,
          startDate: _viewModel.startDate,
          endDate: _viewModel.endDate,
          onRestaurantChanged: _viewModel.setSelectedRestaurant,
          onStartDateChanged: _viewModel.setStartDate,
          onEndDateChanged: _viewModel.setEndDate,
          onSearch: _viewModel.search,
          onShowAll: _viewModel.showAll,
        ),
        // Divider
        Container(height: 8, color: colorScheme.surfaceContainerLowest),
        // Content area
        Expanded(
          child: Container(
            color: colorScheme.surfaceContainerLowest,
            child: _buildContent(),
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
          Expanded(
            child: Text(
              'Purchase Pending After Sales Or Transfer',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_viewModel.isEmpty) {
      return const EmptyStateWidget(
        message: 'No Pending Purchase Sales / Transfer Found',
      );
    }

    // TODO: Build the list of pending purchases when data is available
    return const SizedBox.shrink();
  }
}
