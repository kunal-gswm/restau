import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Loyalty summary card shown on the home screen.
///
/// Shows points balance, progress toward next reward, and a CTA.
/// This is a key pitch element — demonstrates loyalty/retention capability.
class LoyaltySummaryCard extends StatelessWidget {
  final int points;
  final VoidCallback? onTap;

  const LoyaltySummaryCard({
    super.key,
    required this.points,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppSpacing.screenH,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF8F0), Color(0xFFFFF0EE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadii.borderRadiusXl,
        boxShadow: AppElevation.medium,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadii.borderRadiusXl,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.accentGoldLight,
                        borderRadius: AppRadii.borderRadiusMd,
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        color: AppColors.accentGold,
                        size: AppSizes.iconMd,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Khana Cash',
                            style: AppTypography.overline(AppColors.primary),
                          ),
                          Text(
                            'Available Balance: ₹$points',
                            style: AppTypography.subtitle1(AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.primary,
                      size: AppSizes.iconSm,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}