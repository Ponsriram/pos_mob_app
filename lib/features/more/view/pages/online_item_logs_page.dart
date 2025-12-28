import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/widgets/common_scaffold.dart';
import '../../viewmodel/online_item_logs_viewmodel.dart';

/// Online Item On/Off Logs page
class OnlineItemLogsPage extends StatefulWidget {
  const OnlineItemLogsPage({super.key});

  @override
  State<OnlineItemLogsPage> createState() => _OnlineItemLogsPageState();
}

class _OnlineItemLogsPageState extends State<OnlineItemLogsPage> {
  late final OnlineItemLogsViewModel _viewModel;
  late final TextEditingController _searchItemController;

  @override
  void initState() {
    super.initState();
    _viewModel = OnlineItemLogsViewModel();
    _searchItemController = TextEditingController();
  }

  @override
  void dispose() {
    _searchItemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return CommonScaffold(
          activeItemId: 'online_item_logs',
          selectedOutlet: _viewModel.selectedOutlet,
          availableOutlets: _viewModel.availableOutlets,
          onOutletSelected: _viewModel.setSelectedOutlet,
          onLightBulbTap: () {},
          backgroundColor: colorScheme.surface,
          body: _buildBody(),
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
        // Main content
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                // Page title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Item on/off Logs',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Info banner
                _buildInfoBanner(colorScheme, textTheme),
                const SizedBox(height: 16),
                // Search section
                _buildSearchSection(colorScheme, textTheme),
                const SizedBox(height: 16),
                // Content area
                _buildContent(colorScheme, textTheme),
                const SizedBox(height: 32),
              ],
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
            'Item on/off Logs',
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

  Widget _buildInfoBanner(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'When All outlets selected date filter available with only date',
              style: textTheme.bodySmall?.copyWith(color: colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      children: [
        // Search header (collapsible)
        InkWell(
          onTap: _viewModel.toggleSearchExpanded,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
                bottom: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Search',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                Icon(
                  _viewModel.isSearchExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
        // Search form (collapsible content)
        if (_viewModel.isSearchExpanded)
          _buildSearchForm(colorScheme, textTheme),
      ],
    );
  }

  Widget _buildSearchForm(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Select Restaurant (with checkboxes)
          Text(
            'Select Restaurant',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          _buildRestaurantDropdown(colorScheme, textTheme),
          const SizedBox(height: 16),
          // From Date
          Text(
            'From Date',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          _buildDateField(
            colorScheme: colorScheme,
            textTheme: textTheme,
            date: _viewModel.fromDate,
            onDateSelected: _viewModel.setFromDate,
          ),
          const SizedBox(height: 16),
          // To Date
          Text(
            'To Date',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          _buildDateField(
            colorScheme: colorScheme,
            textTheme: textTheme,
            date: _viewModel.toDate,
            onDateSelected: _viewModel.setToDate,
          ),
          const SizedBox(height: 16),
          // Select Outlet
          Text(
            'Select Outlet',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          _buildDropdown(
            colorScheme: colorScheme,
            textTheme: textTheme,
            value: _viewModel.selectedOutletFilter,
            items: _viewModel.outlets,
            onChanged: _viewModel.setSelectedOutletFilter,
          ),
          const SizedBox(height: 16),
          // Search ItemID / Name
          Text(
            'Search ItemID / Name',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _searchItemController,
            onChanged: _viewModel.setSearchItemIdName,
            decoration: InputDecoration(
              hintText: '',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: colorScheme.primary),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Search and Reset buttons
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  _viewModel.search();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Search',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () {
                  _searchItemController.clear();
                  _viewModel.reset();
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide(color: colorScheme.outline),
                ),
                child: Text(
                  'Reset',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantDropdown(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return InkWell(
      onTap: () => _showRestaurantSelector(colorScheme, textTheme),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _viewModel.restaurantDisplayText,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  void _showRestaurantSelector(ColorScheme colorScheme, TextTheme textTheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Restaurant',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // All checkbox
                  CheckboxListTile(
                    value: _viewModel.isAllRestaurantsSelected,
                    onChanged: (value) {
                      setModalState(() {
                        _viewModel.toggleAllRestaurants();
                      });
                    },
                    title: Text(
                      'All',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const Divider(),
                  // Individual restaurant checkboxes
                  ...(_viewModel.restaurants.where(
                    (r) => r != 'Please Select',
                  )).map((restaurant) {
                    return CheckboxListTile(
                      value: _viewModel.selectedRestaurants.contains(
                        restaurant,
                      ),
                      onChanged: (value) {
                        setModalState(() {
                          _viewModel.toggleRestaurant(restaurant);
                        });
                      },
                      title: Text(
                        restaurant,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    );
                  }),
                  const SizedBox(height: 16),
                  // Done button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Done',
                        style: textTheme.labelLarge?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDropdown({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          borderRadius: BorderRadius.circular(8),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: colorScheme.onSurfaceVariant,
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
      ),
    );
  }

  Widget _buildDateField({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required DateTime? date,
    required Function(DateTime?) onDateSelected,
  }) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (selectedDate != null) {
          onDateSelected(selectedDate);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 20,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Text(
              date != null ? DateFormat('dd MMM yyyy').format(date) : '',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ColorScheme colorScheme, TextTheme textTheme) {
    if (_viewModel.isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
      );
    }

    if (_viewModel.logs.isEmpty) {
      return _buildEmptyState(colorScheme, textTheme);
    }

    // TODO: Build list of logs
    return const SizedBox.shrink();
  }

  Widget _buildEmptyState(ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search,
                size: 32,
                color: colorScheme.primary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No Record Found',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We could not find what you searched for Try searching again',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
