import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pepe_self_ordering_flutter/src/theme/app_theme.dart';

class NetworkRoundedImage extends StatelessWidget {
  const NetworkRoundedImage({
    required this.url,
    required this.size,
    this.detailMode = false,
    super.key,
  });
  final String? url;
  final double size;
  final bool detailMode;
  @override
  Widget build(BuildContext context) {
    if (detailMode) {
      const radius = BorderRadius.vertical(bottom: Radius.circular(16));
      final placeholder = Container(
        width: double.infinity,
        height: 285,
        decoration: const BoxDecoration(
          color: AppColors.greenMuted,
          borderRadius: radius,
        ),
      );
      final image = url == null || url!.isEmpty
          ? placeholder
          : CachedNetworkImage(
              width: double.infinity,
              height: 285,
              fit: BoxFit.cover,
              imageUrl: url!,
              placeholder: (_, __) => placeholder,
              errorWidget: (_, __, ___) => placeholder,
            );
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(borderRadius: radius, child: image),
      );
    }

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
