import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 机器熊猫头 logo，代码绘制，chatbot 专用（在 PandaLogo 基础上机器人化：
/// 天线 + 发光屏幕眼 + 耳朵内圈，鼻子和嘴保持原版熊猫样式）。
class RobotPandaLogo extends StatelessWidget {
  final double size;
  const RobotPandaLogo({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _RobotPandaPainter()),
    );
  }
}

class _RobotPandaPainter extends CustomPainter {
  static const _ink = Color(0xFF2B2B2B);
  static const _glow = Colors.limeAccent;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final black = Paint()..color = _ink;
    final white = Paint()..color = Colors.white;
    final whiteStroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.022;

    // 天线（杆 + 发光球）
    final antenna = Paint()
      ..color = Colors.white70
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.025
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(w * 0.5, h * 0.19), Offset(w * 0.5, h * 0.08), antenna);
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.07),
      w * 0.05,
      Paint()
        ..color = _glow
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
    canvas.drawCircle(Offset(w * 0.5, h * 0.07), w * 0.034, Paint()..color = _glow);

    // 耳朵（扬声器：黑底白边 + 内白圈）
    for (final dx in [0.25, 0.75]) {
      final earCenter = Offset(w * dx, h * 0.26);
      canvas.drawCircle(earCenter, w * 0.15, black);
      canvas.drawCircle(earCenter, w * 0.15, whiteStroke);
      canvas.drawCircle(
        earCenter,
        w * 0.075,
        Paint()
          ..color = Colors.white54
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.018,
      );
    }

    // 脸
    final faceCenter = Offset(w * 0.5, h * 0.58);
    final faceRadius = w * 0.375;
    canvas.drawCircle(faceCenter, faceRadius, white);
    canvas.drawCircle(
      faceCenter,
      faceRadius,
      Paint()
        ..color = _ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.022,
    );

    // 眼斑（微倾斜椭圆）
    _drawEyePatch(canvas, Offset(w * 0.365, h * 0.535), w, -0.35, black);
    _drawEyePatch(canvas, Offset(w * 0.635, h * 0.535), w, 0.35, black);

    // 屏幕眼（眼斑上的发光圆角矩形）
    for (final dx in [0.365, 0.635]) {
      final eyeRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(w * dx, h * 0.527),
            width: w * 0.075,
            height: w * 0.052),
        Radius.circular(w * 0.02),
      );
      canvas.drawRRect(
        eyeRect,
        Paint()
          ..color = _glow
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      );
      canvas.drawRRect(eyeRect, Paint()..color = _glow);
    }

    // 鼻子（同原版熊猫，随脸部下移微调）
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.675),
          width: w * 0.10,
          height: w * 0.068),
      black,
    );

    // 嘴（同原版熊猫的微笑弧线）
    final mouth = Paint()
      ..color = _ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.018
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.72),
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
