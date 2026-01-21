import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pos_app/core/providers/repository_providers.dart';
import 'package:pos_app/core/repositories/store_repository.dart';
import '../model/sales_report_model.dart';

part 'sales_report_viewmodel.g.dart';

/// State for the Sales Report Detail screen
class SalesReportState {
  final String? selectedStoreId;
  final DateTime startDate;
  final DateTime endDate;
  final OrderStatus selectedOrderStatus;
  final List<RestaurantFilter> restaurants;
  final List<RestaurantSalesData> salesData;
  final SalesReportSummary? summary;
  final bool isLoading;
  final List<ColumnOption> columns;
  final List<StoreModel> stores;
  final String? error;

  SalesReportState({
    this.selectedStoreId,
    DateTime? startDate,
    DateTime? endDate,
    this.selectedOrderStatus = OrderStatus.success,
    this.restaurants = const [],
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
    List<RestaurantFilter>? restaurants,
    List<RestaurantSalesData>? salesData,
    SalesReportSummary? summary,
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
      restaurants: restaurants ?? this.restaurants,
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
    final selected = restaurants.where((r) => r.isSelected).toList();
    if (selected.isEmpty) {
      return 'Choose Restaurant';
    } else if (selected.length == 1) {
      return selected.first.name;
    } else {
      return '${selected.length} restaurants selected';
    }
  }
}

/// ViewModel for the Sales Report Detail screen using Riverpod
@riverpod
class SalesReportViewModel extends _$SalesReportViewModel {
  late StoreRepository _storeRepo;

  @override
  SalesReportState build() {
    _storeRepo = ref.watch(storeRepositoryProvider);

    _loadInitialData();

    return SalesReportState(
      restaurants: RestaurantFilter.getDefaultRestaurants(),
      columns: ColumnOption.getDefaultColumns(),
    );
  }

  Future<void> _loadInitialData() async {
    final storesResult = await _storeRepo.getAccessibleStores();
    storesResult.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (stores) => state = state.copyWith(stores: stores),
    );

    _loadSampleData();
  }

  void setSelectedOutlet(String outletName) {
    if (outletName == 'All Outlets') {
      state = state.copyWith(selectedStoreId: null);
    } else {
      final store = state.stores.where((s) => s.name == outletName).firstOrNull;
      state = state.copyWith(selectedStoreId: store?.id);
    }
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

  void toggleRestaurant(String restaurantId) {
    final updatedRestaurants = state.restaurants.map((r) {
      if (r.id == restaurantId) {
        return r.copyWith(isSelected: !r.isSelected);
      }
      return r;
    }).toList();
    state = state.copyWith(restaurants: updatedRestaurants);
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

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    _loadSampleData();
    state = state.copyWith(isLoading: false);
  }

  void _loadSampleData() {
    final salesData = [
      const RestaurantSalesData(
        restaurantName: 'Aarthi cake Magic',
        invoiceNumbers: '211-212',
        totalBills: 2,
        myAmount: 11456.11,
        totalDiscount: 0,
        netSales: 11456.11,
        deliveryCharge: 0,
        containerCharge: 0,
        serviceCharge: 0,
        additionalCharge: 0,
        totalTax: 572.82,
        roundOff: 0.07,
        waivedOff: 0,
        totalSales: 12029,
        onlineTaxCalculated: 0,
        gstPaidByMerchant: 0,
        gstPaidByEcommerce: 0,
        cash: 12029,
        card: 0,
        duePayment: 0,
        other: 0,
        wallet: 0,
        online: 0,
        pax: 0,
        dataSynced: '2026-01-02 17:28:24',
      ),
      const RestaurantSalesData(
        restaurantName: 'Ambattur Aarthi sweets and bakery',
        invoiceNumbers: '6435-6518',
        totalBills: 84,
        myAmount: 11456.11,
        totalDiscount: 0,
        netSales: 11456.11,
        deliveryCharge: 0,
        containerCharge: 0,
        serviceCharge: 0,
        additionalCharge: 0,
        totalTax: 572.82,
        roundOff: 0.07,
        waivedOff: 0,
        totalSales: 12029,
        onlineTaxCalculated: 0,
        gstPaidByMerchant: 0,
        gstPaidByEcommerce: 0,
        cash: 12029,
        card: 0,
        duePayment: 0,
        other: 0,
        wallet: 0,
        online: 0,
        pax: 0,
        dataSynced: '2026-01-02 17:28:24',
      ),
    ];

    const summary = SalesReportSummary(
      total: 86,
      min: 2,
      max: 84,
      avg: 43,
      myAmount: 11456.11,
      totalDiscount: 0.00,
      netSales: 11456.11,
      deliveryCharge: 0.00,
      containerCharge: 0.00,
      serviceCharge: 0.00,
      additionalCharge: 0.00,
      totalTax: 572.82,
      roundOff: 0.07,
      waivedOff: 0.00,
      totalSales: 12029.00,
      onlineTaxCalculated: 0.00,
      gstPaidByMerchant: 0.00,
      gstPaidByEcommerce: 0.00,
      cash: 12029.00,
      card: 0.00,
      duePayment: 0.00,
      other: 0.00,
      wallet: 0.00,
      online: 0.00,
      pax: 0,
    );

    state = state.copyWith(salesData: salesData, summary: summary);
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
