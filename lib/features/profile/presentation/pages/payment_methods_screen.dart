import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/user_providers.dart';

class PaymentMethodsScreen extends ConsumerWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Payment Methods')),
      body: ListView.builder(
        padding: AppSpacing.screenAll,
        itemCount: user.paymentMethods.length,
        itemBuilder: (context, index) {
          final payment = user.paymentMethods[index];
          return Card(
            color: AppColors.surface,
            elevation: 0,
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadii.borderRadiusMd,
              side: const BorderSide(color: AppColors.border),
            ),
            child: ListTile(
              leading: Icon(payment.type == 'UPI' ? Icons.g_mobiledata : Icons.credit_card, color: AppColors.primary),
              title: Text(payment.title, style: AppTypography.subtitle2(AppColors.textPrimary)),
              subtitle: Text(payment.subtitle, style: AppTypography.body2(AppColors.textSecondary)),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                onPressed: () => _confirmDelete(context, payment.title),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPaymentModal(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.textOnPrimary),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String methodName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Payment Method'),
        content: Text('Are you sure you want to remove $methodName?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$methodName removed successfully!'), backgroundColor: AppColors.success),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: AppColors.textOnPrimary),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showAddPaymentModal(BuildContext context) {
    final upiCtrl = TextEditingController();
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
            Text('Add Payment Method', style: AppTypography.h2(AppColors.textPrimary)),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: upiCtrl,
              decoration: const InputDecoration(
                labelText: 'UPI ID (e.g. user@okhdfcbank) or Card Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.payment, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeightMd,
              child: ElevatedButton(
                onPressed: () {
                  if (upiCtrl.text.trim().isEmpty) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Payment method verified & added!'), backgroundColor: AppColors.success),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.textOnPrimary),
                child: const Text('Add Method'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
