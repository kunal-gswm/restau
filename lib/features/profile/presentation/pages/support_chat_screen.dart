import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

class SupportChatScreen extends StatelessWidget {
  const SupportChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Live Chat')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.chat, size: 64, color: AppColors.primary),
            const SizedBox(height: AppSpacing.md),
            Text('Live Chat', style: AppTypography.h2(AppColors.textPrimary)),
            const SizedBox(height: AppSpacing.sm),
            Text('Our support agents are currently offline.\nPlease check back during business hours.', 
              textAlign: TextAlign.center, 
              style: AppTypography.body1(AppColors.textSecondary)
            ),
          ],
        ),
      ),
    );
  }
}
