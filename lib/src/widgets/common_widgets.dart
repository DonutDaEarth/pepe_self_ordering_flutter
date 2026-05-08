import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pepe_self_ordering_flutter/src/theme/app_theme.dart';

String formatPrice(int value) {
  final s = value.toString();
  final chunks = <String>[];
  for (int i = s.length; i > 0; i -= 3) {
    chunks.insert(0, s.substring(math.max(0, i - 3), i));
  }
  return chunks.join('.');
}

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

class NetworkRoundedImage extends StatelessWidget {
  const NetworkRoundedImage({required this.url, required this.size, super.key});
  final String? url;
  final double size;
  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.greenMuted,
          borderRadius: BorderRadius.circular(20),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: CachedNetworkImage(
        width: size,
        height: size,
        fit: BoxFit.cover,
        imageUrl: url!,
        placeholder: (_, __) => Container(color: AppColors.greenMuted),
        errorWidget: (_, __, ___) => Container(color: AppColors.greenMuted),
      ),
    );
  }
}

class AppHeader extends StatelessWidget {
  const AppHeader({
    required this.showSearch,
    required this.onBack,
    this.outlet = '',
    this.table = '',
    this.searchController,
    this.onSearchChanged,
    super.key,
  });
  final bool showSearch;
  final VoidCallback onBack;
  final String outlet;
  final String table;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.orangePrimary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              if (table.isNotEmpty || outlet.isNotEmpty)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        table,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        outlet,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (showSearch) ...[
            const SizedBox(height: 8),
            Container(
              height: 35,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF4E0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    size: 20,
                    color: AppColors.brownDark,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: onSearchChanged,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search menu...',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
