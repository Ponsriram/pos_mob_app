import 'package:flutter/material.dart';
import '../../../../core/common/common_scaffold.dart';
import '../../../dashboard/view/widgets/chat_support_button.dart';

/// Delete Outlet page
class DeleteOutletPage extends StatefulWidget {
  const DeleteOutletPage({super.key});

  @override
  State<DeleteOutletPage> createState() => _DeleteOutletPageState();
}

class _DeleteOutletPageState extends State<DeleteOutletPage> {
  String _selectedOutlet = 'Main Outlet';
  String _selectedOutletToDelete = 'Main Outlet';

  final List<String> _availableOutlets = [
    'Main Outlet',
    'Branch Outlet',
    'Downtown Store',
  ];

  void _setSelectedOutlet(String outlet) {
    setState(() {
      _selectedOutlet = outlet;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CommonScaffold(
      activeItemId: 'delete_outlet',
      selectedOutlet: _selectedOutlet,
      availableOutlets: _availableOutlets,
      onOutletSelected: _setSelectedOutlet,
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
        // Header with title and back button
        _buildHeader(colorScheme, textTheme),
        // Main content
        Expanded(
          child: Container(
            color: colorScheme.surfaceContainerLowest,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info card
                    _buildInfoCard(colorScheme, textTheme),
                    const SizedBox(height: 24),
                    // Outlet selection dropdown
                    _buildOutletDropdown(colorScheme, textTheme),
                    const SizedBox(height: 32),
                    // Delete button
                    _buildDeleteButton(colorScheme, textTheme),
                  ],
                ),
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
            'Delete Outlet',
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

  Widget _buildInfoCard(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: colorScheme.error, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Warning',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Deleting an outlet will permanently remove all associated data including orders, products, and reports. This action cannot be undone.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutletDropdown(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Outlet to Delete',
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedOutletToDelete,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: colorScheme.onSurfaceVariant,
              ),
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
              items: _availableOutlets
                  .map(
                    (outlet) =>
                        DropdownMenuItem(value: outlet, child: Text(outlet)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedOutletToDelete = value;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteButton(ColorScheme colorScheme, TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _showDeleteConfirmationDialog(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.error,
          foregroundColor: colorScheme.onError,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Text(
          'Delete Outlet',
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onError,
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Confirm Deletion',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this outlet? This action cannot be undone and all data will be permanently lost.',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: textTheme.labelLarge?.copyWith(color: colorScheme.primary),
            ),
          ),
          FilledButton(
            onPressed: () {
              // Handle delete action
              Navigator.pop(context);
              _showSuccessSnackBar(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            child: Text(
              'Delete',
              style: textTheme.labelLarge?.copyWith(color: colorScheme.onError),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Outlet deleted successfully'),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
