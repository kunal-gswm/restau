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
              trailing: const Icon(Icons.delete_outline, color: AppColors.error),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Add payment method coming soon'), duration: Duration(seconds: 2)),
        ),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.textOnPrimary),
      ),
    );
  }
}
