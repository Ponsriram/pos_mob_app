import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/pos_app_bar.dart';
import '../../../dashboard/view/pages/notification_page.dart';
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
  late final PendingPurchaseViewModel _viewModel;
  int _bottomNavIndex = 0;

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
        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: PosAppBar(
            selectedOutlet: _viewModel.selectedOutlet,
            onMenuTap: () {
              // Open drawer or handle menu tap
            },
            onOutletTap: _showOutletPicker,
            onLightBulbTap: () {},
            onNotificationTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationPage(),
                ),
              );
            },
          ),
          body: _buildBody(),
          bottomNavigationBar: BottomNavBar(
            currentIndex: _bottomNavIndex,
            onTap: (index) {
              setState(() {
                _bottomNavIndex = index;
              });
            },
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
        // Divider line
        Container(height: 1, color: colorScheme.primary),
        // Title
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Purchase Pending After Sales Or Transfer',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ),
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

  void _showOutletPicker() {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _viewModel.outlets.map((outlet) {
              return ListTile(
                title: Text(outlet),
                leading: Radio<String>(
                  value: outlet,
                  groupValue: _viewModel.selectedOutlet,
                  onChanged: (value) {
                    _viewModel.setSelectedOutlet(value!);
                    Navigator.pop(context);
                  },
                ),
                onTap: () {
                  _viewModel.setSelectedOutlet(outlet);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
