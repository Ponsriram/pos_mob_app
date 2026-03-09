import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pos_app/core/providers/repository_providers.dart';
import 'package:pos_app/core/repositories/store_repository.dart';
import 'package:pos_app/core/repositories/integration_repository.dart';

part 'store_status_tracking_viewmodel.g.dart';

/// State class for Store Status Tracking
class StoreStatusTrackingState {
  final String? selectedStoreId;
  final List<StoreModel> stores;
  final String? selectedRestaurantId;
  final String selectedAggregator;
  final String selectedBrand;
  final String selectedOfflineDuration;
  final int selectedTabIndex; // 0 for Restaurant Wise, 1 for Aggregator
  final bool isLoading;
  final String? error;
  final List<String> aggregatorList;
  final List<AggregatorStoreStatusModel> storeStatuses;

  const StoreStatusTrackingState({
    this.selectedStoreId,
    this.stores = const [],
    this.selectedRestaurantId,
    this.selectedAggregator = 'Select',
    this.selectedBrand = 'All',
    this.selectedOfflineDuration = 'Select',
    this.selectedTabIndex = 0,
    this.isLoading = false,
    this.error,
    this.aggregatorList = const ['Select', 'All'],
    this.storeStatuses = const [],
  });

  List<String> get availableOutlets => [
    'All Outlets',
    ...stores.map((s) => s.name),
  ];

  String get selectedOutletName {
    if (selectedStoreId == null) return 'All Outlets';
    final store = stores.where((s) => s.id == selectedStoreId).firstOrNull;
    return store?.name ?? 'All Outlets';
  }

  String get selectedOutlet => selectedOutletName;

  /// Restaurants derived from stores
  List<String> get restaurants => ['All', ...stores.map((s) => s.name)];

  String get selectedRestaurant {
    if (selectedRestaurantId == null) return 'All';
    final store = stores.where((s) => s.id == selectedRestaurantId).firstOrNull;
    return store?.name ?? 'All';
  }

  /// Available aggregators fetched from backend
  List<String> get aggregators => aggregatorList;

  /// Available brands
  List<String> get brands => const ['All'];

  /// Offline duration options
  List<String> get offlineDurations => const [
    'Select',
    '30 minutes',
    '1 hour',
    '2 hours',
    '4 hours',
    '8 hours',
    '24 hours',
  ];

  StoreStatusTrackingState copyWith({
    String? selectedStoreId,
    List<StoreModel>? stores,
    String? selectedRestaurantId,
    String? selectedAggregator,
    String? selectedBrand,
    String? selectedOfflineDuration,
    int? selectedTabIndex,
    bool? isLoading,
    String? error,
    List<String>? aggregatorList,
    List<AggregatorStoreStatusModel>? storeStatuses,
  }) {
    return StoreStatusTrackingState(
      selectedStoreId: selectedStoreId ?? this.selectedStoreId,
      stores: stores ?? this.stores,
      selectedRestaurantId: selectedRestaurantId ?? this.selectedRestaurantId,
      selectedAggregator: selectedAggregator ?? this.selectedAggregator,
      selectedBrand: selectedBrand ?? this.selectedBrand,
      selectedOfflineDuration:
          selectedOfflineDuration ?? this.selectedOfflineDuration,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      aggregatorList: aggregatorList ?? this.aggregatorList,
      storeStatuses: storeStatuses ?? this.storeStatuses,
    );
  }
}

/// ViewModel for Store Status Tracking page
@riverpod
class StoreStatusTrackingViewModel extends _$StoreStatusTrackingViewModel {
  late StoreRepository _storeRepo;
  late IntegrationRepository _integrationRepo;

  @override
  StoreStatusTrackingState build() {
    _storeRepo = ref.watch(storeRepositoryProvider);
    _integrationRepo = ref.watch(integrationRepositoryProvider);
    _loadInitialData();
    return const StoreStatusTrackingState();
  }

  Future<void> _loadInitialData() async {
    state = state.copyWith(isLoading: true);
    final storesResult = await _storeRepo.getAccessibleStores();
    storesResult.fold(
      (failure) =>
          state = state.copyWith(error: failure.message, isLoading: false),
      (stores) => state = state.copyWith(stores: stores, isLoading: false),
    );

    // Load aggregators from backend
    final aggResult = await _integrationRepo.getAggregators();
    aggResult.fold((failure) => {}, (aggregators) {
      final names = ['Select', ...aggregators.map((a) => a.name), 'All'];
      state = state.copyWith(aggregatorList: names);
    });

    // Load store status if a store is selected
    if (state.selectedStoreId != null) {
      await _loadStoreStatus(state.selectedStoreId!);
    }
  }

  Future<void> _loadStoreStatus(String storeId) async {
    final result = await _integrationRepo.getStoreStatus(storeId);
    result.fold(
      (failure) => {},
      (statuses) => state = state.copyWith(storeStatuses: statuses),
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

  void setSelectedRestaurant(String restaurantName) {
    if (restaurantName == 'All') {
      state = state.copyWith(selectedRestaurantId: null);
    } else {
      final store = state.stores
          .where((s) => s.name == restaurantName)
          .firstOrNull;
      state = state.copyWith(selectedRestaurantId: store?.id);
    }
  }

  void setSelectedAggregator(String aggregator) {
    state = state.copyWith(selectedAggregator: aggregator);
  }

  void setSelectedBrand(String brand) {
    state = state.copyWith(selectedBrand: brand);
  }

  void setSelectedOfflineDuration(String duration) {
    state = state.copyWith(selectedOfflineDuration: duration);
  }

  void setSelectedTabIndex(int index) {
    state = state.copyWith(selectedTabIndex: index);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
