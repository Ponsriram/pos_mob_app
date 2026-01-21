import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/repositories/store_repository.dart';
import '../../../core/providers/repository_providers.dart';

part 'item_out_of_stock_viewmodel.g.dart';

/// State class for Item Out-Of-Stock Tracking
class ItemOutOfStockState {
  final String selectedOutlet;
  final int selectedMainTabIndex; // 0 for Items, 1 for Addons
  final int selectedViewTabIndex; // 0 for Restaurant Wise, 1 for Item Wise
  final String selectedRestaurant;
  final String selectedCategory;
  final String itemName;
  final String selectedBrand;
  final String selectedOffDuration;
  final bool showRestaurantsWithAllItemsInStock;
  final List<String> availableOutlets;
  final List<String> restaurants;
  final List<String> categories;
  final List<String> brands;
  final List<String> offDurationOptions;
  final bool isLoading;
  final String? error;

  const ItemOutOfStockState({
    this.selectedOutlet = 'All Outlets',
    this.selectedMainTabIndex = 0,
    this.selectedViewTabIndex = 0,
    this.selectedRestaurant = 'All',
    this.selectedCategory = 'All',
    this.itemName = '',
    this.selectedBrand = 'All',
    this.selectedOffDuration = 'Select',
    this.showRestaurantsWithAllItemsInStock = false,
    this.availableOutlets = const [
      'All Outlets',
      'Aarthi cake Magic',
      'Ambattur Aarthi sweets and bakery',
    ],
    this.restaurants = const [
      'All',
      'Aarthi cake Magic',
      'Ambattur Aarthi sweets and bakery',
    ],
    this.categories = const [
      'All',
      'Beverages',
      'Snacks',
      'Main Course',
      'Desserts',
    ],
    this.brands = const ['All', 'Brand A', 'Brand B', 'Brand C'],
    this.offDurationOptions = const [
      'Select',
      '30 minutes',
      '1 hour',
      '2 hours',
      '4 hours',
      '8 hours',
      '24 hours',
    ],
    this.isLoading = false,
    this.error,
  });

  ItemOutOfStockState copyWith({
    String? selectedOutlet,
    int? selectedMainTabIndex,
    int? selectedViewTabIndex,
    String? selectedRestaurant,
    String? selectedCategory,
    String? itemName,
    String? selectedBrand,
    String? selectedOffDuration,
    bool? showRestaurantsWithAllItemsInStock,
    List<String>? availableOutlets,
    List<String>? restaurants,
    List<String>? categories,
    List<String>? brands,
    List<String>? offDurationOptions,
    bool? isLoading,
    String? error,
  }) {
    return ItemOutOfStockState(
      selectedOutlet: selectedOutlet ?? this.selectedOutlet,
      selectedMainTabIndex: selectedMainTabIndex ?? this.selectedMainTabIndex,
      selectedViewTabIndex: selectedViewTabIndex ?? this.selectedViewTabIndex,
      selectedRestaurant: selectedRestaurant ?? this.selectedRestaurant,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      itemName: itemName ?? this.itemName,
      selectedBrand: selectedBrand ?? this.selectedBrand,
      selectedOffDuration: selectedOffDuration ?? this.selectedOffDuration,
      showRestaurantsWithAllItemsInStock:
          showRestaurantsWithAllItemsInStock ??
          this.showRestaurantsWithAllItemsInStock,
      availableOutlets: availableOutlets ?? this.availableOutlets,
      restaurants: restaurants ?? this.restaurants,
      categories: categories ?? this.categories,
      brands: brands ?? this.brands,
      offDurationOptions: offDurationOptions ?? this.offDurationOptions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// ViewModel for the Item Out-Of-Stock Tracking screen
@riverpod
class ItemOutOfStockViewModel extends _$ItemOutOfStockViewModel {
  late final StoreRepository _storeRepo;

  @override
  ItemOutOfStockState build() {
    _storeRepo = ref.watch(storeRepositoryProvider);
    return const ItemOutOfStockState();
  }

  void setSelectedOutlet(String outlet) {
    state = state.copyWith(selectedOutlet: outlet);
  }

  void setSelectedMainTabIndex(int index) {
    state = state.copyWith(selectedMainTabIndex: index);
  }

  void setSelectedViewTabIndex(int index) {
    state = state.copyWith(selectedViewTabIndex: index);
  }

  void setSelectedRestaurant(String restaurant) {
    state = state.copyWith(selectedRestaurant: restaurant);
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
      selectedRestaurant: 'All',
      selectedCategory: 'All',
      itemName: '',
      selectedBrand: 'All',
      selectedOffDuration: 'Select',
      showRestaurantsWithAllItemsInStock: false,
    );
  }

  Future<void> search() async {
    state = state.copyWith(isLoading: true, error: null);
    // TODO: Implement actual search API call via repository
    state = state.copyWith(isLoading: false);
  }

  Future<void> exportData() async {
    // TODO: Implement export functionality via repository
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, error: null);
    // TODO: Implement refresh API call via repository
    state = state.copyWith(isLoading: false);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
