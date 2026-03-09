import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pos_app/core/providers/repository_providers.dart';
import 'package:pos_app/core/repositories/store_repository.dart';
import 'package:pos_app/core/repositories/zone_repository.dart';

part 'zone_viewmodel.g.dart';

/// State class for Zone management
class ZoneState {
  final String? selectedStoreId;
  final List<StoreModel> stores;
  final bool isLoading;
  final String? error;

  const ZoneState({
    this.selectedStoreId,
    this.stores = const [],
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

  /// Get restaurants as list of maps for zone selection
  List<Map<String, dynamic>> get restaurants => stores
      .map(
        (s) => {
          'id': s.id,
          'name': s.name,
          'subOrderType': '',
          'state': s.state ?? '',
          'city': s.city ?? '',
          'presentInZone': false,
        },
      )
      .toList();

  ZoneState copyWith({
    String? selectedStoreId,
    List<StoreModel>? stores,
    bool? isLoading,
    String? error,
  }) {
    return ZoneState(
      selectedStoreId: selectedStoreId ?? this.selectedStoreId,
      stores: stores ?? this.stores,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// ViewModel for Zone management
@riverpod
class ZoneViewModel extends _$ZoneViewModel {
  late StoreRepository _storeRepo;
  late ZoneRepository _zoneRepo;

  @override
  ZoneState build() {
    _storeRepo = ref.watch(storeRepositoryProvider);
    _zoneRepo = ref.watch(zoneRepositoryProvider);
    return const ZoneState();
  }

  Future<void> loadStores() async {
    state = state.copyWith(isLoading: true);
    final storesResult = await _storeRepo.getAccessibleStores();
    storesResult.fold(
      (failure) =>
          state = state.copyWith(error: failure.message, isLoading: false),
      (stores) => state = state.copyWith(stores: stores, isLoading: false),
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

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<void> createZone(Map<String, dynamic> zoneData) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _zoneRepo.createZone(zoneData);
    result.fold(
      (failure) =>
          state = state.copyWith(error: failure.message, isLoading: false),
      (_) => state = state.copyWith(isLoading: false),
    );
  }

  Future<void> updateZone(String id, Map<String, dynamic> zoneData) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _zoneRepo.updateZone(id, zoneData);
    result.fold(
      (failure) =>
          state = state.copyWith(error: failure.message, isLoading: false),
      (_) => state = state.copyWith(isLoading: false),
    );
  }
}
