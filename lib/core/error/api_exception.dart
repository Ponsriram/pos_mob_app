import 'package:pos_app/core/error/failure.dart';

/// Exception for API errors from the FastAPI backend.
class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Converts an ApiException to a Failure.
Failure apiFailure(ApiException e) {
  return NetworkFailure(
    message: e.message,
    code: e.statusCode.toString(),
    originalError: e,
  );
}
