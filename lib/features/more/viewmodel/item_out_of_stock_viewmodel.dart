import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pos_app/core/providers/store_provider.dart';
import 'package:pos_app/core/providers/repository_providers.dart';
import 'package:pos_app/core/repositories/store_repository.dart';

part 'item_out_of_stock_viewmodel.g.dart';

/// State class for Item Out-Of-Stock Tracking
class ItemOutOfStockState {
  final String? selectedStoreId;
  final List<StoreModel> stores;
  final int selectedMainTabIndex; // 0 for Items, 1 for Addons
  final int selectedViewTabIndex; // 0 for Restaurant Wise, 1 for Item Wise
  final String? selectedRestaurantId;
  final String selectedCategory;
  final String itemName;
  final String selectedBrand;
  final String selectedOffDuration;
  final bool showRestaurantsWithAllItemsInStock;
  final bool isLoading;
  final String? error;
  final List<String> categoryList;
  final List<Map<String, dynamic>> products;

  const ItemOutOfStockState({
    this.selectedStoreId,
    this.stores = const [],
    this.selectedMainTabIndex = 0,
    this.selectedViewTabIndex = 0,
    this.selectedRestaurantId,
    this.selectedCategory = 'All',
    this.itemName = '',
    this.selectedBrand = 'All',
    this.selectedOffDuration = 'Select',
    this.showRestaurantsWithAllItemsInStock = false,
    this.isLoading = false,
    this.error,
    this.categoryList = const ['All'],
    this.products = const [],
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

  /// Categories fetched from backend
  List<String> get categories => categoryList;

  /// Brands - will be fetched from real data in future
  List<String> get brands => const ['All'];

  /// Off duration options
  List<String> get offDurationOptions => const [
    'Select',
    '30 minutes',
    '1 hour',
    '2 hours',
    '4 hours',
    '8 hours',
    '24 hours',
  ];

  ItemOutOfStockState copyWith({
    String? selectedStoreId,
    List<StoreModel>? stores,
    int? selectedMainTabIndex,
    int? selectedViewTabIndex,
    String? selectedRestaurantId,
    String? selectedCategory,
    String? itemName,
    String? selectedBrand,
    String? selectedOffDuration,
    bool? showRestaurantsWithAllItemsInStock,
    bool? isLoading,
    String? error,
    List<String>? categoryList,
    List<Map<String, dynamic>>? products,
  }) {
    return ItemOutOfStockState(
      selectedStoreId: selectedStoreId ?? this.selectedStoreId,
      stores: stores ?? this.stores,
      selectedMainTabIndex: selectedMainTabIndex ?? this.selectedMainTabIndex,
      selectedViewTabIndex: selectedViewTabIndex ?? this.selectedViewTabIndex,
      selectedRestaurantId: selectedRestaurantId ?? this.selectedRestaurantId,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      itemName: itemName ?? this.itemName,
      selectedBrand: selectedBrand ?? this.selectedBrand,
      selectedOffDuration: selectedOffDuration ?? this.selectedOffDuration,
      showRestaurantsWithAllItemsInStock:
          showRestaurantsWithAllItemsInStock ??
          this.showRestaurantsWithAllItemsInStock,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      categoryList: categoryList ?? this.categoryList,
      products: products ?? this.products,
    );
  }
}

/// ViewModel for the Item Out-Of-Stock Tracking screen
@riverpod
class ItemOutOfStockViewModel extends _$ItemOutOfStockViewModel {
  @override
  ItemOutOfStockState build() {
    // Watch global store provider for store list and selection
    final storeState = ref.watch(globalStoreNotifierProvider);

    final initialState = ItemOutOfStockState(
      stores: storeState.stores,
      selectedStoreId: storeState.selectedStoreId,
    );

    // Load categories from backend
    if (storeState.selectedStoreId != null) {
      _loadCategories(storeState.selectedStoreId!);
    }

    return initialState;
  }

  Future<void> _loadCategories(String storeId) async {
    final productRepo = ref.read(productRepositoryProvider);
    final result = await productRepo.getCategories(storeId);
    result.fold((failure) => {}, (categories) {
      final categoryNames = ['All', ...categories.map((c) => c.name)];
      state = state.copyWith(categoryList: categoryNames);
    });
  }

  void setSelectedOutlet(String outletName) {
    ref
        .read(globalStoreNotifierProvider.notifier)
        .setSelectedOutlet(outletName);
  }

  void setSelectedMainTabIndex(int index) {
    state = state.copyWith(selectedMainTabIndex: index);
  }

  void setSelectedViewTabIndex(int index) {
    state = state.copyWith(selectedViewTabIndex: index);
  }

  void setSelectedRestaurant(String restaurant) {
    if (restaurant == 'All') {
      state = state.copyWith(selectedRestaurantId: null);
    } else {
      final store = state.stores.where((s) => s.name == restaurant).firstOrNull;
      state = state.copyWith(selectedRestaurantId: store?.id);
    }
  }

  void setSelectedCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  void setItemName(String name) {
    state = state.copyWith(itemName: name);
  }

  void setSelectedBrand(String brand) {
    state = state.copyWith(selectedBrand: brand);
  }

  void setSelectedOffDuration(String duration) {
    state = state.copyWith(selectedOffDuration: duration);
  }

  void toggleShowRestaurantsWithAllItemsInStock() {
    state = state.copyWith(
      showRestaurantsWithAllItemsInStock:
          !state.showRestaurantsWithAllItemsInStock,
    );
  }

  void resetFilters() {
    state = state.copyWith(
      selectedRestaurantId: null,
      selectedCategory: 'All',
      itemName: '',
      selectedBrand: 'All',
      selectedOffDuration: 'Select',
      showRestaurantsWithAllItemsInStock: false,
    );
  }

  Future<void> search() async {
    state = state.copyWith(isLoading: true, error: null);

    final storeId = state.selectedStoreId ?? state.selectedRestaurantId;
    if (storeId == null) {
      state = state.copyWith(isLoading: false);
      return;
    }

    final productRepo = ref.read(productRepositoryProvider);
    final result = await productRepo.getProducts(storeId, activeOnly: false);
    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (products) {
        final filtered = products
            .where((p) {
              if (!p.isActive) return true; // out-of-stock items
              return false;
            })
            .map(
              (p) => {
                'id': p.id,
                'name': p.name,
                'categoryId': p.categoryId,
                'price': p.price,
                'isActive': p.isActive,
              },
            )
            .toList();
        state = state.copyWith(products: filtered, isLoading: false);
      },
    );
  }

  Future<void> exportData() async {
    // TODO: Implement export functionality via repository
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, error: null);
    // Refresh stores from global provider
    await ref.read(globalStoreNotifierProvider.notifier).refreshStores();
    state = state.copyWith(isLoading: false);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
