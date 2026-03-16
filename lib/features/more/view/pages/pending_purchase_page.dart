import 'package:flutter/material.dart';
import '../../../../core/common/common_scaffold.dart';
import '../../../dashboard/view/widgets/chat_support_button.dart';
import '../widgets/pending_purchase_filter_section.dart';

/// Purchase Pending After Sales Or Transfer page
class PendingPurchasePage extends StatefulWidget {
  const PendingPurchasePage({super.key});

  @override
  State<PendingPurchasePage> createState() => _PendingPurchasePageState();
}

class _PendingPurchasePageState extends State<PendingPurchasePage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CommonScaffold(
      activeItemId: 'pending_purchases',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with back button and title
        _buildHeader(colorScheme, textTheme),
        // Filter section
        PendingPurchaseFilterSection(
          restaurants: const <String>[],
          selectedRestaurant: '',
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          onRestaurantChanged: (_) {},
          onStartDateChanged: (_) {},
          onEndDateChanged: (_) {},
          onSearch: () {},
          onShowAll: () {},
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
    return const SizedBox.shrink();
  }
}
