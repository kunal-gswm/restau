import 'package:flutter/material.dart';
import '../../core/theme/app_animations.dart';

/// A premium animated text widget that rolls/slides numbers smoothly when the value changes.
class AnimatedPrice extends StatelessWidget {
  final double value;
  final TextStyle textStyle;
  final String prefix;

  const AnimatedPrice({
    super.key,
    required this.value,
    required this.textStyle,
    this.prefix = '₹',
  });

  @override
  Widget build(BuildContext context) {
    // Format value with commas and fixed decimals
    final formattedValue = value.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
        
    return AnimatedSwitcher(
      duration: AppDurations.normal,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -0.5),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: Text(
        '$prefix$formattedValue',
        key: ValueKey<double>(value),
        style: textStyle,
      ),
    );
  }
}
