import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pos_app/core/providers/repository_providers.dart';
import 'package:pos_app/core/repositories/store_repository.dart';
import 'package:pos_app/core/repositories/integration_repository.dart';

part 'thirdparty_config_viewmodel.g.dart';

/// State for the Third-Party Configuration screen
class ThirdPartyConfigState {
  final String? selectedStoreId;
  final List<StoreModel> stores;
  final List<AggregatorConfigModel> aggregators;
  final List<AggregatorStoreLinkModel> storeLinks;
  final String? error;

  const ThirdPartyConfigState({
    this.selectedStoreId,
    this.stores = const [],
    this.aggregators = const [],
    this.storeLinks = const [],
    this.error,
  });

  ThirdPartyConfigState copyWith({
    String? selectedStoreId,
    List<StoreModel>? stores,
    List<AggregatorConfigModel>? aggregators,
    List<AggregatorStoreLinkModel>? storeLinks,
    String? error,
  }) {
    return ThirdPartyConfigState(
      selectedStoreId: selectedStoreId ?? this.selectedStoreId,
      stores: stores ?? this.stores,
      aggregators: aggregators ?? this.aggregators,
      storeLinks: storeLinks ?? this.storeLinks,
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
  late IntegrationRepository _integrationRepo;

  @override
  ThirdPartyConfigState build() {
    _storeRepo = ref.watch(storeRepositoryProvider);
    _integrationRepo = ref.watch(integrationRepositoryProvider);
    _loadInitialData();
    return const ThirdPartyConfigState();
  }

  Future<void> _loadInitialData() async {
    final storesResult = await _storeRepo.getAccessibleStores();
    storesResult.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (stores) => state = state.copyWith(stores: stores),
    );

    // Load aggregator configs
    final aggResult = await _integrationRepo.getAggregators();
    aggResult.fold(
      (failure) => {},
      (aggregators) => state = state.copyWith(aggregators: aggregators),
    );

    // Load store links for selected store
    if (state.selectedStoreId != null) {
      await _loadStoreLinks(state.selectedStoreId!);
    }
  }

  Future<void> _loadStoreLinks(String storeId) async {
    final linksResult = await _integrationRepo.getStoreLinks(storeId);
    linksResult.fold(
      (failure) => {},
      (links) => state = state.copyWith(storeLinks: links),
    );
  }

  void setSelectedOutlet(String outletName) {
    if (outletName == 'All Outlets') {
      state = state.copyWith(selectedStoreId: null, storeLinks: []);
    } else {
      final store = state.stores.where((s) => s.name == outletName).firstOrNull;
      state = state.copyWith(selectedStoreId: store?.id);
      if (store != null) {
        _loadStoreLinks(store.id);
      }
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
