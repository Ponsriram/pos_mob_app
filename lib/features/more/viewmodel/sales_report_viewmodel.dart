import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pos_app/core/providers/repository_providers.dart';
import 'package:pos_app/core/providers/store_provider.dart';
import 'package:pos_app/core/repositories/store_repository.dart';
import 'package:pos_app/core/repositories/sales_report_repository.dart';
import '../model/sales_report_model.dart';

part 'sales_report_viewmodel.g.dart';

/// State for the Sales Report Detail screen
class SalesReportState {
  final String? selectedStoreId;
  final DateTime startDate;
  final DateTime endDate;
  final OrderStatus selectedOrderStatus;
  final List<SalesReportData> salesData;
  final SalesReportSummaryData? summary;
  final bool isLoading;
  final List<ColumnOption> columns;
  final List<StoreModel> stores;
  final String? error;

  SalesReportState({
    this.selectedStoreId,
    DateTime? startDate,
    DateTime? endDate,
    this.selectedOrderStatus = OrderStatus.success,
    this.salesData = const [],
    this.summary,
    this.isLoading = false,
    this.columns = const [],
    this.stores = const [],
    this.error,
  }) : startDate = startDate ?? DateTime.now(),
       endDate = endDate ?? DateTime.now();

  SalesReportState copyWith({
    String? selectedStoreId,
    DateTime? startDate,
    DateTime? endDate,
    OrderStatus? selectedOrderStatus,
    List<SalesReportData>? salesData,
    SalesReportSummaryData? summary,
    bool? isLoading,
    List<ColumnOption>? columns,
    List<StoreModel>? stores,
    String? error,
  }) {
    return SalesReportState(
      selectedStoreId: selectedStoreId ?? this.selectedStoreId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      selectedOrderStatus: selectedOrderStatus ?? this.selectedOrderStatus,
      salesData: salesData ?? this.salesData,
      summary: summary ?? this.summary,
      isLoading: isLoading ?? this.isLoading,
      columns: columns ?? this.columns,
      stores: stores ?? this.stores,
      error: error,
    );
  }

  /// List of available outlets including "All Outlets"
  List<String> get availableOutlets => [
    'All Outlets',
    ...stores.map((s) => s.name),
  ];

  /// Get selected outlet name
  String get selectedOutletName {
    if (selectedStoreId == null) return 'All Outlets';
    final store = stores.where((s) => s.id == selectedStoreId).firstOrNull;
    return store?.name ?? 'All Outlets';
  }

  /// Alias for selectedOutletName
  String get selectedOutlet => selectedOutletName;

  /// Get selected restaurant names text
  String get selectedRestaurantsText {
    if (stores.isEmpty) return 'No stores available';
    if (selectedStoreId == null) return 'All Outlets';
    return selectedOutletName;
  }
}

/// ViewModel for the Sales Report Detail screen using Riverpod
@riverpod
class SalesReportViewModel extends _$SalesReportViewModel {
  late SalesReportRepository _salesReportRepo;

  @override
  SalesReportState build() {
    // Watch the global store state
    final storeState = ref.watch(globalStoreNotifierProvider);
    _salesReportRepo = ref.watch(salesReportRepositoryProvider);

    _loadInitialData(storeState);

    return SalesReportState(
      columns: ColumnOption.getDefaultColumns(),
      stores: storeState.stores,
      selectedStoreId: storeState.selectedStoreId,
    );
  }

  Future<void> _loadInitialData(StoreState storeState) async {
    if (storeState.isLoading) {
      state = state.copyWith(isLoading: true);
      return;
    }

    state = state.copyWith(
      isLoading: true,
      error: storeState.error,
      stores: storeState.stores,
      selectedStoreId: storeState.selectedStoreId,
    );

    // Load initial sales report
    await _loadSalesReport();

    state = state.copyWith(isLoading: false);
  }

  Future<void> _loadSalesReport() async {
    final storeId = state.selectedStoreId;
    if (storeId == null) {
      state = state.copyWith(error: 'Please select a store');
      return;
    }
    final storeName = state.selectedOutletName;

    final result = await _salesReportRepo.getSalesReport(
      startDate: state.startDate,
      endDate: state.endDate,
      storeId: storeId,
      storeName: storeName,
    );

    result.fold((failure) => state = state.copyWith(error: failure.message), (
      data,
    ) {
      final summary = SalesReportSummaryData.fromReportData(data);
      state = state.copyWith(salesData: data, summary: summary);
    });
  }

  void setSelectedOutlet(String outletName) {
    // Update the global store provider
    ref
        .read(globalStoreNotifierProvider.notifier)
        .setSelectedOutlet(outletName);
  }

  void setStartDate(DateTime date) {
    state = state.copyWith(startDate: date);
  }

  void setEndDate(DateTime date) {
    state = state.copyWith(endDate: date);
  }

  void setOrderStatus(OrderStatus status) {
    state = state.copyWith(selectedOrderStatus: status);
  }

  void toggleColumn(String columnId) {
    final updatedColumns = state.columns.map((c) {
      if (c.id == columnId) {
        return c.copyWith(isVisible: !c.isVisible);
      }
      return c;
    }).toList();
    state = state.copyWith(columns: updatedColumns);
  }

  Future<void> search() async {
    state = state.copyWith(isLoading: true, error: null);
    await _loadSalesReport();
    state = state.copyWith(isLoading: false);
  }

  void exportToExcel() {
    // TODO: Implement Excel export
    debugPrint('Exporting to Excel...');
  }

  void printReport() {
    // TODO: Implement print functionality
    debugPrint('Printing report...');
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
