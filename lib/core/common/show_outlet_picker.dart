import 'package:flutter/material.dart';

/// Shows a bottom sheet picker for selecting an outlet.
///
/// [context] - The build context
/// [availableOutlets] - List of outlet names to display
/// [selectedOutlet] - Currently selected outlet name
/// [onOutletSelected] - Callback when an outlet is selected
void showOutletPicker({
  required BuildContext context,
  required List<String> availableOutlets,
  required String selectedOutlet,
  required void Function(String outlet) onOutletSelected,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;
  showModalBottomSheet(
    context: context,
    backgroundColor: colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Select Outlet',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          const Divider(height: 1),
          ...List.generate(availableOutlets.length, (index) {
            final outlet = availableOutlets[index];
            final isSelected = outlet == selectedOutlet;
            return ListTile(
              onTap: () {
                onOutletSelected(outlet);
                Navigator.pop(context);
              },
              leading: Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              title: Text(
                outlet,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
        ],
      );
    },
  );
}
