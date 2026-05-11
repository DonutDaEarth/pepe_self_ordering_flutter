import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pepe_self_ordering_flutter/src/theme/app_theme.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});
  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spinController;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) context.go('/receipt');
    });
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Container(
                width: 219,
                height: 219,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.orangePrimary,
                ),
                child: Center(
                  child: ClipOval(
                    child: CustomPaint(
                      painter: _InnerShadowCirclePainter(
                        color: Colors.black.withValues(alpha: 0.25),
                        blur: 0,
                        offset: const Offset(0, 0),
                      ),
                      child: Container(
                        width: 201,
                        height: 201,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFEF4E0),
                        ),
                        child: Center(
                          child: SizedBox(
                            height: 176,
                            width: 176,
                            child: AnimatedBuilder(
                              animation: _spinController,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: _spinController.value * 2 * math.pi,
                                  child: child,
                                );
                              },
                              child: Image.asset(
                                'assets/images/pepe_cat.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Payment Successful!',
              style: TextStyle(
                fontFamily: "CarterOne",
                fontSize: 26,
                color: AppColors.orangePrimary,
                // fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InnerShadowCirclePainter extends CustomPainter {
  const _InnerShadowCirclePainter({
    required this.color,
    required this.blur,
    required this.offset,
  });

  final Color color;
  final double blur;
  final Offset offset;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.save();
    canvas.clipPath(Path()..addOval(rect));

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
  bool shouldRepaint(covariant _InnerShadowCirclePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.blur != blur ||
        oldDelegate.offset != offset;
  }
}
