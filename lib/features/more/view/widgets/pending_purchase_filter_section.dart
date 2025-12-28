import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Filter section widget for Pending Purchase page
class PendingPurchaseFilterSection extends StatelessWidget {
  final List<String> restaurants;
  final String selectedRestaurant;
  final DateTime startDate;
  final DateTime endDate;
  final ValueChanged<String> onRestaurantChanged;
  final ValueChanged<DateTime> onStartDateChanged;
  final ValueChanged<DateTime> onEndDateChanged;
  final VoidCallback onSearch;
  final VoidCallback onShowAll;

  const PendingPurchaseFilterSection({
    super.key,
    required this.restaurants,
    required this.selectedRestaurant,
    required this.startDate,
    required this.endDate,
    required this.onRestaurantChanged,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onSearch,
    required this.onShowAll,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant / Kitchen dropdown
          Text(
            'Restaurant / Kitchen',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          _buildDropdownField(
            context: context,
            value: selectedRestaurant,
            onTap: () => _showRestaurantPicker(context),
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 16),
          // Start Date
          Text(
            'Start Date',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          _buildDateField(
            context: context,
            date: startDate,
            onTap: () => _selectDate(context, isStartDate: true),
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 16),
          // End Date
          Text(
            'End Date',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          _buildDateField(
            context: context,
            date: endDate,
            onTap: () => _selectDate(context, isStartDate: false),
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 16),
          // Buttons row
          Row(
            children: [
              // Search button
              ElevatedButton(
                onPressed: onSearch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Search'),
              ),
              const SizedBox(width: 12),
              // Show All button
              OutlinedButton(
                onPressed: onShowAll,
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.onSurface,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  side: BorderSide(
                    color: colorScheme.outline.withValues(alpha: 0.5),
                  ),
                ),
                child: const Text('Show All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required BuildContext context,
    required String value,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required BuildContext context,
    required DateTime date,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    final dateFormat = DateFormat('dd MMM yyyy');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              color: colorScheme.onSurfaceVariant,
              size: 18,
            ),
            const SizedBox(width: 12),
            Text(
              dateFormat.format(date),
              style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
            ),
          ],
        ),
      ),
    );
  }

  void _showRestaurantPicker(BuildContext context) {
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
            children: restaurants.map((restaurant) {
              final isSelected = restaurant == selectedRestaurant;
              return ListTile(
                title: Text(restaurant),
                leading: Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: isSelected ? colorScheme.primary : colorScheme.outline,
                ),
                onTap: () {
                  onRestaurantChanged(restaurant);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(
    BuildContext context, {
    required bool isStartDate,
  }) async {
    final colorScheme = Theme.of(context).colorScheme;
    final initialDate = isStartDate ? startDate : endDate;
    final firstDate = DateTime(2020);
    final lastDate = DateTime(2030);

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(colorScheme: colorScheme),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      if (isStartDate) {
        onStartDateChanged(selectedDate);
      } else {
        onEndDateChanged(selectedDate);
      }
    }
  }
}
