import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/settings_provider.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(settingsProvider).locale;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Language')),
      body: ListView(
        padding: AppSpacing.screenAll,
        children: [
          _buildLanguageOption(context, ref, locale, const Locale('en', 'US'), 'English', 'English (US)'),
          _buildLanguageOption(context, ref, locale, const Locale('hi', 'IN'), 'Hindi', 'हिन्दी'),
          _buildLanguageOption(context, ref, locale, const Locale('es', 'ES'), 'Spanish', 'Español'),
          _buildLanguageOption(context, ref, locale, const Locale('fr', 'FR'), 'French', 'Français'),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, WidgetRef ref, Locale currentLocale, Locale value, String language, String subtitle) {
    return RadioListTile<Locale>(
      title: Text(language, style: AppTypography.subtitle2(AppColors.textPrimary)),
      subtitle: Text(subtitle, style: AppTypography.body2(AppColors.textSecondary)),
      value: value,
      groupValue: currentLocale,
      activeColor: AppColors.primary,
      onChanged: (val) {
        if (val != null) {
          ref.read(settingsProvider.notifier).updateLocale(val);
        }
      },
    );
  }
}
