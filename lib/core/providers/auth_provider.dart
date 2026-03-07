import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_app/core/models/app_user.dart';
import 'package:pos_app/core/network/api_client.dart';
import 'package:pos_app/core/providers/local_storage_provider.dart';

/// Provider for ApiClient instance
final apiClientProvider = Provider<ApiClient>((ref) {
  final localStorage = ref.watch(localStorageServiceProvider);
  return ApiClient(localStorage);
});

/// Provider for current authenticated user (from local storage)
final currentUserProvider = Provider<AppUser?>((ref) {
  final localStorage = ref.watch(localStorageServiceProvider);
  return localStorage.currentUser;
});

/// Provider to check if user is logged in
final isLoggedInProvider = Provider<bool>((ref) {
  final localStorage = ref.watch(localStorageServiceProvider);
  return localStorage.isLoggedIn && localStorage.accessToken != null;
});
