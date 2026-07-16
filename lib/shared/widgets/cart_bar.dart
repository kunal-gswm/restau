import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_animations.dart';
import 'animated_price.dart';

/// Floating cart bar widget used at the bottom of Home and Menu screens.
///
/// Features premium micro-interactions on tap and smooth number tickers.
class CartBar extends StatefulWidget {
  final int itemCount;
  final double total;
  final VoidCallback onTap;

  const CartBar({
    super.key,
    required this.itemCount,
    required this.total,
    required this.onTap,
  });

  @override
  State<CartBar> createState() => _CartBarState();
}

class _CartBarState extends State<CartBar> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.fast,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.08).chain(CurveTween(curve: Curves.easeOutCubic)), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.0).chain(CurveTween(curve: Curves.bounceOut)), weight: 70),
    ]).animate(_bounceController);
  }
  
  @override
  void didUpdateWidget(covariant CartBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.itemCount > oldWidget.itemCount) {
      _bounceController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _bounceAnimation]),
        builder: (context, child) {
          final combinedScale = _scaleAnimation.value * _bounceAnimation.value;
          return Transform.scale(
            scale: combinedScale,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Container(
                height: AppSizes.buttonHeightLg,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: AppRadii.borderRadiusPill,
                  boxShadow: AppElevation.brandGlow,
                ),
                child: Row(
                  children: [
                    // Item count badge
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: AnimatedPrice(
                          value: widget.itemCount.toDouble(),
                          prefix: '',
                          textStyle: AppTypography.priceRegular(AppColors.primary),
                        ),
                      ),
                    ),

                    const SizedBox(width: AppSpacing.md),

                    // Label
                    Text(
                      'View Cart',
                      style: AppTypography.buttonRegular(AppColors.textOnPrimary),
                    ),

                    const Spacer(),

                    // Total price
                    AnimatedPrice(
                      value: widget.total,
                      textStyle: AppTypography.priceLarge(AppColors.textOnPrimary),
                    ),

                    const SizedBox(width: AppSpacing.md),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
