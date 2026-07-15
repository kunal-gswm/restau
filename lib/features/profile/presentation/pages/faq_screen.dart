import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('FAQ & Help')),
      body: ListView(
        padding: AppSpacing.screenAll,
        children: [
          _buildFaqItem('How do I track my order?', 'You can track your order from the order history section in your profile.'),
          _buildFaqItem('What are your delivery hours?', 'We deliver from 10:00 AM to 11:00 PM every day.'),
          _buildFaqItem('How do I apply a promo code?', 'Promo codes can be applied in the cart screen before checkout.'),
          _buildFaqItem('How does the loyalty program work?', 'You earn 1 point for every ₹1 spent. Points can be redeemed for rewards.'),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: AppTypography.subtitle2(AppColors.textPrimary)),
      childrenPadding: const EdgeInsets.only(left: AppSpacing.md, right: AppSpacing.md, bottom: AppSpacing.md),
      children: [
        Text(answer, style: AppTypography.body2(AppColors.textSecondary)),
      ],
    );
  }
}
