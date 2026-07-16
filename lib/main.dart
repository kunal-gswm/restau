import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/theme/app_theme.dart';
import 'core/providers/settings_provider.dart';
import 'core/providers/shared_prefs_provider.dart';
import 'core/providers/auth_provider.dart';
import 'features/home/presentation/pages/home_screen.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Supabase.initialize(
    url: 'https://nspbaunbrpsuinfnysgu.supabase.co',
    publishableKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5zcGJhdW5icnBzdWluZm55c2d1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQyMTg0NTQsImV4cCI6MjA5OTc5NDQ1NH0.ZneKbfKmdjQLvBA3AlyoPjeEQsSSE4V0xFOJsQzglPg',
  );

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPrefsProvider.overrideWithValue(sharedPreferences)],
      child: const KhanaApp(),
    ),
  );
}

class KhanaApp extends ConsumerWidget {
  const KhanaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final user = ref.watch(authUserProvider);
    final isGuest = ref.watch(authControllerProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });

    return MaterialApp(
      title: 'Khana App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      locale: settings.locale,
      home: (user != null || isGuest) ? const HomeScreen() : const LoginScreen(),
    );
  }
}
