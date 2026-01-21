import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pos_app/core/providers/repository_providers.dart';
import 'package:pos_app/core/repositories/store_repository.dart';
import '../model/pending_purchase_model.dart';

part 'pending_purchase_viewmodel.g.dart';

/// State for the Pending Purchase page
class PendingPurchaseState {
  final String? selectedStoreId;
  final List<StoreModel> stores;
  final String selectedRestaurant;
  final DateTime startDate;
  final DateTime endDate;
  final bool isLoading;
  final List<PendingPurchaseModel> purchases;
  final String? error;

  PendingPurchaseState({
    this.selectedStoreId,
    this.stores = const [],
    this.selectedRestaurant = 'Aarthi cake Magic',
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
    String? selectedRestaurant,
    DateTime? startDate,
    DateTime? endDate,
    bool? isLoading,
    List<PendingPurchaseModel>? purchases,
    String? error,
  }) {
    return PendingPurchaseState(
      selectedStoreId: selectedStoreId ?? this.selectedStoreId,
      stores: stores ?? this.stores,
      selectedRestaurant: selectedRestaurant ?? this.selectedRestaurant,
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

  List<String> get restaurants => [
    'Aarthi cake Magic',
    'Restaurant 1',
    'Restaurant 2',
  ];

  bool get isEmpty => purchases.isEmpty;
}

/// ViewModel for the Pending Purchase page using Riverpod
@riverpod
class PendingPurchaseViewModel extends _$PendingPurchaseViewModel {
  late StoreRepository _storeRepo;

  @override
  PendingPurchaseState build() {
    _storeRepo = ref.watch(storeRepositoryProvider);
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
    state = state.copyWith(selectedRestaurant: restaurant);
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
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(purchases: [], isLoading: false);
    } catch (e) {
      state = state.copyWith(
        purchases: [],
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> showAll() async {
    state = state.copyWith(
      selectedRestaurant: state.restaurants.first,
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
