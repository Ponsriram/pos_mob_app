import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Supabase configuration
/// Values are loaded from .env file
/// Create .env file from .env.example and add your credentials
class SupabaseConfig {
  static String get url => dotenv.env['SUPABASE_URL'] ?? '';
  static String get anonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // Optional: Add more config as needed
  static const bool enableLogging = true;
}
