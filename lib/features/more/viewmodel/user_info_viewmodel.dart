import 'package:flutter/material.dart';
import '../model/user_info_model.dart';

/// ViewModel for User Info page
class UserInfoViewModel extends ChangeNotifier {
  // Outlet management
  String _selectedOutlet = 'All Outlets';
  final List<String> _availableOutlets = [
    'All Outlets',
    'Outlet 1',
    'Outlet 2',
    'Outlet 3',
  ];

  String get selectedOutlet => _selectedOutlet;
  List<String> get availableOutlets => _availableOutlets;

  void setSelectedOutlet(String outlet) {
    _selectedOutlet = outlet;
    notifyListeners();
  }

  // User info data - initialized directly with mock data
  UserInfoModel _userInfo = UserInfoModel(
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

  UserInfoModel get userInfo => _userInfo;

  // Logs data - initialized directly with mock data
  final List<UserLogEntry> _logs = [
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
  ];

  List<UserLogEntry> get logs => _logs;

  /// Update user info
  bool updateUserInfo({
    required String name,
    required String email,
    required List<MobileNumber> mobileNumbers,
  }) {
    _userInfo = _userInfo.copyWith(
      name: name,
      email: email,
      mobileNumbers: mobileNumbers,
    );
    notifyListeners();
    return true;
  }

  /// Toggle 2FA
  void toggle2FA(bool enabled) {
    _userInfo = _userInfo.copyWith(is2FAEnabled: enabled);
    notifyListeners();
  }

  /// Change password - returns success status
  bool changePassword(String currentPassword, String newPassword) {
    // In real implementation, call API to change password
    return true;
  }

  /// Add a new mobile number
  bool addMobileNumber(String countryCode, String number) {
    final newNumber = MobileNumber(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      countryCode: countryCode,
      number: number,
      isVerified: false,
    );

    final updatedNumbers = [..._userInfo.mobileNumbers, newNumber];
    _userInfo = _userInfo.copyWith(mobileNumbers: updatedNumbers);
    notifyListeners();
    return true;
  }

  /// Remove a mobile number
  bool removeMobileNumber(String numberId) {
    final updatedNumbers = _userInfo.mobileNumbers
        .where((n) => n.id != numberId)
        .toList();
    _userInfo = _userInfo.copyWith(mobileNumbers: updatedNumbers);
    notifyListeners();
    return true;
  }
}
