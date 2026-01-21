import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pos_app/core/config/google_auth_config.dart';

/// Failure class for error handling
class Failure {
  final String message;
  const Failure({required this.message});
}

/// Auth repository interface
abstract class AuthRepository {
  Future<Either<Failure, User>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> signUpWithEmail({
    required String email,
    required String password,
    String? fullName,
  });

  Future<Either<Failure, User>> signInWithGoogle();

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, void>> resetPassword({required String email});

  User? get currentUser;
}

/// Auth repository implementation with Supabase
class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _client;

  AuthRepositoryImpl(this._client);

  @override
  Future<Either<Failure, User>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return left(const Failure(message: 'Login failed. Please try again.'));
      }

      return right(response.user!);
    } on AuthException catch (e) {
      return left(Failure(message: e.message));
    } catch (e) {
      return left(Failure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmail({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: fullName != null ? {'full_name': fullName} : null,
      );

      if (response.user == null) {
        return left(
          const Failure(message: 'Sign up failed. Please try again.'),
        );
      }

      return right(response.user!);
    } on AuthException catch (e) {
      return left(Failure(message: e.message));
    } catch (e) {
      return left(Failure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _client.auth.signOut();
      return right(null);
    } on AuthException catch (e) {
      return left(Failure(message: e.message));
    } catch (e) {
      return left(Failure(message: 'Failed to sign out: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      return right(null);
    } on AuthException catch (e) {
      return left(Failure(message: e.message));
    } catch (e) {
      return left(Failure(message: 'Failed to send reset email: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn.instance;

      // Initialize Google Sign-In
      await googleSignIn.initialize(
        serverClientId: GoogleAuthConfig.webClientId,
        clientId: GoogleAuthConfig.iosClientId,
      );

      // Attempt lightweight authentication first (uses existing session if available)
      GoogleSignInAccount? googleUser;
      try {
        googleUser = await googleSignIn.attemptLightweightAuthentication();
      } catch (_) {
        // Lightweight auth failed, will try full authentication
      }

      // If no existing session, trigger full authentication flow
      if (googleUser == null) {
        if (googleSignIn.supportsAuthenticate()) {
          googleUser = await googleSignIn.authenticate(
            scopeHint: GoogleAuthConfig.scopes,
          );
        } else {
          return left(
            const Failure(
              message: 'Google sign-in not supported on this platform.',
            ),
          );
        }
      }

      final idToken = googleUser.authentication.idToken;

      if (idToken == null) {
        return left(const Failure(message: 'No ID Token found from Google.'));
      }

      // Request authorization for the required scopes to get access token
      final authorization =
          await googleUser.authorizationClient.authorizationForScopes(
            GoogleAuthConfig.scopes,
          ) ??
          await googleUser.authorizationClient.authorizeScopes(
            GoogleAuthConfig.scopes,
          );

      // Sign in to Supabase with the Google ID token
      final response = await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: authorization.accessToken,
      );

      if (response.user == null) {
        return left(
          const Failure(
            message: 'Failed to sign in with Google. Please try again.',
          ),
        );
      }

      return right(response.user!);
    } on GoogleSignInException catch (e) {
      // Handle Google Sign-In specific exceptions
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return left(const Failure(message: 'Google sign-in was cancelled.'));
      }
      return left(Failure(message: e.description ?? 'Google sign-in failed.'));
    } on AuthException catch (e) {
      return left(Failure(message: e.message));
    } catch (e) {
      return left(Failure(message: 'Google sign-in failed: $e'));
    }
  }

  @override
  User? get currentUser => _client.auth.currentUser;
}
