import 'package:flutter/material.dart';
import 'package:pepe_self_ordering_flutter/src/theme/app_theme.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.enabled = true,
  });
  final String text;
  final VoidCallback? onPressed;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orangePrimary,
          foregroundColor: const Color(0xFFFEF4E0),
          disabledBackgroundColor: AppColors.orangePrimary.withValues(
            alpha: 0.6,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
    );
  }
}
