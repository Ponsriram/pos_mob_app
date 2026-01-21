import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/common_scaffold.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../dashboard/view/widgets/chat_support_button.dart';
import '../../viewmodel/pending_purchase_viewmodel.dart';
import '../widgets/pending_purchase_filter_section.dart';

/// Purchase Pending After Sales Or Transfer page
class PendingPurchasePage extends ConsumerStatefulWidget {
  const PendingPurchasePage({super.key});

  @override
  ConsumerState<PendingPurchasePage> createState() =>
      _PendingPurchasePageState();
}

class _PendingPurchasePageState extends ConsumerState<PendingPurchasePage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(pendingPurchaseViewModelProvider);

    return CommonScaffold(
      activeItemId: 'pending_purchases',
      selectedOutlet: state.selectedOutlet,
      availableOutlets: state.outlets,
      onOutletSelected: ref
          .read(pendingPurchaseViewModelProvider.notifier)
          .setSelectedOutlet,
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
    final state = ref.watch(pendingPurchaseViewModelProvider);
    final notifier = ref.read(pendingPurchaseViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with back button and title
        _buildHeader(colorScheme, textTheme),
        // Filter section
        PendingPurchaseFilterSection(
          restaurants: state.restaurants,
          selectedRestaurant: state.selectedRestaurant,
          startDate: state.startDate,
          endDate: state.endDate,
          onRestaurantChanged: notifier.setSelectedRestaurant,
          onStartDateChanged: notifier.setStartDate,
          onEndDateChanged: notifier.setEndDate,
          onSearch: notifier.search,
          onShowAll: notifier.showAll,
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
    final state = ref.watch(pendingPurchaseViewModelProvider);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.isEmpty) {
      return const EmptyStateWidget(
        message: 'No Pending Purchase Sales / Transfer Found',
      );
    }

    // TODO: Build the list of pending purchases when data is available
    return const SizedBox.shrink();
  }
}
