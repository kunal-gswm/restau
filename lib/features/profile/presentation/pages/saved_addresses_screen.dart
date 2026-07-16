import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/user_providers.dart';

class SavedAddressesScreen extends ConsumerWidget {
  const SavedAddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Saved Addresses')),
      body: ListView.builder(
        padding: AppSpacing.screenAll,
        itemCount: user.addresses.length,
        itemBuilder: (context, index) {
          final address = user.addresses[index];
          return Card(
            color: AppColors.surface,
            elevation: 0,
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadii.borderRadiusMd,
              side: const BorderSide(color: AppColors.border),
            ),
            child: ListTile(
              leading: Icon(address.isDefault ? Icons.star : Icons.location_on, color: AppColors.primary),
              title: Text(address.title, style: AppTypography.subtitle2(AppColors.textPrimary)),
              subtitle: Text(address.fullAddress, style: AppTypography.body2(AppColors.textSecondary)),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: AppColors.textTertiary),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Address editing coming soon'), duration: Duration(seconds: 2)),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Add new address coming soon'), duration: Duration(seconds: 2)),
        ),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.textOnPrimary),
      ),
    );
  }
}
