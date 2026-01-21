import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pos_app/core/providers/repository_providers.dart';
import 'package:pos_app/core/repositories/store_repository.dart';
import '../model/user_info_model.dart';

part 'user_info_viewmodel.g.dart';

/// State for User Info page
class UserInfoState {
  final String? selectedStoreId;
  final List<StoreModel> stores;
  final UserInfoModel userInfo;
  final List<UserLogEntry> logs;
  final bool isLoading;
  final String? error;

  UserInfoState({
    this.selectedStoreId,
    this.stores = const [],
    UserInfoModel? userInfo,
    this.logs = const [],
    this.isLoading = false,
    this.error,
  }) : userInfo = userInfo ?? _defaultUserInfo;

  static final UserInfoModel _defaultUserInfo = UserInfoModel(
    id: '1',
    name: 'Balaji',
    email: 'aarthysweetsandbakery@gmail.com',
    isEmailVerified: true,
    mobileNumbers: [
      MobileNumber(
        id: '1',
        countryCode: '+91',
        number: '9360792743',
        isVerified: true,
      ),
    ],
    is2FAEnabled: true,
    createdAt: DateTime(2025, 1, 13, 14, 7, 20),
    createdBy: 'Parmy Doshi',
  );

  UserInfoState copyWith({
    String? selectedStoreId,
    List<StoreModel>? stores,
    UserInfoModel? userInfo,
    List<UserLogEntry>? logs,
    bool? isLoading,
    String? error,
  }) {
    return UserInfoState(
      selectedStoreId: selectedStoreId ?? this.selectedStoreId,
      stores: stores ?? this.stores,
      userInfo: userInfo ?? this.userInfo,
      logs: logs ?? this.logs,
      isLoading: isLoading ?? this.isLoading,
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

/// ViewModel for User Info page using Riverpod
@riverpod
class UserInfoViewModel extends _$UserInfoViewModel {
  late StoreRepository _storeRepo;

  @override
  UserInfoState build() {
    _storeRepo = ref.watch(storeRepositoryProvider);

    _loadInitialData();

    return UserInfoState(
      logs: [
        UserLogEntry(
          id: '1',
          changes: 'Basic Details Updated\nPassword has been changed.',
          doneByName: 'Balaji',
          doneByEmail: 'aarthysweetsandbakery@gmail.com',
          browser: 'Chrome',
          ipAddress: '152.58.222.176',
          timestamp: DateTime(2025, 1, 20, 12, 14, 17),
        ),
        UserLogEntry(
          id: '2',
          changes: 'User Created',
          doneByName: 'Parmy Doshi',
          doneByEmail: 'parmy.doshi@petpooja.com',
          browser: 'Chrome',
          ipAddress: '14.195.74.206',
          timestamp: DateTime(2025, 1, 13, 14, 7, 20),
        ),
      ],
    );
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

  bool updateUserInfo({
    required String name,
    required String email,
    required List<MobileNumber> mobileNumbers,
  }) {
    final updatedUserInfo = state.userInfo.copyWith(
      name: name,
      email: email,
      mobileNumbers: mobileNumbers,
    );
    state = state.copyWith(userInfo: updatedUserInfo);
    return true;
  }

  void toggle2FA(bool enabled) {
    final updatedUserInfo = state.userInfo.copyWith(is2FAEnabled: enabled);
    state = state.copyWith(userInfo: updatedUserInfo);
  }

  bool changePassword(String currentPassword, String newPassword) {
    // In real implementation, call API to change password
    return true;
  }

  bool addMobileNumber(String countryCode, String number) {
    final newNumber = MobileNumber(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      countryCode: countryCode,
      number: number,
      isVerified: false,
    );

    final updatedNumbers = [...state.userInfo.mobileNumbers, newNumber];
    final updatedUserInfo = state.userInfo.copyWith(
      mobileNumbers: updatedNumbers,
    );
    state = state.copyWith(userInfo: updatedUserInfo);
    return true;
  }

  bool removeMobileNumber(String numberId) {
    final updatedNumbers = state.userInfo.mobileNumbers
        .where((n) => n.id != numberId)
        .toList();
    final updatedUserInfo = state.userInfo.copyWith(
      mobileNumbers: updatedNumbers,
    );
    state = state.copyWith(userInfo: updatedUserInfo);
    return true;
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
