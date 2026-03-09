import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pos_app/core/providers/store_provider.dart';
import 'package:pos_app/core/providers/repository_providers.dart';
import 'package:pos_app/core/repositories/store_repository.dart';
import 'package:pos_app/core/repositories/integration_repository.dart';

part 'online_item_logs_viewmodel.g.dart';

/// State class for Online Item Logs
class OnlineItemLogsState {
  final String? selectedStoreId;
  final List<StoreModel> stores;
  final bool isSearchExpanded;
  final Set<String> selectedRestaurants;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String searchItemIdName;
  final String selectedOutletFilter;
  final List<Map<String, dynamic>> logs;
  final bool isLoading;
  final String? error;

  const OnlineItemLogsState({
    this.selectedStoreId,
    this.stores = const [],
    this.isSearchExpanded = true,
    this.selectedRestaurants = const {},
    this.fromDate,
    this.toDate,
    this.searchItemIdName = '',
    this.selectedOutletFilter = 'Select Outlet',
    this.logs = const [],
    this.isLoading = false,
    this.error,
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

  /// Outlets list for filter dropdown
  List<String> get outlets => ['Select Outlet', ...stores.map((s) => s.name)];

  /// Restaurants derived from stores with ID prefix
  List<String> get restaurants => [
    'Please Select',
    ...stores.map((s) => '${s.id} - ${s.name}'),
  ];

  bool get isAllRestaurantsSelected => selectedRestaurants.isEmpty;

  String get restaurantDisplayText {
    if (selectedRestaurants.isEmpty) return 'All';
    if (selectedRestaurants.length == 1) return selectedRestaurants.first;
    return '${selectedRestaurants.length} restaurants selected';
  }

  OnlineItemLogsState copyWith({
    String? selectedStoreId,
    List<StoreModel>? stores,
    bool? isSearchExpanded,
    Set<String>? selectedRestaurants,
    DateTime? fromDate,
    DateTime? toDate,
    String? searchItemIdName,
    String? selectedOutletFilter,
    List<Map<String, dynamic>>? logs,
    bool? isLoading,
    String? error,
  }) {
    return OnlineItemLogsState(
      selectedStoreId: selectedStoreId ?? this.selectedStoreId,
      stores: stores ?? this.stores,
      isSearchExpanded: isSearchExpanded ?? this.isSearchExpanded,
      selectedRestaurants: selectedRestaurants ?? this.selectedRestaurants,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      searchItemIdName: searchItemIdName ?? this.searchItemIdName,
      selectedOutletFilter: selectedOutletFilter ?? this.selectedOutletFilter,
      logs: logs ?? this.logs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// ViewModel for Online Item On/Off Logs page
@riverpod
class OnlineItemLogsViewModel extends _$OnlineItemLogsViewModel {
  late IntegrationRepository _integrationRepo;

  @override
  OnlineItemLogsState build() {
    _integrationRepo = ref.watch(integrationRepositoryProvider);
    // Watch global store provider for store list and selection
    final storeState = ref.watch(globalStoreNotifierProvider);

    final now = DateTime.now();
    return OnlineItemLogsState(
      fromDate: now,
      toDate: now,
      stores: storeState.stores,
      selectedStoreId: storeState.selectedStoreId,
    );
  }

  void setSelectedOutlet(String outletName) {
    ref
        .read(globalStoreNotifierProvider.notifier)
        .setSelectedOutlet(outletName);
  }

  void toggleSearchExpanded() {
    state = state.copyWith(isSearchExpanded: !state.isSearchExpanded);
  }

  void toggleAllRestaurants() {
    if (state.selectedRestaurants.isEmpty) {
      final allRestaurants = state.restaurants
          .where((r) => r != 'Please Select')
          .toSet();
      state = state.copyWith(selectedRestaurants: allRestaurants);
    } else {
      state = state.copyWith(selectedRestaurants: {});
    }
  }

  void toggleRestaurant(String restaurant) {
    final updated = Set<String>.from(state.selectedRestaurants);
    if (updated.contains(restaurant)) {
      updated.remove(restaurant);
    } else {
      updated.add(restaurant);
    }
    state = state.copyWith(selectedRestaurants: updated);
  }

  void setFromDate(DateTime? date) {
    state = state.copyWith(fromDate: date);
  }

  void setToDate(DateTime? date) {
    state = state.copyWith(toDate: date);
  }

  void setSelectedOutletFilter(String outlet) {
    state = state.copyWith(selectedOutletFilter: outlet);
  }

  void setSearchItemIdName(String value) {
    state = state.copyWith(searchItemIdName: value);
  }

  Future<void> search() async {
    state = state.copyWith(isLoading: true, error: null);

    final storeId = state.selectedStoreId;
    if (storeId == null) {
      state = state.copyWith(logs: [], isLoading: false);
      return;
    }

    final result = await _integrationRepo.getItemLogs(storeId);
    result.fold(
      (failure) =>
          state = state.copyWith(error: failure.message, isLoading: false),
      (logList) {
        final logMaps = logList
            .map(
              (log) => {
                'id': log.id,
                'storeId': log.storeId,
                'aggregatorId': log.aggregatorId,
                'logType': log.logType,
                'status': log.status,
                'message': log.errorMessage ?? '',
                'createdAt': log.createdAt.toIso8601String(),
              },
            )
            .toList();
        state = state.copyWith(logs: logMaps, isLoading: false);
      },
    );
  }

  void reset() {
    final now = DateTime.now();
    state = state.copyWith(
      selectedRestaurants: {},
      fromDate: now,
      toDate: now,
      selectedOutletFilter: 'Select Outlet',
      searchItemIdName: '',
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
