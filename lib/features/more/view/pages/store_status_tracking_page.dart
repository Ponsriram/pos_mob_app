import 'package:flutter/material.dart';
import '../../../../core/widgets/common_scaffold.dart';

/// Store Status Tracking Dashboard page
class StoreStatusTrackingPage extends StatefulWidget {
  const StoreStatusTrackingPage({super.key});

  @override
  State<StoreStatusTrackingPage> createState() =>
      _StoreStatusTrackingPageState();
}

class _StoreStatusTrackingPageState extends State<StoreStatusTrackingPage> {
  String _selectedOutlet = 'All Outlets';
  final List<String> _availableOutlets = [
    'All Outlets',
    'Aarthi cake Magic',
    'Ambattur Aarthi sweets and bakery',
  ];

  // Filter state
  String _selectedRestaurant = 'All';
  String _selectedAggregator = 'Select';
  String _selectedBrand = 'All';
  String _selectedOfflineDuration = 'Select';
  int _selectedTabIndex = 0; // 0 for Restaurant Wise, 1 for Aggregator

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CommonScaffold(
      activeItemId: 'store_status',
      selectedOutlet: _selectedOutlet,
      availableOutlets: _availableOutlets,
      onOutletSelected: (outlet) {
        setState(() {
          _selectedOutlet = outlet;
        });
      },
      onLightBulbTap: () {},
      backgroundColor: colorScheme.surface,
      body: _buildBody(),
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
                // Page title with icons
                _buildPageTitle(colorScheme, textTheme),
                const SizedBox(height: 16),
                // Info box
                _buildInfoBox(colorScheme, textTheme),
                const SizedBox(height: 24),
                // Filters section
                _buildFiltersSection(colorScheme, textTheme),
                const SizedBox(height: 24),
                // Tab section
                _buildTabSection(colorScheme, textTheme),
                const SizedBox(height: 32),
                // Empty state
                _buildEmptyState(colorScheme, textTheme),
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
            'Store status tracking dashboard',
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

  Widget _buildPageTitle(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Store Status Tracking Dashboard',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          // Refresh icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.refresh,
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          // History/Clock icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.history,
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: colorScheme.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'This module displays a real-time status of store connectivity, identifying currently offline locations and brands so that decision-makers can take necessary actions.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onPrimaryContainer,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Choose restaurant
          _buildFilterDropdown(
            label: 'Choose restaurant',
            value: _selectedRestaurant,
            colorScheme: colorScheme,
            textTheme: textTheme,
            onTap: () {
              // Handle dropdown tap
            },
          ),
          const SizedBox(height: 16),
          // Aggregator
          _buildFilterDropdown(
            label: 'Aggregator',
            value: _selectedAggregator,
            colorScheme: colorScheme,
            textTheme: textTheme,
            onTap: () {
              // Handle dropdown tap
            },
          ),
          const SizedBox(height: 16),
          // Brand Name
          _buildFilterDropdown(
            label: 'Brand Name',
            value: _selectedBrand,
            colorScheme: colorScheme,
            textTheme: textTheme,
            onTap: () {
              // Handle dropdown tap
            },
          ),
          const SizedBox(height: 16),
          // Store(s) Off for more than
          _buildFilterDropdown(
            label: 'Store(s) Off for more than',
            value: _selectedOfflineDuration,
            colorScheme: colorScheme,
            textTheme: textTheme,
            onTap: () {
              // Handle dropdown tap
            },
          ),
          const SizedBox(height: 24),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle search
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
                    'Search',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Handle reset
                    setState(() {
                      _selectedRestaurant = 'All';
                      _selectedAggregator = 'Select';
                      _selectedBrand = 'All';
                      _selectedOfflineDuration = 'Select';
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.onSurface,
                    side: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.5),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Reset',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Handle export
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                    side: BorderSide(color: colorScheme.primary),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Export',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String value,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.circular(8),
              color: colorScheme.surface,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: textTheme.bodyMedium?.copyWith(
                    color: value == 'Select'
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.onSurface,
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
        ),
      ],
    );
  }

  Widget _buildTabSection(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTabIndex = 0;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedTabIndex == 0
                      ? colorScheme.primaryContainer
                      : Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color: _selectedTabIndex == 0
                          ? colorScheme.primary
                          : colorScheme.outline.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  'Restaurant Wise',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: _selectedTabIndex == 0
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurfaceVariant,
                    fontWeight: _selectedTabIndex == 0
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTabIndex = 1;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedTabIndex == 1
                      ? colorScheme.primaryContainer
                      : Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color: _selectedTabIndex == 1
                          ? colorScheme.primary
                          : colorScheme.outline.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  'Aggregator',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: _selectedTabIndex == 1
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurfaceVariant,
                    fontWeight: _selectedTabIndex == 1
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success checkmark icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.surface,
                border: Border.all(color: colorScheme.primary, width: 3),
              ),
              child: Icon(Icons.check, size: 48, color: colorScheme.primary),
            ),
            const SizedBox(height: 24),
            Text(
              'No Stores Found With Offline Status',
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
