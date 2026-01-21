/// Base failure class for error handling across the app
class Failure {
  final String message;
  final String? code;
  final dynamic originalError;

  const Failure({required this.message, this.code, this.originalError});

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

/// Database-specific failure
class DatabaseFailure extends Failure {
  const DatabaseFailure({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// Network-specific failure
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// Auth-specific failure
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code, super.originalError});
}
