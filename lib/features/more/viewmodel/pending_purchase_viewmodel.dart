import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pos_app/core/providers/repository_providers.dart';
import 'package:pos_app/core/repositories/store_repository.dart';
import 'package:pos_app/core/repositories/purchasing_repository.dart';
import '../model/pending_purchase_model.dart';

part 'pending_purchase_viewmodel.g.dart';

/// State for the Pending Purchase page
class PendingPurchaseState {
  final String? selectedStoreId;
  final List<StoreModel> stores;
  final String? selectedRestaurantId;
  final DateTime startDate;
  final DateTime endDate;
  final bool isLoading;
  final List<PendingPurchaseModel> purchases;
  final String? error;

  PendingPurchaseState({
    this.selectedStoreId,
    this.stores = const [],
    this.selectedRestaurantId,
    DateTime? startDate,
    DateTime? endDate,
    this.isLoading = false,
    this.purchases = const [],
    this.error,
  }) : startDate =
           startDate ?? DateTime.now().subtract(const Duration(days: 7)),
       endDate = endDate ?? DateTime.now();

  PendingPurchaseState copyWith({
    String? selectedStoreId,
    List<StoreModel>? stores,
    String? selectedRestaurantId,
    DateTime? startDate,
    DateTime? endDate,
    bool? isLoading,
    List<PendingPurchaseModel>? purchases,
    String? error,
  }) {
    return PendingPurchaseState(
      selectedStoreId: selectedStoreId ?? this.selectedStoreId,
      stores: stores ?? this.stores,
      selectedRestaurantId: selectedRestaurantId ?? this.selectedRestaurantId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isLoading: isLoading ?? this.isLoading,
      purchases: purchases ?? this.purchases,
      error: error,
    );
  }

  List<String> get availableOutlets => [
    'All Outlets',
    ...stores.map((s) => s.name),
  ];

  String get selectedOutletName {
    if (selectedStoreId == null) return 'All Outlets';
    final store = stores.where((s) => s.id == selectedStoreId).firstOrNull;
    return store?.name ?? 'All Outlets';
  }

  /// Alias for selectedOutletName
  String get selectedOutlet => selectedOutletName;

  /// Alias for availableOutlets
  List<String> get outlets => availableOutlets;

  /// Restaurants derived from stores
  List<String> get restaurants => stores.map((s) => s.name).toList();

  String get selectedRestaurant {
    if (selectedRestaurantId == null && stores.isNotEmpty) {
      return stores.first.name;
    }
    final store = stores.where((s) => s.id == selectedRestaurantId).firstOrNull;
    return store?.name ?? (stores.isNotEmpty ? stores.first.name : '');
  }

  bool get isEmpty => purchases.isEmpty;
}

/// ViewModel for the Pending Purchase page using Riverpod
@riverpod
class PendingPurchaseViewModel extends _$PendingPurchaseViewModel {
  late StoreRepository _storeRepo;
  late PurchasingRepository _purchasingRepo;

  @override
  PendingPurchaseState build() {
    _storeRepo = ref.watch(storeRepositoryProvider);
    _purchasingRepo = ref.watch(purchasingRepositoryProvider);
    _loadInitialData();
    return PendingPurchaseState();
  }

  Future<void> _loadInitialData() async {
    final storesResult = await _storeRepo.getAccessibleStores();
    storesResult.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (stores) => state = state.copyWith(stores: stores),
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

  void setSelectedRestaurant(String restaurant) {
    final store = state.stores.where((s) => s.name == restaurant).firstOrNull;
    state = state.copyWith(selectedRestaurantId: store?.id);
  }

  void setStartDate(DateTime date) {
    state = state.copyWith(startDate: date);
  }

  void setEndDate(DateTime date) {
    state = state.copyWith(endDate: date);
  }

  Future<void> search() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final storeId =
          state.selectedRestaurantId ??
          (state.stores.isNotEmpty ? state.stores.first.id : null);
      if (storeId == null) {
        state = state.copyWith(purchases: [], isLoading: false);
        return;
      }

      final result = await _purchasingRepo.getPendingSummary(storeId);
      result.fold(
        (failure) => state = state.copyWith(
          purchases: [],
          isLoading: false,
          error: failure.message,
        ),
        (summaries) {
          final purchases = summaries
              .map(
                (s) => PendingPurchaseModel(
                  id: '${s.storeId}_${s.vendorId}',
                  restaurantName: s.vendorName ?? '',
                  itemName: '',
                  quantity: s.pendingOrdersCount.toDouble(),
                  unit: 'orders',
                  amount: s.totalPendingAmount,
                  date: DateTime.now(),
                  status: 'pending',
                  type: 'sales',
                ),
              )
              .toList();
          state = state.copyWith(purchases: purchases, isLoading: false);
        },
      );
    } catch (e) {
      state = state.copyWith(
        purchases: [],
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> showAll() async {
    final firstStoreId = state.stores.isNotEmpty ? state.stores.first.id : null;
    state = state.copyWith(
      selectedRestaurantId: firstStoreId,
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now(),
    );
    await search();
  }

  void reset() {
    state = PendingPurchaseState(stores: state.stores);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
