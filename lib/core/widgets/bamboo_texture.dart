import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 竹子装饰纹理，替代原埃及风格的 vectors.png。
/// [color] 对应原 Image.asset 的着色参数，整体单色、用透明度分层。
class BambooTexture extends StatelessWidget {
  final Color? color;
  final double height;
  const BambooTexture({super.key, this.color, this.height = 140});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(
          painter: _BambooPainter(color ?? Colors.white),
        ),
      ),
    );
  }
}

class _BambooPainter extends CustomPainter {
  final Color color;
  _BambooPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    // 竹竿：[x位置, 倾斜, 粗细, 长度, 透明度]（均为相对比例）
    const stalks = [
      [0.07, 0.012, 0.026, 1.00, 0.40],
      [0.20, -0.018, 0.015, 0.70, 0.25],
      [0.47, 0.010, 0.021, 0.92, 0.32],
      [0.71, -0.014, 0.014, 0.60, 0.22],
      [0.90, 0.018, 0.025, 1.00, 0.40],
    ];
    for (final s in stalks) {
      _drawStalk(canvas, size,
          xFrac: s[0], tiltFrac: s[1], widthFrac: s[2], lenFrac: s[3], opacity: s[4]);
    }

    // 叶簇：[x位置, y位置, 朝向(弧度), 透明度]
    const clusters = [
      [0.13, 0.30, 1.10, 0.35],
      [0.30, 0.10, 1.40, 0.25],
      [0.49, 0.42, 0.85, 0.30],
      [0.66, 0.16, 1.80, 0.25],
      [0.84, 0.34, 1.95, 0.35],
    ];
    for (final c in clusters) {
      final base = Offset(size.width * c[0], size.height * c[1]);
      final len = size.height * 0.30;
      for (final spread in [-0.45, 0.0, 0.45]) {
        _drawLeaf(canvas, base, len * (spread == 0 ? 1.1 : 0.85),
            c[2] + spread, c[3]);
      }
    }
  }

  void _drawStalk(Canvas canvas, Size size,
      {required double xFrac,
      required double tiltFrac,
      required double widthFrac,
      required double lenFrac,
      required double opacity}) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()..color = color.withValues(alpha: opacity);
    final stalkW = w * widthFrac;
    final totalLen = h * lenFrac;
    const segments = 3;
    final gap = h * 0.03;
    final segLen = (totalLen - gap * (segments - 1)) / segments;
    final tiltPerPx = (w * tiltFrac) / h;
    double y = 0;
    final x0 = w * xFrac;

    for (int i = 0; i < segments; i++) {
      final cx = x0 + tiltPerPx * (y + segLen / 2);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset(cx, y + segLen / 2),
              width: stalkW,
              height: segLen),
          Radius.circular(stalkW * 0.45),
        ),
        paint,
      );
      // 竹节环
      if (i < segments - 1) {
        final ringY = y + segLen + gap / 2;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset(x0 + tiltPerPx * ringY, ringY),
                width: stalkW * 1.55,
                height: gap * 0.55),
            Radius.circular(gap),
          ),
          Paint()..color = color.withValues(alpha: opacity * 0.85),
        );
      }
      y += segLen + gap;
    }
  }

  void _drawLeaf(
      Canvas canvas, Offset base, double len, double angle, double opacity) {
    final paint = Paint()..color = color.withValues(alpha: opacity);
    final dir = Offset(math.cos(angle), math.sin(angle));
    final tip = base + dir * len;
    final mid = Offset((base.dx + tip.dx) / 2, (base.dy + tip.dy) / 2);
    final normal = Offset(-dir.dy, dir.dx) * (len * 0.18);
    final path = Path()
      ..moveTo(base.dx, base.dy)
      ..quadraticBezierTo(
          mid.dx + normal.dx, mid.dy + normal.dy, tip.dx, tip.dy)
      ..quadraticBezierTo(
          mid.dx - normal.dx, mid.dy - normal.dy, base.dx, base.dy)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BambooPainter oldDelegate) =>
      oldDelegate.color != color;
}
