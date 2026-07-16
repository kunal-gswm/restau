import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/providers/settings_provider.dart';
import 'features/splash/presentation/pages/splash_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: KhanaApp(),
    ),
  );
}

class KhanaApp extends ConsumerWidget {
  const KhanaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      title: 'Khana App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      locale: settings.locale,
      home: const SplashScreen(),
    );
  }
}
