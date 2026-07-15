import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_animations.dart';

/// Unified quantity stepper widget.
///
/// Three variants for different contexts:
/// - [QuantityStepper.compact] — for product cards in carousels
/// - [QuantityStepper.standard] — for cart items
/// - [QuantityStepper.large] — for product detail bottom bar
class QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final _QuantityStepperVariant _variant;

  const QuantityStepper.compact({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  }) : _variant = _QuantityStepperVariant.compact;

  const QuantityStepper.standard({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  }) : _variant = _QuantityStepperVariant.standard;

  const QuantityStepper.large({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  }) : _variant = _QuantityStepperVariant.large;

  @override
  Widget build(BuildContext context) {
    return switch (_variant) {
      _QuantityStepperVariant.compact => _buildCompact(),
      _QuantityStepperVariant.standard => _buildStandard(),
      _QuantityStepperVariant.large => _buildLarge(),
    };
  }

  Widget _buildCompact() {
    if (quantity == 0) {
      return _CompactAddButton(onTap: onIncrement);
    }
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: AppRadii.borderRadiusPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(
            icon: Icons.remove,
            onTap: onDecrement,
            size: 32,
            iconSize: 14,
            color: AppColors.textOnPrimary,
          ),
          AnimatedSwitcher(
            duration: AppDurations.fast,
            child: SizedBox(
              width: 20,
              child: Text(
                '$quantity',
                key: ValueKey(quantity),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textOnPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.add,
            onTap: onIncrement,
            size: 32,
            iconSize: 14,
            color: AppColors.textOnPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildStandard() {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: AppRadii.borderRadiusPill,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(
            icon: Icons.remove,
            onTap: onDecrement,
            size: 36,
            iconSize: 16,
            color: AppColors.textPrimary,
          ),
          AnimatedSwitcher(
            duration: AppDurations.fast,
            child: SizedBox(
              width: 24,
              child: Text(
                '$quantity',
                key: ValueKey(quantity),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.add,
            onTap: onIncrement,
            size: 36,
            iconSize: 16,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildLarge() {
    return Container(
      height: AppSizes.buttonHeightLg,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: AppRadii.borderRadiusPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(
            icon: Icons.remove,
            onTap: onDecrement,
            size: AppSizes.touchTarget,
            iconSize: AppSizes.iconMd,
            color: AppColors.textPrimary,
          ),
          AnimatedSwitcher(
            duration: AppDurations.fast,
            child: SizedBox(
              width: 32,
              child: Text(
                '$quantity',
                key: ValueKey(quantity),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.add,
            onTap: onIncrement,
            size: AppSizes.touchTarget,
            iconSize: AppSizes.iconMd,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }
}

/// The initial "Add" button before quantity > 0
class _CompactAddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CompactAddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      borderRadius: AppRadii.borderRadiusPill,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.borderRadiusPill,
        child: const SizedBox(
          height: 32,
          width: 32,
          child: Icon(Icons.add, color: AppColors.textOnPrimary, size: 16),
        ),
      ),
    );
  }
}

/// Individual stepper button with proper touch target
class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final double iconSize;
  final Color color;

  const _StepperButton({
    required this.icon,
    required this.onTap,
    required this.size,
    required this.iconSize,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: IconButton(
        icon: Icon(icon, size: iconSize, color: color),
        onPressed: onTap,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(minWidth: size, minHeight: size),
        splashRadius: size / 2,
      ),
    );
  }
}

/// "Add +" button for menu product cards
class AddToCartButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddToCartButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryLight,
      borderRadius: AppRadii.borderRadiusPill,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.borderRadiusPill,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            'Add +',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

enum _QuantityStepperVariant { compact, standard, large }
