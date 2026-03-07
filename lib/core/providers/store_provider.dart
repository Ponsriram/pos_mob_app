import 'dart:developer' as developer;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pos_app/core/providers/repository_providers.dart';
import 'package:pos_app/core/providers/local_storage_provider.dart';
import 'package:pos_app/core/repositories/store_repository.dart';

part 'store_provider.g.dart';

/// Global state for store/outlet selection across the app
class StoreState {
  final List<StoreModel> stores;
  final String? selectedStoreId;
  final bool isLoading;
  final String? error;

  const StoreState({
    this.stores = const [],
    this.selectedStoreId,
    this.isLoading = false,
    this.error,
  });

  StoreState copyWith({
    List<StoreModel>? stores,
    String? selectedStoreId,
    bool clearSelectedStore = false,
    bool? isLoading,
    String? error,
  }) {
    return StoreState(
      stores: stores ?? this.stores,
      selectedStoreId: clearSelectedStore
          ? null
          : (selectedStoreId ?? this.selectedStoreId),
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

  /// Get the selected store model
  StoreModel? get selectedStore {
    if (selectedStoreId == null) return null;
    return stores.where((s) => s.id == selectedStoreId).firstOrNull;
  }

  /// Check if stores are loaded
  bool get hasStores => stores.isNotEmpty;
}

/// Global store provider that manages outlet selection across the app
@Riverpod(keepAlive: true)
class GlobalStoreNotifier extends _$GlobalStoreNotifier {
  late StoreRepository _storeRepo;
  late LocalStorageService _localStorage;

  @override
  StoreState build() {
    _storeRepo = ref.watch(storeRepositoryProvider);
    _localStorage = ref.watch(localStorageServiceProvider);

    // Load stores on initialization
    _loadStores();

    return const StoreState(isLoading: true);
  }

  Future<void> _loadStores() async {
    developer.log('GlobalStore: Loading stores...', name: 'GlobalStore');

    final storesResult = await _storeRepo.getAccessibleStores();

    storesResult.fold(
      (failure) {
        developer.log(
          'GlobalStore: Failed to load stores: ${failure.message}',
          name: 'GlobalStore',
        );
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (stores) {
        developer.log(
          'GlobalStore: Loaded ${stores.length} stores: ${stores.map((s) => s.name).toList()}',
          name: 'GlobalStore',
        );

        // Restore previously selected outlet from local storage
        final savedOutletId = _localStorage.selectedOutletId;
        String? selectedStoreId;

        if (savedOutletId != null && stores.any((s) => s.id == savedOutletId)) {
          selectedStoreId = savedOutletId;
          developer.log(
            'GlobalStore: Restored selected outlet: $savedOutletId',
            name: 'GlobalStore',
          );
        }

        state = state.copyWith(
          stores: stores,
          selectedStoreId: selectedStoreId,
          isLoading: false,
        );
      },
    );
  }

  /// Refresh stores from the server
  Future<void> refreshStores() async {
    state = state.copyWith(isLoading: true, error: null);
    await _loadStores();
  }

  /// Set the selected outlet by name
  void setSelectedOutlet(String outletName) {
    developer.log(
      'GlobalStore: Setting outlet to: $outletName',
      name: 'GlobalStore',
    );

    if (outletName == 'All Outlets') {
      state = state.copyWith(clearSelectedStore: true);
      _localStorage.saveSelectedOutletId(null);
    } else {
      final store = state.stores.where((s) => s.name == outletName).firstOrNull;
      if (store != null) {
        state = state.copyWith(selectedStoreId: store.id);
        _localStorage.saveSelectedOutletId(store.id);
      }
    }

    developer.log(
      'GlobalStore: Selected store ID is now: ${state.selectedStoreId}',
      name: 'GlobalStore',
    );
  }

  /// Set the selected outlet by ID
  void setSelectedOutletById(String? storeId) {
    developer.log(
      'GlobalStore: Setting outlet by ID to: $storeId',
      name: 'GlobalStore',
    );

    state = state.copyWith(
      selectedStoreId: storeId,
      clearSelectedStore: storeId == null,
    );
    _localStorage.saveSelectedOutletId(storeId);
  }

  /// Clear the selected outlet
  void clearSelectedOutlet() {
    state = state.copyWith(clearSelectedStore: true);
    _localStorage.saveSelectedOutletId(null);
  }
}
