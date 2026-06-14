import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 极简熊猫头 logo，代码绘制，替代原金字塔图片（logo.png / fixed_logo.png）。
class PandaLogo extends StatelessWidget {
  final double size;
  const PandaLogo({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _PandaPainter()),
    );
  }
}

class _PandaPainter extends CustomPainter {
  static const _ink = Color(0xFF2B2B2B);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final black = Paint()..color = _ink;
    final white = Paint()..color = Colors.white;

    // 耳朵（带白边，保证深色背景上可见）
    final earStroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.022;
    for (final dx in [0.25, 0.75]) {
      final earCenter = Offset(w * dx, h * 0.235);
      canvas.drawCircle(earCenter, w * 0.155, black);
      canvas.drawCircle(earCenter, w * 0.155, earStroke);
    }

    // 脸
    final faceCenter = Offset(w * 0.5, h * 0.56);
    final faceRadius = w * 0.385;
    canvas.drawCircle(faceCenter, faceRadius, white);
    canvas.drawCircle(
      faceCenter,
      faceRadius,
      Paint()
        ..color = _ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.022,
    );

    // 眼斑（微倾斜的椭圆）
    _drawEyePatch(canvas, Offset(w * 0.365, h * 0.515), w, -0.35, black);
    _drawEyePatch(canvas, Offset(w * 0.635, h * 0.515), w, 0.35, black);

    // 眼睛（眼斑上的白色高光 + 瞳孔）
    canvas.drawCircle(Offset(w * 0.385, h * 0.50), w * 0.042, white);
    canvas.drawCircle(Offset(w * 0.615, h * 0.50), w * 0.042, white);
    canvas.drawCircle(Offset(w * 0.392, h * 0.506), w * 0.019, black);
    canvas.drawCircle(Offset(w * 0.608, h * 0.506), w * 0.019, black);

    // 鼻子
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.655),
          width: w * 0.10,
          height: w * 0.068),
      black,
    );

    // 嘴（微笑弧线）
    final mouth = Paint()
      ..color = _ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.018
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.70),
          width: w * 0.16,
          height: w * 0.11),
      0.4,
      math.pi - 0.8,
      false,
      mouth,
    );
  }

  void _drawEyePatch(
      Canvas canvas, Offset center, double w, double angle, Paint paint) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset.zero, width: w * 0.135, height: w * 0.175),
      paint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
