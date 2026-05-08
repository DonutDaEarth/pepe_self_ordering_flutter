import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:pepe_self_ordering_flutter/src/theme/app_theme.dart';

class LabeledTextField extends StatelessWidget {
  const LabeledTextField({
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.hint = '',
    super.key,
  });
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final String hint;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 2),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'CarterOne',
              color: AppColors.orangePrimary,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.beigeLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: controller,
                  obscureText: obscureText,
                  style: const TextStyle(
                    fontFamily: 'CarterOne',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _TopInnerShadowPainter(
                      color: Colors.black.withValues(alpha: 0.25),
                      blur: 0,
                      offset: const Offset(0, 0),
                      radius: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TopInnerShadowPainter extends CustomPainter {
  const _TopInnerShadowPainter({
    required this.color,
    required this.blur,
    required this.offset,
    required this.radius,
  });

  final Color color;
  final double blur;
  final Offset offset;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    canvas.save();
    canvas.clipRRect(rrect);

    final shadowHeight = size.height * 0.2;
    final start = Offset(0, 0);
    final end = Offset(0, shadowHeight);
    final paint = Paint()
      ..shader = ui.Gradient.linear(start, end, [
        color,
        color.withValues(alpha: 0),
      ])
      ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, blur);

    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, shadowHeight), paint);
    canvas.restore();

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _TopInnerShadowPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.blur != blur ||
        oldDelegate.offset != offset ||
        oldDelegate.radius != radius;
  }
}
