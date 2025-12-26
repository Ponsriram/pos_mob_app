import 'package:flutter/material.dart';
import '../../model/online_order_model.dart';

/// Filter section for online orders
class OnlineOrdersFilterSection extends StatelessWidget {
  final List<RestaurantModel> restaurants;
  final RestaurantModel? selectedRestaurant;
  final RecordType selectedRecordType;
  final OrderStatus selectedStatus;
  final String orderNoFilter;
  final DateTime startDate;
  final DateTime endDate;
  final bool showDateRange;
  final ValueChanged<RestaurantModel?> onRestaurantChanged;
  final ValueChanged<RecordType> onRecordTypeChanged;
  final ValueChanged<OrderStatus> onStatusChanged;
  final ValueChanged<String> onOrderNoChanged;
  final ValueChanged<DateTime> onStartDateChanged;
  final ValueChanged<DateTime> onEndDateChanged;
  final VoidCallback onApply;
  final VoidCallback onShowAll;

  const OnlineOrdersFilterSection({
    super.key,
    required this.restaurants,
    required this.selectedRestaurant,
    required this.selectedRecordType,
    required this.selectedStatus,
    required this.orderNoFilter,
    required this.startDate,
    required this.endDate,
    required this.showDateRange,
    required this.onRestaurantChanged,
    required this.onRecordTypeChanged,
    required this.onStatusChanged,
    required this.onOrderNoChanged,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onApply,
    required this.onShowAll,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Select Restaurant
          _buildLabel(textTheme, colorScheme, 'Select Restaurant'),
          const SizedBox(height: 8),
          _buildRestaurantDropdown(context, colorScheme),
          const SizedBox(height: 16),

          // Record Type
          _buildLabel(textTheme, colorScheme, 'Record Type'),
          const SizedBox(height: 8),
          _buildRecordTypeDropdown(context, colorScheme),
          const SizedBox(height: 16),

          // Date Range (only for "Get old records")
          if (showDateRange) ...[
            // Start Date
            _buildLabel(textTheme, colorScheme, 'Start Date'),
            const SizedBox(height: 8),
            _buildDatePicker(
              context,
              colorScheme,
              startDate,
              onStartDateChanged,
            ),
            const SizedBox(height: 16),

            // End Date
            _buildLabel(textTheme, colorScheme, 'End Date'),
            const SizedBox(height: 8),
            _buildDatePicker(context, colorScheme, endDate, onEndDateChanged),
            const SizedBox(height: 16),
          ],

          // Status
          _buildLabel(textTheme, colorScheme, 'Status'),
          const SizedBox(height: 8),
          _buildStatusDropdown(context, colorScheme),
          const SizedBox(height: 16),

          // Order No
          _buildLabel(textTheme, colorScheme, 'Order No.'),
          const SizedBox(height: 8),
          _buildOrderNoField(context, colorScheme),
          const SizedBox(height: 24),

          // Action buttons
          _buildActionButtons(context, colorScheme),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildLabel(
    TextTheme textTheme,
    ColorScheme colorScheme,
    String label,
  ) {
    return Text(
      label,
      style: textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
    );
  }

  Widget _buildRestaurantDropdown(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return _SearchableDropdown<RestaurantModel>(
      items: restaurants,
      selectedItem: selectedRestaurant,
      displayText: (item) => item.displayName,
      searchHint: 'Search restaurant...',
      onChanged: onRestaurantChanged,
      colorScheme: colorScheme,
    );
  }

  Widget _buildRecordTypeDropdown(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return _buildDropdown<RecordType>(
      context: context,
      colorScheme: colorScheme,
      value: selectedRecordType,
      items: RecordType.values,
      displayText: (item) => item.displayName,
      onChanged: (value) => onRecordTypeChanged(value!),
    );
  }

  Widget _buildStatusDropdown(BuildContext context, ColorScheme colorScheme) {
    return _buildDropdown<OrderStatus>(
      context: context,
      colorScheme: colorScheme,
      value: selectedStatus,
      items: OrderStatus.values,
      displayText: (item) => item.displayName,
      onChanged: (value) => onStatusChanged(value!),
    );
  }

  Widget _buildDropdown<T>({
    required BuildContext context,
    required ColorScheme colorScheme,
    required T value,
    required List<T> items,
    required String Function(T) displayText,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          borderRadius: BorderRadius.circular(8),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: colorScheme.onSurfaceVariant,
          ),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                displayText(item),
                style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
    ColorScheme colorScheme,
    DateTime date,
    ValueChanged<DateTime> onChanged,
  ) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          onChanged(picked);
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
              Icons.calendar_today_outlined,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Text(
              _formatDateTime(date),
              style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
  }

  Widget _buildOrderNoField(BuildContext context, ColorScheme colorScheme) {
    return TextField(
      onChanged: onOrderNoChanged,
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
    );
  }

  Widget _buildActionButtons(BuildContext context, ColorScheme colorScheme) {
    return Row(
      children: [
        // Apply button
        ElevatedButton(
          onPressed: onApply,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('Apply'),
        ),
        const SizedBox(width: 12),
        // Show All button
        OutlinedButton(
          onPressed: onShowAll,
          style: OutlinedButton.styleFrom(
            foregroundColor: colorScheme.onSurface,
            side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('Show All'),
        ),
      ],
    );
  }
}

/// Searchable dropdown widget
class _SearchableDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedItem;
  final String Function(T) displayText;
  final String searchHint;
  final ValueChanged<T?> onChanged;
  final ColorScheme colorScheme;

  const _SearchableDropdown({
    required this.items,
    required this.selectedItem,
    required this.displayText,
    required this.searchHint,
    required this.onChanged,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showSearchableBottomSheet(context),
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
                selectedItem != null ? displayText(selectedItem as T) : '',
                style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
                overflow: TextOverflow.ellipsis,
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

  void _showSearchableBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return _SearchableBottomSheet<T>(
          items: items,
          selectedItem: selectedItem,
          displayText: displayText,
          searchHint: searchHint,
          onChanged: onChanged,
          colorScheme: colorScheme,
        );
      },
    );
  }
}

class _SearchableBottomSheet<T> extends StatefulWidget {
  final List<T> items;
  final T? selectedItem;
  final String Function(T) displayText;
  final String searchHint;
  final ValueChanged<T?> onChanged;
  final ColorScheme colorScheme;

  const _SearchableBottomSheet({
    required this.items,
    required this.selectedItem,
    required this.displayText,
    required this.searchHint,
    required this.onChanged,
    required this.colorScheme,
  });

  @override
  State<_SearchableBottomSheet<T>> createState() =>
      _SearchableBottomSheetState<T>();
}

class _SearchableBottomSheetState<T> extends State<_SearchableBottomSheet<T>> {
  late TextEditingController _searchController;
  late List<T> _filteredItems;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredItems = widget.items;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items.where((item) {
          return widget
              .displayText(item)
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Search field
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: _filterItems,
                decoration: InputDecoration(
                  hintText: widget.searchHint,
                  prefixIcon: Icon(
                    Icons.search,
                    color: widget.colorScheme.onSurfaceVariant,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: widget.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: widget.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: widget.colorScheme.primary),
                  ),
                ),
              ),
            ),
            // Items list
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: _filteredItems.length + 1, // +1 for "All" option
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // "All" option
                    return ListTile(
                      title: Text(
                        'All',
                        style: TextStyle(color: widget.colorScheme.onSurface),
                      ),
                      trailing: widget.selectedItem == null
                          ? Icon(Icons.check, color: widget.colorScheme.primary)
                          : null,
                      onTap: () {
                        widget.onChanged(null);
                        Navigator.pop(context);
                      },
                    );
                  }

                  final item = _filteredItems[index - 1];
                  final isSelected = widget.selectedItem == item;

                  return ListTile(
                    title: Text(
                      widget.displayText(item),
                      style: TextStyle(color: widget.colorScheme.onSurface),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check, color: widget.colorScheme.primary)
                        : null,
                    onTap: () {
                      widget.onChanged(item);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
