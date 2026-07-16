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
                onPressed: () => _showAddressModal(context, title: address.title, fullAddress: address.fullAddress),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddressModal(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.textOnPrimary),
      ),
    );
  }

  void _showAddressModal(BuildContext context, {String? title, String? fullAddress}) {
    final titleCtrl = TextEditingController(text: title ?? '');
    final addrCtrl = TextEditingController(text: fullAddress ?? '');
    final isEditing = title != null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xxl))),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isEditing ? 'Edit Address' : 'Add New Address', style: AppTypography.h2(AppColors.textPrimary)),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Address Label (e.g. Home, Office)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: addrCtrl,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Full Address & Landmark', border: OutlineInputBorder()),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeightMd,
              child: ElevatedButton(
                onPressed: () {
                  if (titleCtrl.text.trim().isEmpty || addrCtrl.text.trim().isEmpty) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isEditing ? 'Address updated successfully!' : 'New address saved!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.textOnPrimary),
                child: Text(isEditing ? 'Save Changes' : 'Add Address'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
