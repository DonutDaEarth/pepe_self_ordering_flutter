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
      ],
    );
  }
}
