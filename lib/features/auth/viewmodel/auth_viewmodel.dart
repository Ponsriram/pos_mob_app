import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pos_app/core/models/app_user.dart';
import 'package:pos_app/core/providers/auth_provider.dart';
import 'package:pos_app/core/providers/local_storage_provider.dart';
import 'package:pos_app/features/auth/repository/auth_repository.dart';

part 'auth_viewmodel.g.dart';

/// Auth state
class AuthState {
  final AppUser? user;
  final bool isLoading;
  final String? error;
  final bool isRoleValid;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isRoleValid = false,
  });

  AuthState copyWith({
    AppUser? user,
    bool? isLoading,
    String? error,
    bool? isRoleValid,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isRoleValid: isRoleValid ?? this.isRoleValid,
    );
  }
}

/// Auth repository provider
@riverpod
AuthRepository authRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  final localStorage = ref.watch(localStorageServiceProvider);
  return AuthRepositoryImpl(client, localStorage);
}

/// Auth ViewModel
@riverpod
class AuthViewModel extends _$AuthViewModel {
  late final AuthRepository _repo;
  late final LocalStorageService _localStorage;

  @override
  AuthState build() {
    _repo = ref.read(authRepositoryProvider);
    _localStorage = ref.read(localStorageServiceProvider);
    final currentUser = _localStorage.currentUser;
    final isLoggedIn =
        _localStorage.isLoggedIn && _localStorage.accessToken != null;
    return AuthState(
      user: currentUser,
      isRoleValid: isLoggedIn && (currentUser?.isOwnerOrAdmin ?? false),
    );
  }

  Future<bool> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repo.signInWithEmail(
      email: email,
      password: password,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (user) {
        state = state.copyWith(
          isLoading: false,
          user: user,
          isRoleValid: user.isOwnerOrAdmin,
        );
        return true;
      },
    );
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repo.registerWithEmail(
      email: email,
      password: password,
      name: name,
      phone: phone,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (user) {
        state = state.copyWith(
          isLoading: false,
          user: user,
          isRoleValid: user.isOwnerOrAdmin,
        );
        return true;
      },
    );
  }

  Future<bool> signOut() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repo.signOut();

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (_) {
        state = const AuthState();
        return true;
      },
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
