import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/settings_provider.dart';

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(settingsProvider).themeMode;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Appearance')),
      body: ListView(
        padding: AppSpacing.screenAll,
        children: [
          _buildThemeOption(context, ref, themeMode, ThemeMode.system, 'System', 'Match system settings'),
          _buildThemeOption(context, ref, themeMode, ThemeMode.light, 'Light', 'Always light theme'),
          _buildThemeOption(context, ref, themeMode, ThemeMode.dark, 'Dark', 'Always dark theme'),
        ],
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context, WidgetRef ref, ThemeMode currentMode, ThemeMode value, String title, String subtitle) {
    return RadioListTile<ThemeMode>(
      title: Text(title, style: AppTypography.subtitle2(AppColors.textPrimary)),
      subtitle: Text(subtitle, style: AppTypography.body2(AppColors.textSecondary)),
      value: value,
      groupValue: currentMode,
      activeColor: AppColors.primary,
      onChanged: (val) {
        if (val != null) {
          ref.read(settingsProvider.notifier).updateTheme(val);
        }
      },
    );
  }
}
