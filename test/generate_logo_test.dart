import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Copied from AppLogo
class KhanaLogoPainter extends CustomPainter {
  final Color color;
  final double progress;

  KhanaLogoPainter({required this.color, required this.progress});

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

    final cx = width / 2;
    final cy = height / 2;

    final plateProgress = (progress / 0.3).clamp(0.0, 1.0);
    final domeProgress = ((progress - 0.3) / 0.4).clamp(0.0, 1.0);
    final steamProgress = ((progress - 0.7) / 0.2).clamp(0.0, 1.0);
    final handleOpacity = ((progress - 0.9) / 0.1).clamp(0.0, 1.0);

    if (plateProgress > 0) {
      final platePath = Path();
      final plateY = cy + (height * 0.25);
      final plateLeft = cx - (width * 0.4);
      final plateRight = cx + (width * 0.4);
      platePath.moveTo(plateLeft, plateY);
      platePath.lineTo(plateRight, plateY);
      canvas.drawPath(_createAnimatedPath(platePath, plateProgress), strokePaint);
    }

    final domeTop = cy - (height * 0.15);
    if (domeProgress > 0) {
      final domePath = Path();
      final plateY = cy + (height * 0.25);
      final domeLeft = cx - (width * 0.32);
      final domeRight = cx + (width * 0.32);
      final domeBottom = plateY - (strokePaint.strokeWidth / 2);

      domePath.moveTo(domeLeft, domeBottom);
      domePath.cubicTo(
        domeLeft, domeTop - (height * 0.05), 
        domeRight, domeTop - (height * 0.05), 
        domeRight, domeBottom, 
      );
      canvas.drawPath(_createAnimatedPath(domePath, domeProgress), strokePaint);
    }

    if (handleOpacity > 0) {
      final handlePaint = Paint()
        ..color = color.withAlpha((255 * handleOpacity).toInt())
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;
      final handleRadius = width * 0.06;
      final handleCenter = Offset(cx, domeTop - handleRadius + (height * 0.03));
      canvas.drawCircle(handleCenter, handleRadius, handlePaint);
    }

    if (steamProgress > 0) {
      final steamPaint = Paint()
        ..color = color.withAlpha((255 * 0.6).toInt())
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.05
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true;

      final steamPath = Path();
      final steamStartX = cx + (width * 0.18);
      final steamStartY = domeTop - (height * 0.05);
      steamPath.moveTo(steamStartX, steamStartY);
      steamPath.quadraticBezierTo(
        steamStartX + (width * 0.1), steamStartY - (height * 0.1), 
        steamStartX - (width * 0.02), steamStartY - (height * 0.2), 
      );
      canvas.drawPath(_createAnimatedPath(steamPath, steamProgress), steamPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

void main() {
  test('Generate Logo PNG', () async {
    const double imageSize = 1024.0;
    const double logoSize = 700.0;
    
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, imageSize, imageSize));

    // Draw background (AppColors.background)
    final bgPaint = Paint()..color = const Color(0xFFFAF9F6);
    canvas.drawRect(const Rect.fromLTWH(0, 0, imageSize, imageSize), bgPaint);

    // Draw Logo centered (AppColors.primary)
    canvas.save();
    canvas.translate((imageSize - logoSize) / 2, (imageSize - logoSize) / 2);
    
    final painter = KhanaLogoPainter(color: const Color(0xFFE53935), progress: 1.0);
    painter.paint(canvas, const Size(logoSize, logoSize));
    
    canvas.restore();

    // Create Image
    final picture = recorder.endRecording();
    final img = await picture.toImage(imageSize.toInt(), imageSize.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    
    if (byteData != null) {
      final file = File('assets/images/app_icon.png');
      if (!file.existsSync()) {
        file.createSync(recursive: true);
      }
      file.writeAsBytesSync(byteData.buffer.asUint8List());
    }
  });
}
