import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/widgets/common_scaffold.dart';
import '../../viewmodel/sales_report_viewmodel.dart';
import '../../model/sales_report_model.dart';
import '../../../dashboard/view/widgets/chat_support_button.dart';

class SalesReportDetailPage extends StatefulWidget {
  final String reportTitle;

  const SalesReportDetailPage({super.key, required this.reportTitle});

  @override
  State<SalesReportDetailPage> createState() => _SalesReportDetailPageState();
}

class _SalesReportDetailPageState extends State<SalesReportDetailPage> {
  late final SalesReportViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SalesReportViewModel();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return CommonScaffold(
          activeItemId: 'reports',
          selectedOutlet: _viewModel.selectedOutlet,
          availableOutlets: _viewModel.availableOutlets,
          onOutletSelected: _viewModel.setSelectedOutlet,
          onLightBulbTap: () {},
          backgroundColor: colorScheme.surface,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and back button
              _buildHeader(colorScheme, textTheme),
              // Main content
              Expanded(
                child: Container(
                  color: colorScheme.surfaceContainerLowest,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Time Wise button
                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: const Text('Time Wise'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Filters section
                        _buildFiltersSection(colorScheme, textTheme),
                        const SizedBox(height: 24),
                        // Action buttons
                        _buildActionButtons(colorScheme),
                        const SizedBox(height: 16),
                        // Data table
                        _buildDataTable(colorScheme, textTheme),
                        const SizedBox(height: 16),
                        // Showing entries text
                        Text(
                          'Showing 1 to 2 of 2 entries',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
              widget.reportTitle,
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

  Widget _buildFiltersSection(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Order Date label
        Text(
          'Order Date',
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        // Start date field
        _buildDateField(
          colorScheme,
          _viewModel.startDate,
          (date) => _viewModel.setStartDate(date),
        ),
        const SizedBox(height: 12),
        // End date field
        _buildDateField(
          colorScheme,
          _viewModel.endDate,
          (date) => _viewModel.setEndDate(date),
        ),
        const SizedBox(height: 16),
        // Order Status
        Text(
          'Order Status',
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        _buildOrderStatusDropdown(colorScheme),
        const SizedBox(height: 16),
        // Restaurants
        Text(
          'Restaurants',
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        _buildRestaurantDropdown(colorScheme),
        const SizedBox(height: 16),
        // Search button
        SizedBox(
          width: 120,
          child: ElevatedButton(
            onPressed: _viewModel.search,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Search'),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(
    ColorScheme colorScheme,
    DateTime date,
    Function(DateTime) onDateSelected,
  ) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          onDateSelected(picked);
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
              DateFormat('yyyy-MM-dd').format(date),
              style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatusDropdown(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<OrderStatus>(
          value: _viewModel.selectedOrderStatus,
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          borderRadius: BorderRadius.circular(8),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: colorScheme.onSurfaceVariant,
          ),
          items: OrderStatus.values.map((status) {
            return DropdownMenuItem<OrderStatus>(
              value: status,
              child: Text(
                status.displayName,
                style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              _viewModel.setOrderStatus(value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildRestaurantDropdown(ColorScheme colorScheme) {
    return GestureDetector(
      onTap: () => _showRestaurantBottomSheet(colorScheme),
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
                _viewModel.selectedRestaurantsText,
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

  void _showRestaurantBottomSheet(ColorScheme colorScheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Select Restaurants',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Divider(height: 1),
                    // Items list with checkboxes
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: _viewModel.restaurants.length,
                        itemBuilder: (context, index) {
                          final restaurant = _viewModel.restaurants[index];
                          return CheckboxListTile(
                            title: Text(restaurant.name),
                            value: restaurant.isSelected,
                            onChanged: (value) {
                              _viewModel.toggleRestaurant(restaurant.id);
                              setState(() {});
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildActionButtons(ColorScheme colorScheme) {
    return Row(
      children: [
        // Columns dropdown
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.view_column),
          label: const Text('Columns'),
          style: OutlinedButton.styleFrom(
            backgroundColor: colorScheme.error,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const Spacer(),
        // Excel button
        OutlinedButton(
          onPressed: _viewModel.exportToExcel,
          style: OutlinedButton.styleFrom(
            backgroundColor: colorScheme.error,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text('Excel'),
        ),
        const SizedBox(width: 12),
        // Print button
        OutlinedButton(
          onPressed: _viewModel.printReport,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.grey.shade600,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text('Print'),
        ),
      ],
    );
  }

  Widget _buildDataTable(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Restaurants',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Invoice Nos.',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Total no. of bills',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          // Summary rows
          if (_viewModel.summary != null) ...[
            _buildSummaryRow('Total', _viewModel.summary!.total, colorScheme),
            _buildSummaryRow('Min.', _viewModel.summary!.min, colorScheme),
            _buildSummaryRow('Max.', _viewModel.summary!.max, colorScheme),
            _buildSummaryRow('Avg.', _viewModel.summary!.avg, colorScheme),
          ],
          // Data rows
          ..._viewModel.salesData.map(
            (data) => _buildDataRow(
              data.restaurantName,
              data.invoiceNumbers,
              data.totalBills.toString(),
              colorScheme,
              textTheme,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, int value, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.yellow.shade50,
        border: Border(
          bottom: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const Expanded(flex: 2, child: SizedBox()),
          Expanded(
            flex: 2,
            child: Text(
              value.toString(),
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(
    String restaurant,
    String invoiceNos,
    String bills,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(restaurant, style: textTheme.bodyMedium),
          ),
          Expanded(
            flex: 2,
            child: Text(invoiceNos, style: textTheme.bodyMedium),
          ),
          Expanded(
            flex: 2,
            child: Text(
              bills,
              textAlign: TextAlign.right,
              style: textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
