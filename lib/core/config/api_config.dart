import 'package:flutter_dotenv/flutter_dotenv.dart';

/// API configuration for the FastAPI backend.
/// Values are loaded from .env file.
class ApiConfig {
  static String get baseUrl =>
      dotenv.env['BACKEND_URL'] ?? 'http://localhost:8000';
}
