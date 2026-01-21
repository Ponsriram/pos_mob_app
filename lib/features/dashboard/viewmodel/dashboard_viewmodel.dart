import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pos_app/core/providers/repository_providers.dart';
import 'package:pos_app/core/repositories/store_repository.dart';
import 'package:pos_app/core/repositories/dashboard_repository.dart';

part 'dashboard_viewmodel.g.dart';

/// Dashboard UI state
class DashboardState {
  final DateTime selectedDate;
  final String? selectedStoreId;
  final int activeStatsTab;
  final int currentNavIndex;
  final bool isDrawerOpen;
  final DashboardStats stats;
  final List<OutletStats> outletStats;
  final List<StoreModel> stores;
  final bool isLoading;
  final String? error;

  const DashboardState({
    required this.selectedDate,
    this.selectedStoreId,
    this.activeStatsTab = 0,
    this.currentNavIndex = 0,
    this.isDrawerOpen = false,
    this.stats = DashboardStats.empty,
    this.outletStats = const [],
    this.stores = const [],
    this.isLoading = false,
    this.error,
  });

  DashboardState copyWith({
    DateTime? selectedDate,
    String? selectedStoreId,
    int? activeStatsTab,
    int? currentNavIndex,
    bool? isDrawerOpen,
    DashboardStats? stats,
    List<OutletStats>? outletStats,
    List<StoreModel>? stores,
    bool? isLoading,
    String? error,
  }) {
    return DashboardState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedStoreId: selectedStoreId ?? this.selectedStoreId,
      activeStatsTab: activeStatsTab ?? this.activeStatsTab,
      currentNavIndex: currentNavIndex ?? this.currentNavIndex,
      isDrawerOpen: isDrawerOpen ?? this.isDrawerOpen,
      stats: stats ?? this.stats,
      outletStats: outletStats ?? this.outletStats,
      stores: stores ?? this.stores,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// Get formatted date string for display
  String get formattedDate {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final day = selectedDate.day;
    final suffix = _getDaySuffix(day);
    final month = months[selectedDate.month - 1];
    return '$day$suffix $month';
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
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

  /// Stats tab labels
  List<String> get statsTabLabels => [
    'Orders',
    'Sales',
    'Net Sales',
    'Tax',
    'Discounts',
    'Modified',
    'Re-print',
  ];

  /// Get the column header based on active tab
  String get activeTabColumnHeader => statsTabLabels[activeStatsTab];
}

/// Dashboard ViewModel using Riverpod
@riverpod
class DashboardViewModel extends _$DashboardViewModel {
  late DashboardRepository _dashboardRepo;
  late StoreRepository _storeRepo;

  @override
  DashboardState build() {
    _dashboardRepo = ref.watch(dashboardRepositoryProvider);
    _storeRepo = ref.watch(storeRepositoryProvider);

    // Load initial data
    _loadInitialData();

    return DashboardState(selectedDate: DateTime.now());
  }

  Future<void> _loadInitialData() async {
    state = state.copyWith(isLoading: true, error: null);

    // Load stores
    final storesResult = await _storeRepo.getAccessibleStores();
    storesResult.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (stores) => state = state.copyWith(stores: stores),
    );

    // Load dashboard stats
    await _loadDashboardStats();

    state = state.copyWith(isLoading: false);
  }

  Future<void> _loadDashboardStats() async {
    final statsResult = await _dashboardRepo.getDashboardStats(
      storeId: state.selectedStoreId,
      date: state.selectedDate,
    );

    statsResult.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (stats) => state = state.copyWith(stats: stats),
    );

    // Load outlet stats
    final outletResult = await _dashboardRepo.getOutletStats(
      date: state.selectedDate,
    );

    outletResult.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (outletStats) => state = state.copyWith(outletStats: outletStats),
    );
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, error: null);
    await _loadDashboardStats();
    state = state.copyWith(isLoading: false);
  }

  void setSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
    _loadDashboardStats();
  }

  void setSelectedOutlet(String outletName) {
    if (outletName == 'All Outlets') {
      state = state.copyWith(selectedStoreId: null);
    } else {
      final store = state.stores.where((s) => s.name == outletName).firstOrNull;
      state = state.copyWith(selectedStoreId: store?.id);
    }
    _loadDashboardStats();
  }

  void setActiveStatsTab(int index) {
    state = state.copyWith(activeStatsTab: index);
  }

  void setCurrentNavIndex(int index) {
    state = state.copyWith(currentNavIndex: index);
  }

  void toggleDrawer() {
    state = state.copyWith(isDrawerOpen: !state.isDrawerOpen);
  }

  void openDrawer() {
    state = state.copyWith(isDrawerOpen: true);
  }

  void closeDrawer() {
    state = state.copyWith(isDrawerOpen: false);
  }

  /// Get the value for a specific outlet based on the active tab
  String getOutletValue(OutletStats outlet) {
    switch (state.activeStatsTab) {
      case 0: // Orders
        return outlet.totalOrders.toString();
      case 1: // Sales
        return outlet.totalSales.toStringAsFixed(2);
      case 2: // Net Sales
        return outlet.netSales.toStringAsFixed(2);
      case 3: // Tax (calculated as sales - net)
        return (outlet.totalSales - outlet.netSales).toStringAsFixed(2);
      case 4: // Discounts
        return '0.00'; // From actual discount field when available
      case 5: // Modified
        return '0';
      case 6: // Re-print
        return '0';
      default:
        return outlet.totalOrders.toString();
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
