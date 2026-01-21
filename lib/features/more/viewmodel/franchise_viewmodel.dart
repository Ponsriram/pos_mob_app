import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pos_app/core/providers/repository_providers.dart';
import 'package:pos_app/core/repositories/store_repository.dart';
import '../model/franchise_model.dart';

part 'franchise_viewmodel.g.dart';

/// State for Franchise screen
class FranchiseState {
  final String? selectedStoreId;
  final String nameFilter;
  final String refIdFilter;
  final List<FranchiseOutlet> franchises;
  final List<FranchiseOutlet> filteredFranchises;
  final List<StoreModel> stores;
  final bool isLoading;
  final String? error;

  const FranchiseState({
    this.selectedStoreId,
    this.nameFilter = '',
    this.refIdFilter = '',
    this.franchises = const [],
    this.filteredFranchises = const [],
    this.stores = const [],
    this.isLoading = false,
    this.error,
  });

  FranchiseState copyWith({
    String? selectedStoreId,
    String? nameFilter,
    String? refIdFilter,
    List<FranchiseOutlet>? franchises,
    List<FranchiseOutlet>? filteredFranchises,
    List<StoreModel>? stores,
    bool? isLoading,
    String? error,
  }) {
    return FranchiseState(
      selectedStoreId: selectedStoreId ?? this.selectedStoreId,
      nameFilter: nameFilter ?? this.nameFilter,
      refIdFilter: refIdFilter ?? this.refIdFilter,
      franchises: franchises ?? this.franchises,
      filteredFranchises: filteredFranchises ?? this.filteredFranchises,
      stores: stores ?? this.stores,
      isLoading: isLoading ?? this.isLoading,
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
}

/// ViewModel for Franchise screen using Riverpod
@riverpod
class FranchiseViewModel extends _$FranchiseViewModel {
  late StoreRepository _storeRepo;

  @override
  FranchiseState build() {
    _storeRepo = ref.watch(storeRepositoryProvider);

    _loadInitialData();

    final defaultFranchises = [
      FranchiseOutlet(id: '1', name: 'Aarthi cake Magic', refId: '363317'),
      FranchiseOutlet(
        id: '2',
        name: 'Ambattur Aarthi sweets and bakery',
        refId: '383514',
      ),
    ];

    return FranchiseState(
      franchises: defaultFranchises,
      filteredFranchises: defaultFranchises,
    );
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

  void setNameFilter(String value) {
    state = state.copyWith(nameFilter: value);
  }

  void setRefIdFilter(String value) {
    state = state.copyWith(refIdFilter: value);
  }

  void search() {
    final filtered = state.franchises.where((franchise) {
      final matchesName =
          state.nameFilter.isEmpty ||
          franchise.name.toLowerCase().contains(state.nameFilter.toLowerCase());
      final matchesRefId =
          state.refIdFilter.isEmpty ||
          franchise.refId.toLowerCase().contains(
            state.refIdFilter.toLowerCase(),
          );
      return matchesName && matchesRefId;
    }).toList();
    state = state.copyWith(filteredFranchises: filtered);
  }

  void showAll() {
    state = state.copyWith(
      nameFilter: '',
      refIdFilter: '',
      filteredFranchises: state.franchises,
    );
  }

  void toggleLock(String id) {
    final updatedFranchises = state.franchises.map((f) {
      if (f.id == id) {
        return FranchiseOutlet(
          id: f.id,
          name: f.name,
          refId: f.refId,
          isLocked: !f.isLocked,
        );
      }
      return f;
    }).toList();
    state = state.copyWith(franchises: updatedFranchises);
    search();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
