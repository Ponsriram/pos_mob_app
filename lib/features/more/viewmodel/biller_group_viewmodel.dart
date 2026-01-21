import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pos_app/core/providers/repository_providers.dart';
import 'package:pos_app/core/repositories/store_repository.dart';

part 'biller_group_viewmodel.g.dart';

/// State for Biller Group Management page
class BillerGroupState {
  final String? selectedStoreId;
  final List<StoreModel> stores;
  final bool isSearchExpanded;
  final String billerGroupName;
  final String selectedUserType;
  final List<String> userTypes;
  final List<Map<String, dynamic>> billerGroups;
  final bool isLoading;
  final String? error;

  const BillerGroupState({
    this.selectedStoreId,
    this.stores = const [],
    this.isSearchExpanded = true,
    this.billerGroupName = '',
    this.selectedUserType = 'All',
    this.userTypes = const ['All', 'Billing User', 'Captain'],
    this.billerGroups = const [],
    this.isLoading = false,
    this.error,
  });

  BillerGroupState copyWith({
    String? selectedStoreId,
    List<StoreModel>? stores,
    bool? isSearchExpanded,
    String? billerGroupName,
    String? selectedUserType,
    List<String>? userTypes,
    List<Map<String, dynamic>>? billerGroups,
    bool? isLoading,
    String? error,
  }) {
    return BillerGroupState(
      selectedStoreId: selectedStoreId ?? this.selectedStoreId,
      stores: stores ?? this.stores,
      isSearchExpanded: isSearchExpanded ?? this.isSearchExpanded,
      billerGroupName: billerGroupName ?? this.billerGroupName,
      selectedUserType: selectedUserType ?? this.selectedUserType,
      userTypes: userTypes ?? this.userTypes,
      billerGroups: billerGroups ?? this.billerGroups,
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

/// ViewModel for Biller Group Management page using Riverpod
@riverpod
class BillerGroupViewModel extends _$BillerGroupViewModel {
  late StoreRepository _storeRepo;

  @override
  BillerGroupState build() {
    _storeRepo = ref.watch(storeRepositoryProvider);
    _loadInitialData();
    return const BillerGroupState();
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

  void setBillerGroupName(String name) {
    state = state.copyWith(billerGroupName: name);
  }

  void setSelectedUserType(String type) {
    state = state.copyWith(selectedUserType: type);
  }

  Future<void> search() async {
    state = state.copyWith(isLoading: true, error: null);

    // TODO: Implement API call to search biller groups
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(billerGroups: [], isLoading: false);
  }

  void showAll() {
    state = state.copyWith(billerGroupName: '', selectedUserType: 'All');
    search();
  }

  void clearFilters() {
    state = state.copyWith(billerGroupName: '', selectedUserType: 'All');
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
