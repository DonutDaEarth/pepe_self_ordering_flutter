import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pepe_self_ordering_flutter/src/theme/app_theme.dart';

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
