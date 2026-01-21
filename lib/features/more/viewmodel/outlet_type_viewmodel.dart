import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pos_app/core/providers/repository_providers.dart';
import 'package:pos_app/core/repositories/store_repository.dart';

part 'outlet_type_viewmodel.g.dart';

/// Model class representing an outlet/restaurant
class OutletModel {
  final String id;
  final String name;
  final String state;
  final String city;
  final String outletType;

  const OutletModel({
    required this.id,
    required this.name,
    required this.state,
    required this.city,
    required this.outletType,
  });
}

/// State for the Outlet Type screen
class OutletTypeState {
  final String? selectedStoreId;
  final List<StoreModel> stores;
  final List<OutletModel> outlets;
  final Map<String, String> selectedOutletTypes;
  final String? error;

  const OutletTypeState({
    this.selectedStoreId,
    this.stores = const [],
    this.outlets = const [],
    this.selectedOutletTypes = const {},
    this.error,
  });

  OutletTypeState copyWith({
    String? selectedStoreId,
    List<StoreModel>? stores,
    List<OutletModel>? outlets,
    Map<String, String>? selectedOutletTypes,
    String? error,
  }) {
    return OutletTypeState(
      selectedStoreId: selectedStoreId ?? this.selectedStoreId,
      stores: stores ?? this.stores,
      outlets: outlets ?? this.outlets,
      selectedOutletTypes: selectedOutletTypes ?? this.selectedOutletTypes,
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

  /// List of available outlet types
  List<String> get outletTypes => [
    'COFO - Company Owned Franchisee',
    'FOFO - Franchisee Owned Franchisee',
    'COCO - Company Owned Company Operated',
    'FOCO - Franchisee Owned Company Operated',
  ];

  /// Check if there are unsaved changes
  bool get hasUnsavedChanges {
    for (final outlet in outlets) {
      if (selectedOutletTypes[outlet.id] != outlet.outletType) {
        return true;
      }
    }
    return false;
  }
}

/// ViewModel for the Outlet Type screen using Riverpod
@riverpod
class OutletTypeViewModel extends _$OutletTypeViewModel {
  late StoreRepository _storeRepo;

  @override
  OutletTypeState build() {
    _storeRepo = ref.watch(storeRepositoryProvider);
    _loadInitialData();
    return const OutletTypeState();
  }

  Future<void> _loadInitialData() async {
    final storesResult = await _storeRepo.getAccessibleStores();
    storesResult.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (stores) => state = state.copyWith(stores: stores),
    );

    _loadOutlets();
  }

  void _loadOutlets() {
    final outlets = [
      const OutletModel(
        id: '363317',
        name: 'Aarthi cake Magic',
        state: 'Tamil Nadu',
        city: 'Chennai',
        outletType: 'COFO - Company Owned Franchisee',
      ),
      const OutletModel(
        id: '383514',
        name: 'Ambattur Aarthi sweets and bakery',
        state: 'Tamil Nadu',
        city: 'Chennai',
        outletType: 'COFO - Company Owned Franchisee',
      ),
    ];

    // Initialize selected outlet types
    final selectedOutletTypes = <String, String>{};
    for (final outlet in outlets) {
      selectedOutletTypes[outlet.id] = outlet.outletType;
    }

    state = state.copyWith(
      outlets: outlets,
      selectedOutletTypes: selectedOutletTypes,
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

  void setOutletType(String outletId, String outletType) {
    final updatedTypes = Map<String, String>.from(state.selectedOutletTypes);
    updatedTypes[outletId] = outletType;
    state = state.copyWith(selectedOutletTypes: updatedTypes);
  }

  String getSelectedOutletType(String outletId) {
    return state.selectedOutletTypes[outletId] ?? state.outletTypes.first;
  }

  void save() {
    // TODO: Implement save API call
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
