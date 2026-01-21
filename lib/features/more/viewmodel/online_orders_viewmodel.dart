import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pos_app/core/providers/repository_providers.dart';
import 'package:pos_app/core/repositories/order_repository.dart'
    hide OrderStatus;
import 'package:pos_app/core/repositories/store_repository.dart';
import '../model/online_order_model.dart';

part 'online_orders_viewmodel.g.dart';

/// State for Online Orders Activity screen
class OnlineOrdersState {
  final String? selectedStoreId;
  final String selectedPlatformId;
  final RecordType selectedRecordType;
  final OrderStatus selectedStatus;
  final String orderNoFilter;
  final DateTime startDate;
  final DateTime endDate;
  final bool isChartExpanded;
  final bool isLoading;
  final List<OrderModel> orders;
  final List<StoreModel> stores;
  final List<OrderPlatformModel> platforms;
  final String? error;

  OnlineOrdersState({
    this.selectedStoreId,
    this.selectedPlatformId = 'all',
    this.selectedRecordType = RecordType.last2DaysRecords,
    this.selectedStatus = OrderStatus.all,
    this.orderNoFilter = '',
    DateTime? startDate,
    DateTime? endDate,
    this.isChartExpanded = false,
    this.isLoading = false,
    this.orders = const [],
    this.stores = const [],
    this.platforms = const [],
    this.error,
  }) : startDate =
           startDate ?? DateTime.now().subtract(const Duration(days: 1)),
       endDate = endDate ?? DateTime.now();

  OnlineOrdersState copyWith({
    String? selectedStoreId,
    String? selectedPlatformId,
    RecordType? selectedRecordType,
    OrderStatus? selectedStatus,
    String? orderNoFilter,
    DateTime? startDate,
    DateTime? endDate,
    bool? isChartExpanded,
    bool? isLoading,
    List<OrderModel>? orders,
    List<StoreModel>? stores,
    List<OrderPlatformModel>? platforms,
    String? error,
  }) {
    return OnlineOrdersState(
      selectedStoreId: selectedStoreId ?? this.selectedStoreId,
      selectedPlatformId: selectedPlatformId ?? this.selectedPlatformId,
      selectedRecordType: selectedRecordType ?? this.selectedRecordType,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      orderNoFilter: orderNoFilter ?? this.orderNoFilter,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isChartExpanded: isChartExpanded ?? this.isChartExpanded,
      isLoading: isLoading ?? this.isLoading,
      orders: orders ?? this.orders,
      stores: stores ?? this.stores,
      platforms: platforms ?? this.platforms,
      error: error,
    );
  }

  /// List of available outlets including "All Outlets"
  List<String> get availableOutlets => [
    'All Outlets',
    ...stores.map((s) => s.name),
  ];

  /// Selected outlet name for display
  String get selectedOutlet {
    if (selectedStoreId == null) return 'All Outlets';
    final store = stores.where((s) => s.id == selectedStoreId).firstOrNull;
    return store?.name ?? 'All Outlets';
  }

  /// Alias for selectedOutlet
  String get selectedRestaurant => selectedOutlet;

  /// Restaurant list for dropdowns
  List<String> get restaurants => availableOutlets;

  /// Get selected outlet name
  String get selectedOutletName {
    if (selectedStoreId == null) return 'All Outlets';
    final store = stores.where((s) => s.id == selectedStoreId).firstOrNull;
    return store?.name ?? 'All Outlets';
  }

  /// Check if date range fields should be shown
  bool get showDateRange => selectedRecordType == RecordType.getOldRecords;

  /// Get filtered orders count
  int get filteredOrdersCount => orders.length;
}

/// ViewModel for the Online Orders Activity screen using Riverpod
@riverpod
class OnlineOrdersViewModel extends _$OnlineOrdersViewModel {
  late OrderRepository _orderRepo;
  late StoreRepository _storeRepo;

  @override
  OnlineOrdersState build() {
    _orderRepo = ref.watch(orderRepositoryProvider);
    _storeRepo = ref.watch(storeRepositoryProvider);

    _loadInitialData();

    return OnlineOrdersState(
      platforms: OrderPlatformModel.getDefaultPlatforms(),
    );
  }

  Future<void> _loadInitialData() async {
    state = state.copyWith(isLoading: true, error: null);

    // Load stores
    final storesResult = await _storeRepo.getAccessibleStores();
    storesResult.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (stores) => state = state.copyWith(stores: stores),
    );

    // Load online orders
    await _loadOnlineOrders();

    state = state.copyWith(isLoading: false);
  }

  Future<void> _loadOnlineOrders() async {
    // Skip loading if no store selected yet
    final storeId = state.selectedStoreId;
    if (storeId == null) {
      state = state.copyWith(orders: []);
      return;
    }

    final result = await _orderRepo.getOnlineOrders(storeId: storeId);

    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (orders) => state = state.copyWith(orders: orders),
    );
  }

  void setSelectedOutlet(String outletName) {
    if (outletName == 'All Outlets') {
      state = state.copyWith(selectedStoreId: null);
    } else {
      final store = state.stores.where((s) => s.name == outletName).firstOrNull;
      state = state.copyWith(selectedStoreId: store?.id);
    }
  }

  /// Alias for setSelectedOutlet
  void setSelectedRestaurant(String restaurantName) =>
      setSelectedOutlet(restaurantName);

  void setSelectedPlatform(String platformId) {
    state = state.copyWith(selectedPlatformId: platformId);
  }

  void setSelectedRecordType(RecordType recordType) {
    state = state.copyWith(selectedRecordType: recordType);
  }

  void setSelectedStatus(OrderStatus status) {
    state = state.copyWith(selectedStatus: status);
  }

  void setOrderNoFilter(String orderNo) {
    state = state.copyWith(orderNoFilter: orderNo);
  }

  void setStartDate(DateTime date) {
    state = state.copyWith(startDate: date);
  }

  void setEndDate(DateTime date) {
    state = state.copyWith(endDate: date);
  }

  void toggleChartExpansion() {
    state = state.copyWith(isChartExpanded: !state.isChartExpanded);
  }

  Future<void> applyFilters() async {
    state = state.copyWith(isLoading: true, error: null);
    await _loadOnlineOrders();
    state = state.copyWith(isLoading: false);
  }

  void showAll() {
    state = state.copyWith(
      selectedPlatformId: 'all',
      selectedRecordType: RecordType.last2DaysRecords,
      selectedStatus: OrderStatus.all,
      orderNoFilter: '',
      startDate: DateTime.now().subtract(const Duration(days: 1)),
      endDate: DateTime.now(),
    );
    applyFilters();
  }

  Future<void> refresh() async {
    await applyFilters();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
