import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/primary_button.dart';

class CheckoutScreen extends StatefulWidget {
  final double cartTotal;
  
  const CheckoutScreen({super.key, required this.cartTotal});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> with SingleTickerProviderStateMixin {
  bool _isContactless = true;
  double _tipAmount = 0.0;
  String _selectedPayment = 'upi_gpay';
  
  bool _isProcessing = false;
  bool _isSuccess = false;
  
  late AnimationController _successAnimController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _successAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _successAnimController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _successAnimController.dispose();
    super.dispose();
  }

  double get _grandTotal => widget.cartTotal + _tipAmount;

  void _processPayment() async {
    setState(() {
      _isProcessing = true;
    });
    
    // Simulate network delay for payment
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    setState(() {
      _isProcessing = false;
      _isSuccess = true;
    });
    
    _successAnimController.forward();
    
    // Navigate away after success
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully! Tracking started.'),
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // 1. Logistics Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: AppSpacing.screenAll,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppRadii.borderRadiusXl,
                      boxShadow: AppElevation.low,
                    ),
                    child: Column(
                      children: [
                        // Fake Map Snapshot
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.network(
                                'https://images.unsplash.com/photo-1524661135-423995f22d0b?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Container(
                                height: 120,
                                color: Colors.black.withValues(alpha: 0.2),
                              ),
                              Container(
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.my_location, color: AppColors.textOnPrimary, size: AppSizes.iconMd),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Delivery to Home', style: AppTypography.h3(AppColors.textPrimary)),
                              const SizedBox(height: AppSpacing.xs),
                              Text('456 Palm Avenue, Koramangala', style: AppTypography.body2(AppColors.textSecondary)),
                              const SizedBox(height: AppSpacing.lg),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Add delivery instructions...',
                                  filled: true,
                                  fillColor: AppColors.surfaceMuted,
                                  border: OutlineInputBorder(
                                    borderRadius: AppRadii.borderRadiusMd,
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text('Contactless Delivery', style: AppTypography.subtitle2(AppColors.textPrimary)),
                                subtitle: Text('Driver will leave the package at your door', style: AppTypography.caption(AppColors.textSecondary)),
                                value: _isContactless,
                                activeThumbColor: AppColors.primary,
                                onChanged: (val) => setState(() => _isContactless = val),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 2. Tipping
              SliverToBoxAdapter(
                child: Padding(
                  padding: AppSpacing.screenH,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tip your delivery partner', style: AppTypography.subtitle1(AppColors.textPrimary)),
                      const SizedBox(height: 2),
                      Text('100% of the tip goes to the driver.', style: AppTypography.body2(AppColors.textSecondary)),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          _buildTipChip(20),
                          const SizedBox(width: AppSpacing.sm),
                          _buildTipChip(30),
                          const SizedBox(width: AppSpacing.sm),
                          _buildTipChip(50),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              borderRadius: AppRadii.borderRadiusPill,
                              child: Container(
                                height: AppSizes.buttonHeightMd,
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.border),
                                  borderRadius: AppRadii.borderRadiusPill,
                                ),
                                child: Center(
                                  child: Text('Custom', style: AppTypography.buttonSmall(AppColors.textPrimary)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
              SliverToBoxAdapter(child: Divider(color: AppColors.dividerThick)),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

              // 3. Payment Options
              SliverToBoxAdapter(
                child: Padding(
                  padding: AppSpacing.screenH,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Payment Method', style: AppTypography.subtitle1(AppColors.textPrimary)),
                      const SizedBox(height: AppSpacing.md),
                      
                      _buildPaymentOption(
                        id: 'upi_gpay',
                        title: 'Google Pay',
                        subtitle: 'Linked to 9876543210',
                        iconData: Icons.g_mobiledata,
                        iconColor: Colors.blue,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      
                      _buildPaymentOption(
                        id: 'card_4242',
                        title: 'HDFC Bank Credit Card',
                        subtitle: '•••• •••• •••• 4242',
                        iconData: Icons.credit_card,
                        iconColor: Colors.indigo,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      
                      // Add new card
                      InkWell(
                        onTap: () {},
                        borderRadius: AppRadii.borderRadiusMd,
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: AppRadii.borderRadiusMd,
                            color: AppColors.surface,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.add_circle_outline, color: AppColors.primary),
                              const SizedBox(width: AppSpacing.md),
                              Text('Add new card', style: AppTypography.subtitle2(AppColors.primary)),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: AppSpacing.sm),
                      _buildPaymentOption(
                        id: 'cash',
                        title: 'Cash on Delivery',
                        subtitle: 'Pay at doorstep',
                        iconData: Icons.money,
                        iconColor: AppColors.success,
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 140)), // Footer padding
            ],
          ),

          // Success Overlay
          if (_isSuccess)
            Positioned.fill(
              child: Container(
                color: AppColors.background.withValues(alpha: 0.95),
                child: Center(
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x3316A34A),
                            blurRadius: 24,
                            spreadRadius: 12,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.check, color: AppColors.textOnPrimary, size: 64),
                    ),
                  ),
                ),
              ),
            ),

          // 5. Sticky Footer CTA
          if (!_isSuccess)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.xxl),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: AppElevation.bottomSheet,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock, size: 12, color: AppColors.textTertiary),
                        const SizedBox(width: 4),
                        Text('Payments are 100% secure and encrypted', style: AppTypography.caption(AppColors.textTertiary)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    PrimaryButton(
                      text: 'Pay ₹${_grandTotal.toStringAsFixed(0)}',
                      isLoading: _isProcessing,
                      onPressed: _processPayment,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTipChip(double amount) {
    final isSelected = _tipAmount == amount;
    return InkWell(
      onTap: () {
        setState(() {
          _tipAmount = isSelected ? 0.0 : amount;
        });
      },
      borderRadius: AppRadii.borderRadiusPill,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: AppSizes.buttonHeightMd,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
          borderRadius: AppRadii.borderRadiusPill,
        ),
        child: Center(
          child: Text(
            '₹${amount.toStringAsFixed(0)}',
            style: AppTypography.buttonSmall(isSelected ? AppColors.textOnPrimary : AppColors.textPrimary),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String id,
    required String title,
    required String subtitle,
    required IconData iconData,
    required Color iconColor,
  }) {
    final isSelected = _selectedPayment == id;

    return InkWell(
      onTap: () => setState(() => _selectedPayment = id),
      borderRadius: AppRadii.borderRadiusMd,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.surface,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: AppRadii.borderRadiusMd,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: AppRadii.borderRadiusSm,
              ),
              child: Icon(iconData, color: iconColor, size: AppSizes.iconLg),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.subtitle2(AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTypography.caption(AppColors.textSecondary)),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.primary : AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
