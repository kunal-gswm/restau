import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Khana App Logo
/// A custom-designed vector logo representing a premium restaurant brand.
/// It features a minimalist culinary cloche (dome cover) over a plate,
/// topped with a subtle geometric leaf/flame symbolizing freshness and warmth.
class AppLogo extends StatelessWidget {
  final double size;
  final Color? color;

  const AppLogo({
    super.key,
    this.size = 120.0,
    this.color,
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
        painter: _KhanaLogoPainter(color: logoColor),
      ),
    );
  }
}

class _KhanaLogoPainter extends CustomPainter {
  final Color color;

  _KhanaLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

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

    // 1. The Plate (Horizontal line with rounded ends)
    final plateY = cy + (height * 0.25);
    final plateLeft = cx - (width * 0.4);
    final plateRight = cx + (width * 0.4);
    canvas.drawLine(
      Offset(plateLeft, plateY),
      Offset(plateRight, plateY),
      strokePaint,
    );

    // 2. The Cloche (Dome)
    // We use a path to draw a beautiful dome that rests on the plate
    final domePath = Path();
    final domeLeft = cx - (width * 0.32);
    final domeRight = cx + (width * 0.32);
    final domeBottom = plateY - (strokePaint.strokeWidth / 2);
    final domeTop = cy - (height * 0.15);

    domePath.moveTo(domeLeft, domeBottom);
    // Cubic bezier for a smooth dome shape
    domePath.cubicTo(
      domeLeft, domeTop - (height * 0.05), // Control point 1
      domeRight, domeTop - (height * 0.05), // Control point 2
      domeRight, domeBottom, // End point
    );
    canvas.drawPath(domePath, strokePaint);

    // 3. The Top Handle (A sleek minimal circle / diamond)
    final handleRadius = width * 0.06;
    final handleCenter = Offset(cx, domeTop - handleRadius + (height * 0.03));
    canvas.drawCircle(handleCenter, handleRadius, paint);

    // 4. Subtle stylized aromatic steam / flame ascending from the top right
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
    canvas.drawPath(steamPath, steamPaint);
  }

  @override
  bool shouldRepaint(covariant _KhanaLogoPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
