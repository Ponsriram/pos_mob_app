import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pos_app/core/providers/repository_providers.dart';
import 'package:pos_app/core/repositories/store_repository.dart';
import 'package:pos_app/core/repositories/integration_repository.dart';

part 'menu_trigger_logs_viewmodel.g.dart';

/// State class for Menu Trigger Logs
class MenuTriggerLogsState {
  final String? selectedStoreId;
  final List<StoreModel> stores;
  final bool isSearchExpanded;
  final String? selectedRestaurantId;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String selectedThirdpartyUser;
  final String clientRestaurantId;
  final String requestId;
  final String selectedStatus;
  final List<Map<String, dynamic>> logs;
  final bool isLoading;
  final String? error;
  final List<String> thirdpartyUserList;

  const MenuTriggerLogsState({
    this.selectedStoreId,
    this.stores = const [],
    this.isSearchExpanded = true,
    this.selectedRestaurantId,
    this.fromDate,
    this.toDate,
    this.selectedThirdpartyUser = 'Select Thirdparty User',
    this.clientRestaurantId = '',
    this.requestId = '',
    this.selectedStatus = 'All',
    this.logs = const [],
    this.isLoading = false,
    this.error,
    this.thirdpartyUserList = const ['Select Thirdparty User'],
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

  /// Restaurants derived from stores with ID prefix
  List<String> get restaurants => [
    'Please Select',
    ...stores.map((s) => '${s.id} - ${s.name}'),
  ];

  String get selectedRestaurant {
    if (selectedRestaurantId == null) return 'Please Select';
    final store = stores.where((s) => s.id == selectedRestaurantId).firstOrNull;
    return store != null ? '${store.id} - ${store.name}' : 'Please Select';
  }

  /// Available third party users fetched from backend
  List<String> get thirdpartyUsers => thirdpartyUserList;

  /// Available statuses
  List<String> get statuses => const ['All', 'Success', 'Failed', 'In Process'];

  MenuTriggerLogsState copyWith({
    String? selectedStoreId,
    List<StoreModel>? stores,
    bool? isSearchExpanded,
    String? selectedRestaurantId,
    DateTime? fromDate,
    DateTime? toDate,
    String? selectedThirdpartyUser,
    String? clientRestaurantId,
    String? requestId,
    String? selectedStatus,
    List<Map<String, dynamic>>? logs,
    bool? isLoading,
    String? error,
    List<String>? thirdpartyUserList,
  }) {
    return MenuTriggerLogsState(
      selectedStoreId: selectedStoreId ?? this.selectedStoreId,
      stores: stores ?? this.stores,
      isSearchExpanded: isSearchExpanded ?? this.isSearchExpanded,
      selectedRestaurantId: selectedRestaurantId ?? this.selectedRestaurantId,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      selectedThirdpartyUser:
          selectedThirdpartyUser ?? this.selectedThirdpartyUser,
      clientRestaurantId: clientRestaurantId ?? this.clientRestaurantId,
      requestId: requestId ?? this.requestId,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      logs: logs ?? this.logs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      thirdpartyUserList: thirdpartyUserList ?? this.thirdpartyUserList,
    );
  }
}

/// ViewModel for Menu Trigger Logs page
@riverpod
class MenuTriggerLogsViewModel extends _$MenuTriggerLogsViewModel {
  late StoreRepository _storeRepo;
  late IntegrationRepository _integrationRepo;

  @override
  MenuTriggerLogsState build() {
    _storeRepo = ref.watch(storeRepositoryProvider);
    _integrationRepo = ref.watch(integrationRepositoryProvider);
    _loadInitialData();
    return const MenuTriggerLogsState();
  }

  Future<void> _loadInitialData() async {
    state = state.copyWith(isLoading: true);
    final storesResult = await _storeRepo.getAccessibleStores();
    storesResult.fold(
      (failure) =>
          state = state.copyWith(error: failure.message, isLoading: false),
      (stores) => state = state.copyWith(stores: stores, isLoading: false),
    );

    // Load aggregators for thirdparty user dropdown
    final aggResult = await _integrationRepo.getAggregators();
    aggResult.fold((failure) => {}, (aggregators) {
      final names = [
        'Select Thirdparty User',
        ...aggregators.map((a) => a.name),
      ];
      state = state.copyWith(thirdpartyUserList: names);
    });
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

  void setSelectedRestaurant(String restaurant) {
    if (restaurant == 'Please Select') {
      state = state.copyWith(selectedRestaurantId: null);
    } else {
      // Extract ID from "ID - Name" format
      final idPart = restaurant.split(' - ').firstOrNull;
      state = state.copyWith(selectedRestaurantId: idPart);
    }
  }

  void setFromDate(DateTime? date) {
    state = state.copyWith(fromDate: date);
  }

  void setToDate(DateTime? date) {
    state = state.copyWith(toDate: date);
  }

  void setSelectedThirdpartyUser(String user) {
    state = state.copyWith(selectedThirdpartyUser: user);
  }

  void setClientRestaurantId(String id) {
    state = state.copyWith(clientRestaurantId: id);
  }

  void setRequestId(String id) {
    state = state.copyWith(requestId: id);
  }

  void setSelectedStatus(String status) {
    state = state.copyWith(selectedStatus: status);
  }

  Future<void> search() async {
    state = state.copyWith(isLoading: true, error: null);

    final storeId = state.selectedRestaurantId ?? state.selectedStoreId;
    if (storeId == null) {
      state = state.copyWith(logs: [], isLoading: false);
      return;
    }

    final result = await _integrationRepo.getMenuTriggerLogs(storeId);
    result.fold(
      (failure) => state = state.copyWith(
        logs: [],
        isLoading: false,
        error: failure.message,
      ),
      (logEntries) {
        final logMaps = logEntries
            .map(
              (l) => {
                'id': l.id,
                'storeId': l.storeId,
                'aggregatorId': l.aggregatorId,
                'logType': l.logType,
                'status': l.status,
                'message': l.errorMessage ?? '',
                'createdAt': l.createdAt.toIso8601String(),
              },
            )
            .toList();
        state = state.copyWith(logs: logMaps, isLoading: false);
      },
    );
  }

  void reset() {
    state = state.copyWith(
      selectedRestaurantId: null,
      fromDate: null,
      toDate: null,
      selectedThirdpartyUser: 'Select Thirdparty User',
      clientRestaurantId: '',
      requestId: '',
      selectedStatus: 'All',
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
