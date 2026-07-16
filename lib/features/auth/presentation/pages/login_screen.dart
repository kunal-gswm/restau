import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../features/home/presentation/pages/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() => _isLoading = true);
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 1),
              Center(
                child: Text(
                  'KHANA',
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4.0,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Center(
                child: Text(
                  'Welcome back',
                  style: AppTypography.subtitle1(AppColors.textSecondary),
                ),
              ),
              const Spacer(flex: 1),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: AppRadii.borderRadiusMd,
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: AppRadii.borderRadiusMd,
                    borderSide: BorderSide.none,
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                text: 'Sign In',
                isLoading: _isLoading,
                onPressed: _handleLogin,
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () => _showForgotPasswordModal(context),
                child: Text('Forgot Password?', style: AppTypography.buttonRegular(AppColors.primary)),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordModal(BuildContext context) {
    final recoveryCtrl = TextEditingController();
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
            Text('Reset Password', style: AppTypography.h2(AppColors.textPrimary)),
            const SizedBox(height: AppSpacing.sm),
            Text('Enter your registered email or phone number and we will send you instructions to reset your password.', style: AppTypography.body2(AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: recoveryCtrl,
              decoration: const InputDecoration(
                labelText: 'Email or Phone Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_reset, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeightMd,
              child: ElevatedButton(
                onPressed: () {
                  if (recoveryCtrl.text.trim().isEmpty) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password reset link sent to your email/phone!'), backgroundColor: AppColors.success),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.textOnPrimary),
                child: const Text('Send Reset Link'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
