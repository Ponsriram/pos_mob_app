import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/repositories/store_repository.dart';
import '../../../core/providers/repository_providers.dart';

part 'online_item_logs_viewmodel.g.dart';

/// State class for Online Item Logs
class OnlineItemLogsState {
  final String selectedOutlet;
  final List<String> availableOutlets;
  final bool isSearchExpanded;
  final List<String> restaurants;
  final Set<String> selectedRestaurants;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String selectedOutletFilter;
  final List<String> outlets;
  final String searchItemIdName;
  final List<Map<String, dynamic>> logs;
  final bool isLoading;
  final String? error;

  const OnlineItemLogsState({
    this.selectedOutlet = 'All Outlets',
    this.availableOutlets = const ['All Outlets', 'Outlet 1', 'Outlet 2'],
    this.isSearchExpanded = true,
    this.restaurants = const [
      'Please Select',
      '363317 - Aarthi cake Magic',
      '383514 - Ambattur Aarthi sweets and bakery',
    ],
    this.selectedRestaurants = const {},
    this.fromDate,
    this.toDate,
    this.selectedOutletFilter = 'Select Outlet',
    this.outlets = const ['Select Outlet', 'Outlet 1', 'Outlet 2', 'Outlet 3'],
    this.searchItemIdName = '',
    this.logs = const [],
    this.isLoading = false,
    this.error,
  });

  bool get isAllRestaurantsSelected => selectedRestaurants.isEmpty;

  String get restaurantDisplayText {
    if (selectedRestaurants.isEmpty) return 'All';
    if (selectedRestaurants.length == 1) return selectedRestaurants.first;
    return '${selectedRestaurants.length} restaurants selected';
  }

  OnlineItemLogsState copyWith({
    String? selectedOutlet,
    List<String>? availableOutlets,
    bool? isSearchExpanded,
    List<String>? restaurants,
    Set<String>? selectedRestaurants,
    DateTime? fromDate,
    DateTime? toDate,
    String? selectedOutletFilter,
    List<String>? outlets,
    String? searchItemIdName,
    List<Map<String, dynamic>>? logs,
    bool? isLoading,
    String? error,
  }) {
    return OnlineItemLogsState(
      selectedOutlet: selectedOutlet ?? this.selectedOutlet,
      availableOutlets: availableOutlets ?? this.availableOutlets,
      isSearchExpanded: isSearchExpanded ?? this.isSearchExpanded,
      restaurants: restaurants ?? this.restaurants,
      selectedRestaurants: selectedRestaurants ?? this.selectedRestaurants,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      selectedOutletFilter: selectedOutletFilter ?? this.selectedOutletFilter,
      outlets: outlets ?? this.outlets,
      searchItemIdName: searchItemIdName ?? this.searchItemIdName,
      logs: logs ?? this.logs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// ViewModel for Online Item On/Off Logs page
@riverpod
class OnlineItemLogsViewModel extends _$OnlineItemLogsViewModel {
  late final StoreRepository _storeRepo;

  @override
  OnlineItemLogsState build() {
    _storeRepo = ref.watch(storeRepositoryProvider);
    final now = DateTime.now();
    return OnlineItemLogsState(fromDate: now, toDate: now);
  }

  void setSelectedOutlet(String outlet) {
    state = state.copyWith(selectedOutlet: outlet);
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

    // TODO: Implement API call to search logs via repository
    await Future.delayed(const Duration(milliseconds: 500));

    state = state.copyWith(logs: [], isLoading: false);
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
