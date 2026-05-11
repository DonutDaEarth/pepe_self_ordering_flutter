import 'package:flutter/material.dart';
import 'package:pepe_self_ordering_flutter/src/theme/app_theme.dart';
import 'package:pepe_self_ordering_flutter/src/widgets/format_price.dart';

class SummaryRow extends StatelessWidget {
  const SummaryRow(this.label, this.amount, {this.bold = false, super.key});
  final String label;
  final int amount;
  final bool bold;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: "CarterOne",
              fontSize: bold ? 18 : 16,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          Text(
            'Rp. ${formatPrice(amount)}',
            style: TextStyle(
              fontFamily: "CarterOne",
              fontSize: bold ? 18 : 16,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              color: AppColors.orangePrimary,
            ),
          ),
        ],
      ),
    );
  }
}
