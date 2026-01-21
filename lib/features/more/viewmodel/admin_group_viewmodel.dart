import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pos_app/core/providers/repository_providers.dart';
import 'package:pos_app/core/repositories/store_repository.dart';

part 'admin_group_viewmodel.g.dart';

/// State for Admin Group Management page
class AdminGroupState {
  final String? selectedStoreId;
  final List<StoreModel> stores;
  final bool isSearchExpanded;
  final String adminGroupName;
  final List<Map<String, dynamic>> adminGroups;
  final bool isLoading;
  final String? error;

  const AdminGroupState({
    this.selectedStoreId,
    this.stores = const [],
    this.isSearchExpanded = true,
    this.adminGroupName = '',
    this.adminGroups = const [],
    this.isLoading = false,
    this.error,
  });

  AdminGroupState copyWith({
    String? selectedStoreId,
    List<StoreModel>? stores,
    bool? isSearchExpanded,
    String? adminGroupName,
    List<Map<String, dynamic>>? adminGroups,
    bool? isLoading,
    String? error,
  }) {
    return AdminGroupState(
      selectedStoreId: selectedStoreId ?? this.selectedStoreId,
      stores: stores ?? this.stores,
      isSearchExpanded: isSearchExpanded ?? this.isSearchExpanded,
      adminGroupName: adminGroupName ?? this.adminGroupName,
      adminGroups: adminGroups ?? this.adminGroups,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  List<String> get availableOutlets => [
    'All Outlets',
    ...stores.map((s) => s.name),
  ];

  String get selectedOutlet {
    if (selectedStoreId == null) return 'All Outlets';
    final store = stores.where((s) => s.id == selectedStoreId).firstOrNull;
    return store?.name ?? 'All Outlets';
  }

  String get selectedOutletName => selectedOutlet;
}

/// ViewModel for Admin Group Management page using Riverpod
@riverpod
class AdminGroupViewModel extends _$AdminGroupViewModel {
  late StoreRepository _storeRepo;

  @override
  AdminGroupState build() {
    _storeRepo = ref.watch(storeRepositoryProvider);
    _loadInitialData();
    return const AdminGroupState();
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

  void toggleSearchExpanded() {
    state = state.copyWith(isSearchExpanded: !state.isSearchExpanded);
  }

  void setAdminGroupName(String name) {
    state = state.copyWith(adminGroupName: name);
  }

  Future<void> search() async {
    state = state.copyWith(isLoading: true, error: null);

    // TODO: Implement API call to search admin groups
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(adminGroups: [], isLoading: false);
  }

  void showAll() {
    state = state.copyWith(adminGroupName: '');
    search();
  }

  void clearFilters() {
    state = state.copyWith(adminGroupName: '');
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
