import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/primary_button.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Contact Us')),
      body: Padding(
        padding: AppSpacing.screenAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Subject',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(borderRadius: AppRadii.borderRadiusMd, borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Message',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(borderRadius: AppRadii.borderRadiusMd, borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              text: 'Send Message',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Message sent successfully!')));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
