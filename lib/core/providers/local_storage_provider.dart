import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pos_app/core/models/app_user.dart';

/// Provider for SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main.dart');
});

/// Local storage service for persisting app data
class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  // Keys
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyLastLoginAt = 'last_login_at';
  static const String _keySelectedOutletId = 'selected_outlet_id';
  static const String _keyCurrentUserJson = 'current_user_json';

  // Auth methods
  Future<void> saveAuthSession({
    required String userId,
    required String? email,
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _prefs.setBool(_keyIsLoggedIn, true),
      _prefs.setString(_keyUserId, userId),
      if (email != null) _prefs.setString(_keyUserEmail, email),
      _prefs.setString(_keyAccessToken, accessToken),
      _prefs.setString(_keyRefreshToken, refreshToken),
      _prefs.setString(_keyLastLoginAt, DateTime.now().toIso8601String()),
    ]);
  }

  Future<void> clearAuthSession() async {
    await Future.wait([
      _prefs.remove(_keyIsLoggedIn),
      _prefs.remove(_keyUserId),
      _prefs.remove(_keyUserEmail),
      _prefs.remove(_keyAccessToken),
      _prefs.remove(_keyRefreshToken),
      _prefs.remove(_keyLastLoginAt),
      _prefs.remove(_keyCurrentUserJson),
    ]);
  }

  bool get isLoggedIn => _prefs.getBool(_keyIsLoggedIn) ?? false;
  String? get userId => _prefs.getString(_keyUserId);
  String? get userEmail => _prefs.getString(_keyUserEmail);
  String? get accessToken => _prefs.getString(_keyAccessToken);
  String? get refreshToken => _prefs.getString(_keyRefreshToken);
  DateTime? get lastLoginAt {
    final str = _prefs.getString(_keyLastLoginAt);
    return str != null ? DateTime.tryParse(str) : null;
  }

  // Current user persistence
  Future<void> saveCurrentUser(AppUser user) async {
    await _prefs.setString(_keyCurrentUserJson, jsonEncode(user.toJson()));
  }

  AppUser? get currentUser {
    final json = _prefs.getString(_keyCurrentUserJson);
    if (json == null) return null;
    return AppUser.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  // Outlet selection
  Future<void> saveSelectedOutletId(String? outletId) async {
    if (outletId != null) {
      await _prefs.setString(_keySelectedOutletId, outletId);
    } else {
      await _prefs.remove(_keySelectedOutletId);
    }
  }

  String? get selectedOutletId => _prefs.getString(_keySelectedOutletId);

  // Generic methods for other use cases
  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);
  String? getString(String key) => _prefs.getString(key);

  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);
  bool? getBool(String key) => _prefs.getBool(key);

  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);
  int? getInt(String key) => _prefs.getInt(key);

  Future<bool> remove(String key) => _prefs.remove(key);
  Future<bool> clear() => _prefs.clear();
}

/// Provider for LocalStorageService
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalStorageService(prefs);
});
