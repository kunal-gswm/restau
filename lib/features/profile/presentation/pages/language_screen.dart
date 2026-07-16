import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../core/utils/app_translations.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(settingsProvider).locale;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(AppTranslations.tr(locale, 'Language'))),
      body: ListView(
        padding: AppSpacing.screenAll,
        children: [
          _buildLanguageOption(context, ref, locale, const Locale('en', 'US'), 'English', 'English (US)'),
          const SizedBox(height: AppSpacing.sm),
          _buildLanguageOption(context, ref, locale, const Locale('hi', 'IN'), 'Hindi', 'हिन्दी'),
          const SizedBox(height: AppSpacing.sm),
          _buildLanguageOption(context, ref, locale, const Locale('es', 'ES'), 'Spanish', 'Español'),
          const SizedBox(height: AppSpacing.sm),
          _buildLanguageOption(context, ref, locale, const Locale('fr', 'FR'), 'French', 'Français'),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    WidgetRef ref,
    Locale currentLocale,
    Locale value,
    String language,
    String subtitle,
  ) {
    final isSelected = currentLocale.languageCode == value.languageCode;
    return Card(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.borderRadiusMd,
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: RadioListTile<Locale>(
        title: Text(language, style: AppTypography.subtitle2(isSelected ? AppColors.primary : AppColors.textPrimary)),
        subtitle: Text(subtitle, style: AppTypography.body2(AppColors.textSecondary)),
        value: value,
        // ignore: deprecated_member_use
        groupValue: currentLocale,
        activeColor: AppColors.primary,
        // ignore: deprecated_member_use
        onChanged: (val) {
          if (val != null) {
            ref.read(settingsProvider.notifier).updateLocale(val);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Language changed to $language ($subtitle)'),
                backgroundColor: AppColors.success,
                duration: const Duration(seconds: 1),
              ),
            );
          }
        },
      ),
    );
  }
}
