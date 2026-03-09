import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pos_app/core/providers/repository_providers.dart';
import 'package:pos_app/core/repositories/store_repository.dart';
import 'package:pos_app/core/repositories/user_repository.dart';

part 'cloud_access_viewmodel.g.dart';

/// State for Cloud Access page
class CloudAccessState {
  final String? selectedStoreId;
  final List<StoreModel> stores;
  final bool isSearchExpanded;
  final String name;
  final String email;
  final String selectedType;
  final List<String> types;
  final String selectedStatus;
  final List<String> statuses;
  final List<Map<String, dynamic>> users;
  final bool isLoading;
  final String? error;

  const CloudAccessState({
    this.selectedStoreId,
    this.stores = const [],
    this.isSearchExpanded = true,
    this.name = '',
    this.email = '',
    this.selectedType = 'All',
    this.types = const ['All', 'Franchise Owner', 'Restaurant User'],
    this.selectedStatus = 'Active',
    this.statuses = const ['All', 'Active', 'Inactive'],
    this.users = const [],
    this.isLoading = false,
    this.error,
  });

  CloudAccessState copyWith({
    String? selectedStoreId,
    List<StoreModel>? stores,
    bool? isSearchExpanded,
    String? name,
    String? email,
    String? selectedType,
    List<String>? types,
    String? selectedStatus,
    List<String>? statuses,
    List<Map<String, dynamic>>? users,
    bool? isLoading,
    String? error,
  }) {
    return CloudAccessState(
      selectedStoreId: selectedStoreId ?? this.selectedStoreId,
      stores: stores ?? this.stores,
      isSearchExpanded: isSearchExpanded ?? this.isSearchExpanded,
      name: name ?? this.name,
      email: email ?? this.email,
      selectedType: selectedType ?? this.selectedType,
      types: types ?? this.types,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      statuses: statuses ?? this.statuses,
      users: users ?? this.users,
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

/// ViewModel for Cloud Access page using Riverpod
@riverpod
class CloudAccessViewModel extends _$CloudAccessViewModel {
  late StoreRepository _storeRepo;
  late UserRepository _userRepo;

  @override
  CloudAccessState build() {
    _storeRepo = ref.watch(storeRepositoryProvider);
    _userRepo = ref.watch(userRepositoryProvider);
    _loadInitialData();
    return const CloudAccessState();
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

  void setName(String value) {
    state = state.copyWith(name: value);
  }

  void setEmail(String value) {
    state = state.copyWith(email: value);
  }

  void setSelectedType(String type) {
    state = state.copyWith(selectedType: type);
  }

  void setSelectedStatus(String status) {
    state = state.copyWith(selectedStatus: status);
  }

  Future<void> search() async {
    state = state.copyWith(isLoading: true, error: null);

    // Map filter values to API params
    String? roleFilter;
    if (state.selectedType != 'All') {
      roleFilter = state.selectedType.toLowerCase().replaceAll(' ', '_');
    }
    bool? isActiveFilter;
    if (state.selectedStatus == 'Active') {
      isActiveFilter = true;
    } else if (state.selectedStatus == 'Inactive') {
      isActiveFilter = false;
    }

    final result = await _userRepo.getSubUsers(
      role: roleFilter,
      isActive: isActiveFilter,
    );
    result.fold(
      (failure) =>
          state = state.copyWith(error: failure.message, isLoading: false),
      (subUsers) {
        // Apply local name/email filters
        var filtered = subUsers.where((u) {
          if (state.name.isNotEmpty &&
              !u.name.toLowerCase().contains(state.name.toLowerCase())) {
            return false;
          }
          if (state.email.isNotEmpty &&
              !u.email.toLowerCase().contains(state.email.toLowerCase())) {
            return false;
          }
          return true;
        }).toList();

        final userMaps = filtered
            .map(
              (u) => {
                'id': u.id,
                'name': u.name,
                'email': u.email,
                'phone': u.phone ?? '',
                'role': u.role,
                'isActive': u.isActive,
              },
            )
            .toList();
        state = state.copyWith(users: userMaps, isLoading: false);
      },
    );
  }

  void showAll() {
    state = state.copyWith(
      name: '',
      email: '',
      selectedType: 'All',
      selectedStatus: 'Active',
    );
    search();
  }

  void clearFilters() {
    state = state.copyWith(
      name: '',
      email: '',
      selectedType: 'All',
      selectedStatus: 'Active',
    );
  }

  void setActiveStatus() {
    // TODO: Implement bulk set active
  }

  void setInactiveStatus() {
    // TODO: Implement bulk set inactive
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
