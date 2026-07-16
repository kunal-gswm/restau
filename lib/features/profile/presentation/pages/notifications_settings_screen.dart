import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  bool _orderUpdates = true;
  bool _promotions = false;
  bool _newsletter = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        padding: AppSpacing.screenAll,
        children: [
          SwitchListTile(
            title: Text('Order Updates', style: AppTypography.subtitle2(AppColors.textPrimary)),
            subtitle: Text('Get updates about your order status.', style: AppTypography.body2(AppColors.textSecondary)),
            value: _orderUpdates,
            activeThumbColor: AppColors.primary,
            onChanged: (val) => setState(() => _orderUpdates = val),
          ),
          SwitchListTile(
            title: Text('Promotions & Offers', style: AppTypography.subtitle2(AppColors.textPrimary)),
            subtitle: Text('Receive exclusive deals and discounts.', style: AppTypography.body2(AppColors.textSecondary)),
            value: _promotions,
            activeThumbColor: AppColors.primary,
            onChanged: (val) => setState(() => _promotions = val),
          ),
          SwitchListTile(
            title: Text('Newsletter', style: AppTypography.subtitle2(AppColors.textPrimary)),
            subtitle: Text('Weekly updates on new menu items.', style: AppTypography.body2(AppColors.textSecondary)),
            value: _newsletter,
            activeThumbColor: AppColors.primary,
            onChanged: (val) => setState(() => _newsletter = val),
          ),
        ],
      ),
    );
  }
}
