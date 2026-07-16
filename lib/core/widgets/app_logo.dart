import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Khana App Logo
/// A custom-designed vector logo representing a premium restaurant brand.
/// It features a minimalist culinary cloche (dome cover) over a plate,
/// topped with a subtle geometric leaf/flame symbolizing freshness and warmth.
/// 
/// [progress] allows the logo to dynamically "draw" itself (path tracing).
class AppLogo extends StatelessWidget {
  final double size;
  final Color? color;
  final double progress;

  const AppLogo({
    super.key,
    this.size = 120.0,
    this.color,
    this.progress = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the color based on the provided color or the current theme brightness.
    // The logo defaults to the brand primary color.
    final logoColor = color ?? AppColors.primary;

    return Semantics(
      label: 'Khana App Logo',
      image: true,
      child: CustomPaint(
        size: Size(size, size),
        painter: _KhanaLogoPainter(color: logoColor, progress: progress),
      ),
    );
  }
}

class _KhanaLogoPainter extends CustomPainter {
  final Color color;
  final double progress;

  _KhanaLogoPainter({required this.color, required this.progress});

  // Helper to extract a partial path based on progress
  Path _createAnimatedPath(Path originalPath, double animationPercent) {
    if (animationPercent <= 0.0) return Path();
    if (animationPercent >= 1.0) return originalPath;

    final metrics = originalPath.computeMetrics();
    final path = Path();
    for (var metric in metrics) {
      final extractLength = metric.length * animationPercent;
      path.addPath(metric.extractPath(0.0, extractLength), Offset.zero);
    }
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final width = size.width;
    final height = size.height;

    // Center coordinates
    final cx = width / 2;
    final cy = height / 2;

    // We will sequence the drawing based on the overall progress:
    // 0.0 - 0.3: Draw Plate
    // 0.3 - 0.7: Draw Dome
    // 0.7 - 0.9: Draw Steam
    // 0.9 - 1.0: Fade in handle (fill)

    final plateProgress = (progress / 0.3).clamp(0.0, 1.0);
    final domeProgress = ((progress - 0.3) / 0.4).clamp(0.0, 1.0);
    final steamProgress = ((progress - 0.7) / 0.2).clamp(0.0, 1.0);
    final handleOpacity = ((progress - 0.9) / 0.1).clamp(0.0, 1.0);

    // 1. The Plate (Horizontal line with rounded ends)
    if (plateProgress > 0) {
      final platePath = Path();
      final plateY = cy + (height * 0.25);
      final plateLeft = cx - (width * 0.4);
      final plateRight = cx + (width * 0.4);
      platePath.moveTo(plateLeft, plateY);
      platePath.lineTo(plateRight, plateY);
      
      canvas.drawPath(_createAnimatedPath(platePath, plateProgress), strokePaint);
    }

    // 2. The Cloche (Dome)
    final domeTop = cy - (height * 0.15);
    if (domeProgress > 0) {
      final domePath = Path();
      final plateY = cy + (height * 0.25);
      final domeLeft = cx - (width * 0.32);
      final domeRight = cx + (width * 0.32);
      final domeBottom = plateY - (strokePaint.strokeWidth / 2);

      domePath.moveTo(domeLeft, domeBottom);
      // Cubic bezier for a smooth dome shape
      domePath.cubicTo(
        domeLeft, domeTop - (height * 0.05), // Control point 1
        domeRight, domeTop - (height * 0.05), // Control point 2
        domeRight, domeBottom, // End point
      );
      
      canvas.drawPath(_createAnimatedPath(domePath, domeProgress), strokePaint);
    }

    // 3. The Top Handle (A sleek minimal circle)
    if (handleOpacity > 0) {
      final handlePaint = Paint()
        ..color = color.withValues(alpha: handleOpacity)
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;
      final handleRadius = width * 0.06;
      final handleCenter = Offset(cx, domeTop - handleRadius + (height * 0.03));
      canvas.drawCircle(handleCenter, handleRadius, handlePaint);
    }

    // 4. Subtle stylized aromatic steam / flame ascending from the top right
    if (steamProgress > 0) {
      final steamPaint = Paint()
        ..color = color.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.05
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true;

      final steamPath = Path();
      final steamStartX = cx + (width * 0.18);
      final steamStartY = domeTop - (height * 0.05);
      steamPath.moveTo(steamStartX, steamStartY);
      steamPath.quadraticBezierTo(
        steamStartX + (width * 0.1), steamStartY - (height * 0.1), // Control
        steamStartX - (width * 0.02), steamStartY - (height * 0.2), // End
      );
      
      canvas.drawPath(_createAnimatedPath(steamPath, steamProgress), steamPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _KhanaLogoPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.progress != progress;
  }
}
