import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pos_app/core/providers/repository_providers.dart';
import 'package:pos_app/core/repositories/store_repository.dart';

part 'thirdparty_config_viewmodel.g.dart';

/// State for the Third-Party Configuration screen
class ThirdPartyConfigState {
  final String? selectedStoreId;
  final List<StoreModel> stores;
  final String? error;

  const ThirdPartyConfigState({
    this.selectedStoreId,
    this.stores = const [],
    this.error,
  });

  ThirdPartyConfigState copyWith({
    String? selectedStoreId,
    List<StoreModel>? stores,
    String? error,
  }) {
    return ThirdPartyConfigState(
      selectedStoreId: selectedStoreId ?? this.selectedStoreId,
      stores: stores ?? this.stores,
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

  /// Alias for selectedOutletName
  String get selectedOutlet => selectedOutletName;
}

/// ViewModel for the Third-Party Configuration screen using Riverpod
@riverpod
class ThirdPartyConfigViewModel extends _$ThirdPartyConfigViewModel {
  late StoreRepository _storeRepo;

  @override
  ThirdPartyConfigState build() {
    _storeRepo = ref.watch(storeRepositoryProvider);
    _loadInitialData();
    return const ThirdPartyConfigState();
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

  void clearError() {
    state = state.copyWith(error: null);
  }
}
