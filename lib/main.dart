import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pos_app/features/onboarding/view/pages/login_page.dart';
import 'package:pos_app/features/dashboard/view/pages/dashboard_page.dart';
import 'package:pos_app/core/providers/theme_provider.dart';
import 'package:pos_app/core/providers/local_storage_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize SharedPreferences for local storage
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeModeNotifierProvider);

    return MaterialApp(
      title: 'POS APP',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
    );
  }
}

/// Wrapper widget that checks authentication state and shows appropriate screen
class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({super.key});

  @override
  ConsumerState<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  bool _isLoading = true;
  bool _isAuthenticated = false;
  bool _isRoleValid = false;
  String? _roleError;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    try {
      final localStorage = ref.read(localStorageServiceProvider);
      final token = localStorage.accessToken;

      if (token != null && token.isNotEmpty) {
        // We have a stored JWT — check if user has valid role
        final user = localStorage.currentUser;
        final roleValid = user != null && user.isOwnerOrAdmin;

        setState(() {
          _isAuthenticated = true;
          _isRoleValid = roleValid;
          _isLoading = false;
          if (!roleValid) {
            _roleError =
                'Access Denied: This app is only for store owners and administrators.';
          }
        });
      } else {
        setState(() {
          _isAuthenticated = false;
          _isRoleValid = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isAuthenticated = false;
        _isRoleValid = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Loading...',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show error page if authenticated but role is invalid
    if (_isAuthenticated && !_isRoleValid && _roleError != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 80,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 24),
                Text(
                  'Access Denied',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _roleError!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Please use the web POS for billing operations.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () async {
                    final localStorage = ref.read(localStorageServiceProvider);
                    await localStorage.clearAuthSession();
                    if (mounted) {
                      setState(() {
                        _isAuthenticated = false;
                        _isRoleValid = false;
                        _roleError = null;
                      });
                    }
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Back to Login'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return _isAuthenticated && _isRoleValid
        ? const DashboardPage()
        : const LoginPage();
  }
}
