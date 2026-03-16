import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/common/common_scaffold.dart';
import '../../model/sales_report_model.dart';
import '../../model/online_order_model.dart';
import '../../../dashboard/view/widgets/chat_support_button.dart';

class SalesReportDetailPage extends StatefulWidget {
  final String reportTitle;

  const SalesReportDetailPage({super.key, required this.reportTitle});

  @override
  State<SalesReportDetailPage> createState() => _SalesReportDetailPageState();
}

class _SalesReportDetailPageState extends State<SalesReportDetailPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return CommonScaffold(
      activeItemId: 'reports',
      selectedOutlet: 'All Outlets',
      availableOutlets: const ['All Outlets'],
      onOutletSelected: (_) {},
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
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Text(
                          'Showing 1 to 2 of 2 entries',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
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
          'Order Date and Time',
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        // Start date field
        _buildDateField(colorScheme, DateTime.now(), (_) {}),
        const SizedBox(height: 12),
        // End date field
        _buildDateField(colorScheme, DateTime.now(), (_) {}),
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
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
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
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (pickedDate == null) return;
        if (!mounted) return;
        final pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(date),
        );
        if (!mounted) return;
        final hour = pickedTime?.hour ?? date.hour;
        final minute = pickedTime?.minute ?? date.minute;
        final newDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          hour,
          minute,
        );
        onDateSelected(newDateTime);
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
              DateFormat('yyyy-MM-dd  HH:mm').format(date),
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
          value: OrderStatus.all,
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
          onChanged: (_) {},
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
                'All Outlets',
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
                        'Select Store',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Divider(height: 1),
                    // Items list
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          const outletName = 'All Outlets';
                          return ListTile(
                            title: const Text(outletName),
                            trailing: Icon(
                              Icons.check,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onTap: () {
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
          },
        );
      },
    );
  }

  Widget _buildActionButtons(ColorScheme colorScheme) {
    return Row(
      children: [
        // Columns dropdown
        PopupMenuButton<String>(
          offset: const Offset(10, 50),
          icon: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.view_column, color: colorScheme.onPrimary, size: 20),
                const SizedBox(width: 8),
                Text('Columns', style: TextStyle(color: colorScheme.onPrimary)),
              ],
            ),
          ),
          itemBuilder: (context) {
            return [
              PopupMenuItem<String>(
                enabled: true,
                padding: EdgeInsets.zero,
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 300),
                  width: 160,
                  child: const SizedBox.shrink(),
                ),
              ),
            ];
          },
        ),
        const Spacer(),
        // Excel button
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text('Excel'),
        ),
        const SizedBox(width: 12),
        // Print button
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            backgroundColor: colorScheme.secondary,
            foregroundColor: colorScheme.onPrimary,
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
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
                  _buildHeaderCell('Restaurants', 150),
                  ..._buildDynamicHeaders(),
                ],
              ),
            ),
            // Summary rows
            // (no summary data in stub mode)
            // Data rows
            ...const <SalesReportData>[].map(
              (data) => _buildDataRow(data, colorScheme, textTheme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text, double width) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        textAlign: TextAlign.center,
      ),
    );
  }

  List<Widget> _buildDynamicHeaders() {
    final headers = <Widget>[];
    final columnData = [
      ('invoice_nos', 'Invoice Nos.', 120.0),
      ('total_bills', 'Total no. of bills', 120.0),
      ('my_amount', 'My Amount', 120.0),
      ('total_discount', 'Total Discount', 120.0),
      ('net_sales', 'Net Sales\n(M.A - T.D)', 120.0),
      ('delivery_charge', 'Delivery Charge', 120.0),
      ('container_charge', 'Container Charge', 120.0),
      ('service_charge', 'Service Charge', 120.0),
      ('additional_charge', 'Additional Charge', 120.0),
      ('total_tax', 'Total Tax', 120.0),
      ('round_off', 'Round Off', 100.0),
      ('waived_off', 'Waived off', 100.0),
      ('total_sales', 'Total Sales', 120.0),
      ('online_tax', 'Online Tax Calculated', 150.0),
      ('gst_merchant', 'GST Paid by Merchant', 150.0),
      ('gst_ecommerce', 'GST Paid by Ecommerce', 160.0),
      ('cash', 'Cash', 100.0),
      ('card', 'Card', 100.0),
      ('due_payment', 'Due Payment', 120.0),
      ('other', 'Other', 100.0),
      ('wallet', 'Wallet', 100.0),
      ('online', 'Online', 100.0),
      ('pax', 'Pax', 80.0),
      ('data_synced', 'Data Synced', 150.0),
    ];

    for (final (_, name, width) in columnData) {
      headers.add(_buildHeaderCell(name, width));
    }

    return headers;
  }

  List<Widget> _buildDynamicDataCells(SalesReportData data) {
    final cells = <Widget>[];

    final cellData = [
      ('invoice_nos', '-', 120.0),
      ('total_bills', data.totalBills.toString(), 120.0),
      ('my_amount', '0.00', 120.0),
      ('total_discount', data.totalDiscount.toStringAsFixed(0), 120.0),
      ('net_sales', data.netSales.toStringAsFixed(2), 120.0),
      ('delivery_charge', '0', 120.0),
      ('container_charge', '0', 120.0),
      ('service_charge', '0', 120.0),
      ('additional_charge', '0', 120.0),
      ('total_tax', data.totalTax.toStringAsFixed(2), 120.0),
      ('round_off', '0.00', 100.0),
      ('waived_off', '0', 100.0),
      ('total_sales', data.totalSales.toStringAsFixed(0), 120.0),
      ('online_tax', '0', 150.0),
      ('gst_merchant', '0', 150.0),
      ('gst_ecommerce', '0', 160.0),
      ('cash', data.cash.toStringAsFixed(0), 100.0),
      ('card', data.card.toStringAsFixed(0), 100.0),
      ('due_payment', '0', 120.0),
      ('other', '0', 100.0),
      ('wallet', '0', 100.0),
      ('online', data.online.toStringAsFixed(0), 100.0),
      ('pax', '0', 80.0),
      ('data_synced', '', 150.0),
    ];

    for (final (_, value, width) in cellData) {
      cells.add(_buildCell(value, width));
    }

    return cells;
  }

  Widget _buildDataRow(
    SalesReportData data,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        border: Border(
          bottom: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
        ),
      ),
      child: Row(
        children: [
          _buildCell(data.storeName, 150),
          ..._buildDynamicDataCells(data),
        ],
      ),
    );
  }

  Widget _buildCell(
    String text,
    double width, {
    bool isBold = false,
    Color? textColor,
  }) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          color: textColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
