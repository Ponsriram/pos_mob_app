import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/common_scaffold.dart';
import '../../viewmodel/item_out_of_stock_viewmodel.dart';

/// Item Out-Of-Stock Tracking page
class ItemOutOfStockPage extends ConsumerStatefulWidget {
  const ItemOutOfStockPage({super.key});

  @override
  ConsumerState<ItemOutOfStockPage> createState() => _ItemOutOfStockPageState();
}

class _ItemOutOfStockPageState extends ConsumerState<ItemOutOfStockPage> {
  late final TextEditingController _itemNameController;

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final viewModel = ref.watch(itemOutOfStockViewModelProvider);
    final viewModelNotifier = ref.read(
      itemOutOfStockViewModelProvider.notifier,
    );

    return CommonScaffold(
      activeItemId: 'item_out_of_stock',
      selectedOutlet: viewModel.selectedOutlet,
      availableOutlets: viewModel.availableOutlets,
      onOutletSelected: viewModelNotifier.setSelectedOutlet,
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
                // Page title with refresh icon
                _buildPageTitle(colorScheme, textTheme),
                const SizedBox(height: 16),
                // Info box
                _buildInfoBox(colorScheme, textTheme),
                const SizedBox(height: 16),
                // Main tabs (Items / Addons)
                _buildMainTabs(colorScheme, textTheme),
                const SizedBox(height: 16),
                // Filters section
                _buildFiltersSection(colorScheme, textTheme),
                const SizedBox(height: 24),
                // Restaurant Wise section with checkbox and tabs
                _buildRestaurantWiseSection(colorScheme, textTheme),
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
            'Item out-of-stock tracking',
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
              'Item Out-Of-Stock Tracking',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          // Refresh icon
          GestureDetector(
            onTap: () {
              ref.read(itemOutOfStockViewModelProvider.notifier).refresh();
            },
            child: Container(
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
              'Empowering decision-makers with real-time insights, this dashboard displays currently out-of-stock items and add-ons in specific outlets, facilitating timely responses to maintain items availability.',
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

  Widget _buildMainTabs(ColorScheme colorScheme, TextTheme textTheme) {
    final viewModel = ref.watch(itemOutOfStockViewModelProvider);
    final viewModelNotifier = ref.read(
      itemOutOfStockViewModelProvider.notifier,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildMainTab(
            label: 'Items',
            isSelected: viewModel.selectedMainTabIndex == 0,
            colorScheme: colorScheme,
            textTheme: textTheme,
            onTap: () => viewModelNotifier.setSelectedMainTabIndex(0),
          ),
          const SizedBox(width: 24),
          _buildMainTab(
            label: 'Addons',
            isSelected: viewModel.selectedMainTabIndex == 1,
            colorScheme: colorScheme,
            textTheme: textTheme,
            onTap: () => viewModelNotifier.setSelectedMainTabIndex(1),
          ),
        ],
      ),
    );
  }

  Widget _buildMainTab({
    required String label,
    required bool isSelected,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? colorScheme.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: isSelected
                ? colorScheme.onSurface
                : colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildFiltersSection(ColorScheme colorScheme, TextTheme textTheme) {
    final viewModel = ref.watch(itemOutOfStockViewModelProvider);
    final viewModelNotifier = ref.read(
      itemOutOfStockViewModelProvider.notifier,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Choose restaurant
          _buildFilterDropdown(
            label: 'Choose restaurant',
            value: viewModel.selectedRestaurant,
            colorScheme: colorScheme,
            textTheme: textTheme,
            onTap: () {
              _showDropdownDialog(
                title: 'Choose restaurant',
                options: viewModel.restaurants,
                currentValue: viewModel.selectedRestaurant,
                onSelected: viewModelNotifier.setSelectedRestaurant,
              );
            },
          ),
          const SizedBox(height: 16),
          // Category Name
          _buildFilterDropdown(
            label: 'Category Name',
            value: viewModel.selectedCategory,
            colorScheme: colorScheme,
            textTheme: textTheme,
            onTap: () {
              _showDropdownDialog(
                title: 'Category Name',
                options: viewModel.categories,
                currentValue: viewModel.selectedCategory,
                onSelected: viewModelNotifier.setSelectedCategory,
              );
            },
          ),
          const SizedBox(height: 16),
          // Item Name (Text Field)
          _buildTextFieldFilter(
            label: 'Item Name',
            controller: _itemNameController,
            colorScheme: colorScheme,
            textTheme: textTheme,
            onChanged: viewModelNotifier.setItemName,
          ),
          const SizedBox(height: 16),
          // Brand Name
          _buildFilterDropdown(
            label: 'Brand Name',
            value: viewModel.selectedBrand,
            colorScheme: colorScheme,
            textTheme: textTheme,
            onTap: () {
              _showDropdownDialog(
                title: 'Brand Name',
                options: viewModel.brands,
                currentValue: viewModel.selectedBrand,
                onSelected: viewModelNotifier.setSelectedBrand,
              );
            },
          ),
          const SizedBox(height: 16),
          // Item(s) Off for more than
          _buildFilterDropdown(
            label: 'Item(s) Off for more than',
            value: viewModel.selectedOffDuration,
            colorScheme: colorScheme,
            textTheme: textTheme,
            onTap: () {
              _showDropdownDialog(
                title: 'Item(s) Off for more than',
                options: viewModel.offDurationOptions,
                currentValue: viewModel.selectedOffDuration,
                onSelected: viewModelNotifier.setSelectedOffDuration,
              );
            },
          ),
          const SizedBox(height: 24),
          // Action buttons
          Row(
            children: [
              // Search button
              ElevatedButton(
                onPressed: () {
                  viewModelNotifier.search();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
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
              const SizedBox(width: 12),
              // Reset button
              OutlinedButton(
                onPressed: () {
                  viewModelNotifier.resetFilters();
                  _itemNameController.clear();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.onSurface,
                  side: BorderSide(
                    color: colorScheme.outline.withValues(alpha: 0.5),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
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
              const SizedBox(width: 12),
              // Export button
              OutlinedButton(
                onPressed: () {
                  viewModelNotifier.exportData();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  side: BorderSide(color: colorScheme.primary),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
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

  Widget _buildTextFieldFilter({
    required String label,
    required TextEditingController controller,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required ValueChanged<String> onChanged,
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
        TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: '',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
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
            filled: true,
            fillColor: colorScheme.surface,
          ),
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
        ),
      ],
    );
  }

  Widget _buildRestaurantWiseSection(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final viewModel = ref.watch(itemOutOfStockViewModelProvider);
    final viewModelNotifier = ref.read(
      itemOutOfStockViewModelProvider.notifier,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Restaurant Wise',
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          // Checkbox and toggle row
          Row(
            children: [
              // Checkbox
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    viewModelNotifier
                        .toggleShowRestaurantsWithAllItemsInStock();
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: viewModel.showRestaurantsWithAllItemsInStock
                                ? colorScheme.primary
                                : colorScheme.outline.withValues(alpha: 0.5),
                            width: viewModel.showRestaurantsWithAllItemsInStock
                                ? 2
                                : 1,
                          ),
                          color: viewModel.showRestaurantsWithAllItemsInStock
                              ? colorScheme.primary
                              : Colors.transparent,
                        ),
                        child: viewModel.showRestaurantsWithAllItemsInStock
                            ? Icon(
                                Icons.check,
                                size: 14,
                                color: colorScheme.onPrimary,
                              )
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Show restaurant(s) with all items in stock',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Toggle tabs
              _buildViewToggle(colorScheme, textTheme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggle(ColorScheme colorScheme, TextTheme textTheme) {
    final viewModel = ref.watch(itemOutOfStockViewModelProvider);
    final viewModelNotifier = ref.read(
      itemOutOfStockViewModelProvider.notifier,
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildViewToggleItem(
            label: 'Restaurant Wise',
            isSelected: viewModel.selectedViewTabIndex == 0,
            colorScheme: colorScheme,
            textTheme: textTheme,
            onTap: () => viewModelNotifier.setSelectedViewTabIndex(0),
          ),
          _buildViewToggleItem(
            label: 'Item Wise',
            isSelected: viewModel.selectedViewTabIndex == 1,
            colorScheme: colorScheme,
            textTheme: textTheme,
            onTap: () => viewModelNotifier.setSelectedViewTabIndex(1),
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggleItem({
    required String label,
    required bool isSelected,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
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
              'No Items Found With Offline Status',
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

  void _showDropdownDialog({
    required String title,
    required List<String> options,
    required String currentValue,
    required ValueChanged<String> onSelected,
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
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Title
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Divider(height: 1),
              // Options
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final isSelected = option == currentValue;
                    return ListTile(
                      title: Text(
                        option,
                        style: textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check, color: colorScheme.primary)
                          : null,
                      onTap: () {
                        onSelected(option);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
