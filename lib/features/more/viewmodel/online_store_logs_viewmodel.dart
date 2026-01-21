import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/repositories/store_repository.dart';
import '../../../core/providers/repository_providers.dart';

part 'online_store_logs_viewmodel.g.dart';

/// State class for Online Store Logs
class OnlineStoreLogsState {
  final String selectedOutlet;
  final List<String> availableOutlets;
  final bool isSearchExpanded;
  final List<String> restaurants;
  final Set<String> selectedRestaurants;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String selectedOutletFilter;
  final List<String> outlets;
  final List<Map<String, dynamic>> logs;
  final bool isLoading;
  final String? error;

  const OnlineStoreLogsState({
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

  OnlineStoreLogsState copyWith({
    String? selectedOutlet,
    List<String>? availableOutlets,
    bool? isSearchExpanded,
    List<String>? restaurants,
    Set<String>? selectedRestaurants,
    DateTime? fromDate,
    DateTime? toDate,
    String? selectedOutletFilter,
    List<String>? outlets,
    List<Map<String, dynamic>>? logs,
    bool? isLoading,
    String? error,
  }) {
    return OnlineStoreLogsState(
      selectedOutlet: selectedOutlet ?? this.selectedOutlet,
      availableOutlets: availableOutlets ?? this.availableOutlets,
      isSearchExpanded: isSearchExpanded ?? this.isSearchExpanded,
      restaurants: restaurants ?? this.restaurants,
      selectedRestaurants: selectedRestaurants ?? this.selectedRestaurants,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      selectedOutletFilter: selectedOutletFilter ?? this.selectedOutletFilter,
      outlets: outlets ?? this.outlets,
      logs: logs ?? this.logs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// ViewModel for Online Store Logs page
@riverpod
class OnlineStoreLogsViewModel extends _$OnlineStoreLogsViewModel {
  late final StoreRepository _storeRepo;

  @override
  OnlineStoreLogsState build() {
    _storeRepo = ref.watch(storeRepositoryProvider);
    final now = DateTime.now();
    return OnlineStoreLogsState(fromDate: now, toDate: now);
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
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
