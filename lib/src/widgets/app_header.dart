import 'package:flutter/material.dart';
import 'package:pepe_self_ordering_flutter/src/theme/app_theme.dart';

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
      padding: const EdgeInsets.fromLTRB(12, 40, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                iconSize: 37,
                onPressed: onBack,
                icon: const Icon(
                  Icons.arrow_circle_left_outlined,
                  color: AppColors.brownDark,
                ),
              ),
              if (table.isNotEmpty || outlet.isNotEmpty)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        table,
                        style: const TextStyle(
                          fontFamily: "CarterOne",
                          color: AppColors.brownDark,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        outlet,
                        style: const TextStyle(
                          fontFamily: "CarterOne",
                          color: AppColors.brownDark,
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
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
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
                          hintStyle: TextStyle(color: AppColors.greenMuted),
                        ),
                        textInputAction: TextInputAction.search,
                        style: const TextStyle(fontFamily: "CarterOne"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
