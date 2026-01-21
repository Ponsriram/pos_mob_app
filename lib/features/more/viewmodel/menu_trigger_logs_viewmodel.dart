import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/repositories/store_repository.dart';
import '../../../core/providers/repository_providers.dart';

part 'menu_trigger_logs_viewmodel.g.dart';

/// State class for Menu Trigger Logs
class MenuTriggerLogsState {
  final String selectedOutlet;
  final List<String> availableOutlets;
  final bool isSearchExpanded;
  final String selectedRestaurant;
  final List<String> restaurants;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String selectedThirdpartyUser;
  final List<String> thirdpartyUsers;
  final String clientRestaurantId;
  final String requestId;
  final String selectedStatus;
  final List<String> statuses;
  final List<Map<String, dynamic>> logs;
  final bool isLoading;
  final String? error;

  const MenuTriggerLogsState({
    this.selectedOutlet = 'All Outlets',
    this.availableOutlets = const ['All Outlets', 'Outlet 1', 'Outlet 2'],
    this.isSearchExpanded = true,
    this.selectedRestaurant = 'Please Select',
    this.restaurants = const [
      'Please Select',
      '363317 - Aarthi cake Magic',
      '383514 - Ambattur Aarthi sweets and bakery',
    ],
    this.fromDate,
    this.toDate,
    this.selectedThirdpartyUser = 'Select Thirdparty User',
    this.thirdpartyUsers = const [
      'Select Thirdparty User',
      'Swiggy',
      'PayTM',
      'Ewards Online',
      'Dineout Ordering',
      'Dotpe',
      'Dukaan',
      'Menu QR',
    ],
    this.clientRestaurantId = '',
    this.requestId = '',
    this.selectedStatus = 'All',
    this.statuses = const ['All', 'Success', 'Failed', 'In Process'],
    this.logs = const [],
    this.isLoading = false,
    this.error,
  });

  MenuTriggerLogsState copyWith({
    String? selectedOutlet,
    List<String>? availableOutlets,
    bool? isSearchExpanded,
    String? selectedRestaurant,
    List<String>? restaurants,
    DateTime? fromDate,
    DateTime? toDate,
    String? selectedThirdpartyUser,
    List<String>? thirdpartyUsers,
    String? clientRestaurantId,
    String? requestId,
    String? selectedStatus,
    List<String>? statuses,
    List<Map<String, dynamic>>? logs,
    bool? isLoading,
    String? error,
  }) {
    return MenuTriggerLogsState(
      selectedOutlet: selectedOutlet ?? this.selectedOutlet,
      availableOutlets: availableOutlets ?? this.availableOutlets,
      isSearchExpanded: isSearchExpanded ?? this.isSearchExpanded,
      selectedRestaurant: selectedRestaurant ?? this.selectedRestaurant,
      restaurants: restaurants ?? this.restaurants,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      selectedThirdpartyUser:
          selectedThirdpartyUser ?? this.selectedThirdpartyUser,
      thirdpartyUsers: thirdpartyUsers ?? this.thirdpartyUsers,
      clientRestaurantId: clientRestaurantId ?? this.clientRestaurantId,
      requestId: requestId ?? this.requestId,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      statuses: statuses ?? this.statuses,
      logs: logs ?? this.logs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// ViewModel for Menu Trigger Logs page
@riverpod
class MenuTriggerLogsViewModel extends _$MenuTriggerLogsViewModel {
  late final StoreRepository _storeRepo;

  @override
  MenuTriggerLogsState build() {
    _storeRepo = ref.watch(storeRepositoryProvider);
    return const MenuTriggerLogsState();
  }

  void setSelectedOutlet(String outlet) {
    state = state.copyWith(selectedOutlet: outlet);
  }

  void toggleSearchExpanded() {
    state = state.copyWith(isSearchExpanded: !state.isSearchExpanded);
  }

  void setSelectedRestaurant(String restaurant) {
    state = state.copyWith(selectedRestaurant: restaurant);
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

    // TODO: Implement API call to search logs via repository
    await Future.delayed(const Duration(milliseconds: 500));

    state = state.copyWith(logs: [], isLoading: false);
  }

  void reset() {
    state = state.copyWith(
      selectedRestaurant: 'Please Select',
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
