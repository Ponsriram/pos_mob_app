import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pos_app/core/providers/repository_providers.dart';
import 'package:pos_app/core/providers/store_provider.dart';
import 'package:pos_app/core/repositories/order_repository.dart';
import 'package:pos_app/core/repositories/store_repository.dart';
import 'package:pos_app/features/dashboard/model/order_category_model.dart';

part 'running_orders_viewmodel.g.dart';

/// State for Running Orders screen
class RunningOrdersState {
  final String? selectedStoreId;
  final int selectedTabIndex;
  final List<OrderModel> runningOrders;
  final List<StoreModel> stores;
  final bool isLoading;
  final String? error;

  const RunningOrdersState({
    this.selectedStoreId,
    this.selectedTabIndex = 0,
    this.runningOrders = const [],
    this.stores = const [],
    this.isLoading = false,
    this.error,
  });

  RunningOrdersState copyWith({
    String? selectedStoreId,
    int? selectedTabIndex,
    List<OrderModel>? runningOrders,
    List<StoreModel>? stores,
    bool? isLoading,
    String? error,
  }) {
    return RunningOrdersState(
      selectedStoreId: selectedStoreId ?? this.selectedStoreId,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      runningOrders: runningOrders ?? this.runningOrders,
      stores: stores ?? this.stores,
      isLoading: isLoading ?? this.isLoading,
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

  /// Total table count (placeholder)
  int get totalTableCount => runningOrders.length;

  /// Order categories for running orders screen
  List<OrderCategoryModel> get orderCategories {
    final dineInOrders = runningOrders
        .where((o) => o.orderType == 'dine_in')
        .toList();
    final pickUpOrders = runningOrders
        .where((o) => o.orderType == 'takeaway')
        .toList();
    // Delivery includes direct delivery + online platform orders
    final deliveryOrders = runningOrders
        .where(
          (o) =>
              o.orderType == 'delivery' ||
              OrderPlatformExtension.isOnlinePlatform(o.channel),
        )
        .toList();
    final pendingOrders = runningOrders
        .where(
          (o) =>
              o.status == OrderStatus.pending ||
              o.status == OrderStatus.confirmed,
        )
        .toList();
    final preparingOrders = runningOrders
        .where((o) => o.status == OrderStatus.preparing)
        .toList();

    return [
      OrderCategoryModel(
        title: 'Dine In',
        subtitle: 'Orders / KOTS',
        orderCount: dineInOrders.length,
        estimatedAmount: dineInOrders.fold(
          0.0,
          (sum, order) => sum + order.totalAmount,
        ),
        type: OrderCategoryType.dineIn,
      ),
      OrderCategoryModel(
        title: 'Pick Up',
        subtitle: 'Orders',
        orderCount: pickUpOrders.length,
        estimatedAmount: pickUpOrders.fold(
          0.0,
          (sum, order) => sum + order.totalAmount,
        ),
        type: OrderCategoryType.pickUp,
      ),
      OrderCategoryModel(
        title: 'Delivery',
        subtitle: 'Orders',
        orderCount: deliveryOrders.length,
        estimatedAmount: deliveryOrders.fold(
          0.0,
          (sum, order) => sum + order.totalAmount,
        ),
        type: OrderCategoryType.delivery,
      ),
      OrderCategoryModel(
        title: 'Order yet to be marked ready',
        subtitle: 'Orders',
        orderCount: pendingOrders.length,
        estimatedAmount: pendingOrders.fold(
          0.0,
          (sum, order) => sum + order.totalAmount,
        ),
        type: OrderCategoryType.yetToBeMarkedReady,
      ),
      OrderCategoryModel(
        title: 'Order yet to be picked up',
        subtitle: 'Orders',
        orderCount: preparingOrders.length,
        estimatedAmount: preparingOrders.fold(
          0.0,
          (sum, order) => sum + order.totalAmount,
        ),
        type: OrderCategoryType.yetToBePickedUp,
      ),
    ];
  }

  /// Get total order count
  int get totalOrderCount => runningOrders.length;

  /// Get orders by status
  List<OrderModel> get pendingOrders =>
      runningOrders.where((o) => o.status == OrderStatus.pending).toList();

  List<OrderModel> get preparingOrders =>
      runningOrders.where((o) => o.status == OrderStatus.preparing).toList();

  List<OrderModel> get readyOrders =>
      runningOrders.where((o) => o.status == OrderStatus.ready).toList();

  /// Get total estimated amount
  double get totalEstimatedAmount =>
      runningOrders.fold(0.0, (sum, order) => sum + order.totalAmount);
}

/// ViewModel for the Running Orders screen using Riverpod
@riverpod
class RunningOrdersViewModel extends _$RunningOrdersViewModel {
  late OrderRepository _orderRepo;

  @override
  RunningOrdersState build() {
    _orderRepo = ref.watch(orderRepositoryProvider);

    // Watch global store provider for store list and selection
    final storeState = ref.watch(globalStoreNotifierProvider);

    _loadInitialData();

    return RunningOrdersState(
      stores: storeState.stores,
      selectedStoreId: storeState.selectedStoreId,
    );
  }

  Future<void> _loadInitialData() async {
    state = state.copyWith(isLoading: true, error: null);

    // Load running orders
    await _loadRunningOrders();

    state = state.copyWith(isLoading: false);
  }

  Future<void> _loadRunningOrders() async {
    // Skip loading if no store selected yet
    final storeId = state.selectedStoreId;
    if (storeId == null) {
      state = state.copyWith(runningOrders: []);
      return;
    }

    final result = await _orderRepo.getRunningOrders(storeId: storeId);

    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (orders) => state = state.copyWith(runningOrders: orders),
    );
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, error: null);
    await _loadRunningOrders();
    state = state.copyWith(isLoading: false);
  }

  /// Alias for refresh
  Future<void> refreshOrders() => refresh();

  void setSelectedOutlet(String outletName) {
    ref
        .read(globalStoreNotifierProvider.notifier)
        .setSelectedOutlet(outletName);
    _loadRunningOrders();
  }

  void setSelectedTabIndex(int index) {
    state = state.copyWith(selectedTabIndex: index);
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    final result = await _orderRepo.updateOrderStatus(
      orderId: orderId,
      status: newStatus,
    );
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (_) => _loadRunningOrders(),
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
