import 'package:fpdart/fpdart.dart';
import 'package:pos_app/core/error/failure.dart';
import 'package:pos_app/core/error/api_exception.dart';
import 'package:pos_app/core/models/app_user.dart';
import 'package:pos_app/core/network/api_client.dart';
import 'package:pos_app/core/providers/local_storage_provider.dart';

/// Auth repository interface
abstract class AuthRepository {
  Future<Either<Failure, AppUser>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, AppUser>> registerWithEmail({
    required String email,
    required String password,
    required String name,
    String? phone,
  });

  Future<Either<Failure, void>> signOut();
}

/// FastAPI backend implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _client;
  final LocalStorageService _localStorage;

  AuthRepositoryImpl(this._client, this._localStorage);

  @override
  Future<Either<Failure, AppUser>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final accessToken = response['access_token'] as String;

      // Save token immediately so subsequent API calls are authenticated
      await _localStorage.saveAuthSession(
        userId: '',
        email: email,
        accessToken: accessToken,
        refreshToken: '',
      );

      // If the backend returns user data in the token response, use it
      if (response['user'] != null) {
        final user = AppUser.fromJson(response['user'] as Map<String, dynamic>);
        await _localStorage.saveCurrentUser(user);
        await _localStorage.saveAuthSession(
          userId: user.id,
          email: user.email,
          accessToken: accessToken,
          refreshToken: '',
        );
        return right(user);
      }

      // Construct minimal user from known info
      final user = AppUser(
        id: '',
        name: email.split('@').first,
        email: email,
        role: 'owner',
        createdAt: DateTime.now(),
      );
      await _localStorage.saveCurrentUser(user);
      return right(user);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, AppUser>> registerWithEmail({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    try {
      final response = await _client.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          if (phone != null) 'phone': phone,
          'role': 'owner',
        },
      );

      final user = AppUser.fromJson(response as Map<String, dynamic>);

      // After registration, log in to get an access token
      final loginResult = await signInWithEmail(
        email: email,
        password: password,
      );

      return loginResult.fold((failure) => left(failure), (_) => right(user));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _localStorage.clearAuthSession();
      return right(null);
    } catch (e) {
      return left(Failure(message: 'Failed to sign out: $e'));
    }
  }
}
