import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/providers/user_providers.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/stat_card.dart';
import '../../../../shared/widgets/reward_card.dart';
import '../../../../shared/widgets/order_card.dart';
import '../../../../shared/widgets/settings_tile.dart';
import '../../../auth/presentation/pages/login_screen.dart';
import 'saved_addresses_screen.dart';
import 'payment_methods_screen.dart';
import 'favorites_screen.dart';
import 'support_chat_screen.dart';
import 'faq_screen.dart';
import 'contact_us_screen.dart';
import 'notifications_settings_screen.dart';
import 'language_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> with TickerProviderStateMixin {
  late AnimationController _cardFlipController;
  late Animation<double> _cardFlipAnimation;
  bool _isCardFlipped = false;

  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _cardFlipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _cardFlipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _cardFlipController, curve: Curves.easeInOut),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _progressAnimation = Tween<double>(begin: 0, end: 0.75).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOutCubic),
    );

    // Start progress animation
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _progressController.forward();
    });
  }

  @override
  void dispose() {
    _cardFlipController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _toggleCardFlip() {
    if (_isCardFlipped) {
      _cardFlipController.reverse();
    } else {
      _cardFlipController.forward();
    }
    _isCardFlipped = !_isCardFlipped;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Account'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Account settings coming soon'), duration: Duration(seconds: 2)),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 1. Digital Membership Card
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.screenAll,
              child: GestureDetector(
                onTap: _toggleCardFlip,
                child: AnimatedBuilder(
                  animation: _cardFlipAnimation,
                  builder: (context, child) {
                    final value = _cardFlipAnimation.value;
                    final angle = value * math.pi;
                    final isFront = value < 0.5;

                    return Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(angle),
                      alignment: Alignment.center,
                      child: isFront ? _buildCardFront(user.name, user.loyaltyTier) : Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(math.pi),
                        child: _buildCardBack(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // 2. Quick Stats
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.screenH,
              child: Row(
                children: [
                  const Expanded(child: StatCard(label: 'Orders', value: '24')),
                  const SizedBox(width: AppSpacing.md),
                  const Expanded(child: StatCard(label: 'Saved', value: '₹1,240')),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: StatCard(label: 'Points', value: user.loyaltyPoints.toString(), isHighlighted: true)),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sectionGap)),

          // 3. Loyalty Progress Ring
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.screenH,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Loyalty Tier', style: AppTypography.subtitle1(AppColors.textPrimary)),
                  const SizedBox(height: AppSpacing.xxl),
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: AnimatedBuilder(
                            animation: _progressAnimation,
                            builder: (context, child) {
                              return CircularProgressIndicator(
                                value: _progressAnimation.value,
                                strokeWidth: 12,
                                backgroundColor: AppColors.surfaceMuted,
                                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentGold),
                                strokeCap: StrokeCap.round,
                              );
                            },
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.stars, color: AppColors.accentGold, size: AppSizes.iconXl),
                            const SizedBox(height: AppSpacing.sm),
                            Text(user.loyaltyTier, style: AppTypography.h1(AppColors.accentGold)),
                            const SizedBox(height: 4),
                            Text('${2000 - user.loyaltyPoints} to Pit Boss', style: AppTypography.subtitle2(AppColors.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sectionGap)),

          // 4. Rewards Grid
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: 'Khana Rewards',
                  actionText: 'View All',
                  onAction: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All rewards coming soon'), duration: Duration(seconds: 2)),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 140,
                  child: ListView(
                    padding: AppSpacing.screenH,
                    scrollDirection: Axis.horizontal,
                    children: [
                      RewardCard(title: 'Mango Lassi', cost: '400 pts', isUnlocked: user.loyaltyPoints >= 400, icon: Icons.local_drink),
                      RewardCard(title: 'Paneer Tikka', cost: '800 pts', isUnlocked: user.loyaltyPoints >= 800),
                      RewardCard(title: 'Signature Thali', cost: '1500 pts', isUnlocked: user.loyaltyPoints >= 1500),
                      RewardCard(title: 'Family Feast', cost: '2500 pts', isUnlocked: user.loyaltyPoints >= 2500),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sectionGap)),
          SliverToBoxAdapter(child: Divider(color: AppColors.dividerThick)),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sectionGap)),

          // 5. Order History
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.screenH,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Past Orders', style: AppTypography.subtitle1(AppColors.textPrimary)),
                  const SizedBox(height: AppSpacing.lg),
                  OrderCard(
                    date: 'Today, 8:45 PM',
                    items: 'Butter Chicken Thali + 2 more',
                    price: 750.0,
                    status: 'Delivered',
                    onReorder: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reorder coming soon'), duration: Duration(seconds: 2)),
                    ),
                    onRate: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Order rating coming soon'), duration: Duration(seconds: 2)),
                    ),
                  ),
                  OrderCard(
                    date: '12 Jul, 7:30 PM',
                    items: 'Chicken Biryani (Large)',
                    price: 540.0,
                    status: 'Delivered',
                    onReorder: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reorder coming soon'), duration: Duration(seconds: 2)),
                    ),
                    onRate: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Order rating coming soon'), duration: Duration(seconds: 2)),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Center(
                    child: TextButton(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Full order history coming soon'), duration: Duration(seconds: 2)),
                      ),
                      child: const Text('View All Orders'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sectionGap)),
          SliverToBoxAdapter(child: Divider(color: AppColors.dividerThick)),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sectionGap)),

          // 6. Settings Blocks
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.screenH,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Account', style: AppTypography.subtitle1(AppColors.textPrimary)),
                  const SizedBox(height: AppSpacing.md),
                  SettingsGroup(
                    children: [
                      SettingsTile(icon: Icons.location_on_outlined, title: 'Saved Addresses (${user.addresses.length})', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SavedAddressesScreen()))),
                      SettingsTile(icon: Icons.payment_outlined, title: 'Payment Methods (${user.paymentMethods.length})', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentMethodsScreen()))),
                      SettingsTile(icon: Icons.favorite_border, title: 'Favorites', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()))),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  
                  Text('Support', style: AppTypography.subtitle1(AppColors.textPrimary)),
                  const SizedBox(height: AppSpacing.md),
                  SettingsGroup(
                    children: [
                      SettingsTile(icon: Icons.chat_bubble_outline, title: 'Live Chat', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportChatScreen()))),
                      SettingsTile(icon: Icons.help_outline, title: 'FAQ & Help', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FaqScreen()))),
                      SettingsTile(icon: Icons.mail_outline, title: 'Contact Us', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactUsScreen()))),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  Text('Settings', style: AppTypography.subtitle1(AppColors.textPrimary)),
                  const SizedBox(height: AppSpacing.md),
                  SettingsGroup(
                    children: [
                      SettingsTile(icon: Icons.notifications_outlined, title: 'Notifications', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsSettingsScreen()))),
                      SettingsTile(icon: Icons.language_outlined, title: 'Language', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguageScreen()))),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.sectionGap),
                  
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: AppSizes.buttonHeightLg,
                    child: OutlinedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: AppColors.surface,
                            title: Text('Log Out', style: AppTypography.h2(AppColors.textPrimary)),
                            content: Text('Are you sure you want to log out?', style: AppTypography.body1(AppColors.textSecondary)),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancel', style: AppTypography.buttonRegular(AppColors.textSecondary)),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, elevation: 0),
                                onPressed: () {
                                  Navigator.pop(context); // Close dialog
                                  Navigator.of(context, rootNavigator: true).pushReplacement(
                                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                                  );
                                },
                                child: Text('Log Out', style: AppTypography.buttonRegular(AppColors.textOnPrimary)),
                              ),
                            ],
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        shape: RoundedRectangleBorder(borderRadius: AppRadii.borderRadiusLg),
                      ),
                      child: Text('Log Out', style: AppTypography.buttonLarge(AppColors.error)),
                    ),
                  ),
                  
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFront(String name, String tier) {
    return Container(
      height: 180,
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadii.borderRadiusXxl,
        boxShadow: AppElevation.high,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Khana Rewards',
                style: AppTypography.h3(AppColors.textOnPrimary).copyWith(letterSpacing: 1),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.textOnPrimary.withValues(alpha: 0.2),
                  borderRadius: AppRadii.borderRadiusMd,
                ),
                child: Text(tier.toUpperCase(), style: AppTypography.badge(AppColors.textOnPrimary)),
              ),
            ],
          ),
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80'),
              ),
              const SizedBox(width: AppSpacing.lg),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTypography.h1(AppColors.textOnPrimary)),
                  Text('Member since 2024', style: AppTypography.caption(AppColors.textOnPrimary.withValues(alpha: 0.7))),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.borderRadiusXxl,
        border: Border.all(color: AppColors.border),
        boxShadow: AppElevation.low,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.qr_code_2, size: 100, color: AppColors.textPrimary),
          const SizedBox(height: AppSpacing.sm),
          Text('Scan at counter to earn points', style: AppTypography.caption(AppColors.textSecondary)),
        ],
      ),
    );
  }
}
