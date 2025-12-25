import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_app/features/onboarding/view/pages/login_page.dart';
import 'package:pos_app/core/providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
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
      home: const LoginPage(),
    );
  }
}
