import 'package:flutter/material.dart';
import 'package:pepe_self_ordering_flutter/src/data/models/models.dart';
import 'package:pepe_self_ordering_flutter/src/theme/app_theme.dart';
import 'package:pepe_self_ordering_flutter/src/widgets/format_price.dart';
import 'package:pepe_self_ordering_flutter/src/widgets/network_rounded_image.dart';

class MenuDetailSheet extends StatefulWidget {
  const MenuDetailSheet({
    required this.menu,
    required this.bottomBuilder,
    this.initialPicked,
    this.initialQuantity = 1,
    this.allowSelection = true,
    this.onPickedChanged,
    super.key,
  });

  final MenuItemData menu;
  final Map<String, SubitemData>? initialPicked;
  final int initialQuantity;
  final bool allowSelection;
  final ValueChanged<Map<String, SubitemData>>? onPickedChanged;
  final Widget Function(
    BuildContext context,
    int total,
    int quantity,
    void Function(int value) setQuantity,
    bool canSubmit,
    Map<String, SubitemData> picked,
  )
  bottomBuilder;

  @override
  State<MenuDetailSheet> createState() => _MenuDetailSheetState();
}

class _MenuDetailSheetState extends State<MenuDetailSheet> {
  late final Map<String, SubitemData> picked;
  late int qty;
  double _dragDownDistance = 0;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    picked = Map<String, SubitemData>.from(widget.initialPicked ?? {});
    qty = widget.initialQuantity;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<SubitemData>>{};
    for (final item in widget.menu.subitems) {
      final category = item.category.trim().isEmpty
          ? 'Options'
          : item.category.trim();
      grouped.putIfAbsent(category, () => []).add(item);
    }
    final hasRequiredSelections =
        grouped.isEmpty ||
        grouped.keys.every((category) => picked[category] != null);
    final total =
        (widget.menu.price +
            picked.values.fold<int>(0, (p, e) => p + e.price.toInt())) *
        qty;
    final height = MediaQuery.of(context).size.height;

    void setQuantity(int value) {
      setState(() => qty = value);
    }

    void closeSheet() {
      if (_isClosing) return;
      _isClosing = true;
      Navigator.pop(context);
    }

    return Container(
      height: height,
      color: AppColors.beigeLight,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is OverscrollNotification &&
                        notification.overscroll < -20) {
                      closeSheet();
                      return true;
                    }
                    return false;
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NetworkRoundedImage(
                          url: widget.menu.pictureUrl,
                          size: 180,
                          detailMode: true,
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: Text(
                                  widget.menu.name,
                                  style: const TextStyle(
                                    fontFamily: "CarterOne",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: Text(widget.menu.desc),
                              ),
                              const SizedBox(height: 12),
                              ...grouped.entries.expand(
                                (entry) => [
                                  const Divider(
                                    color: AppColors.orangeDivider,
                                    thickness: 2,
                                  ),
                                  const SizedBox(height: 4),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    child: Text(
                                      entry.key,
                                      style: const TextStyle(
                                        fontFamily: "Actor",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  ...entry.value.map(
                                    (s) => InkWell(
                                      onTap: widget.allowSelection
                                          ? () {
                                              setState(
                                                () => picked[entry.key] = s,
                                              );
                                              widget.onPickedChanged?.call(
                                                Map<String, SubitemData>.from(
                                                  picked,
                                                ),
                                              );
                                            }
                                          : null,
                                      child: Row(
                                        children: [
                                          Radio<int>(
                                            value: s.id,
                                            groupValue: picked[entry.key]?.id,
                                            onChanged: widget.allowSelection
                                                ? (_) {
                                                    setState(
                                                      () =>
                                                          picked[entry.key] = s,
                                                    );
                                                    widget.onPickedChanged
                                                        ?.call(
                                                          Map<
                                                            String,
                                                            SubitemData
                                                          >.from(picked),
                                                        );
                                                  }
                                                : null,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            visualDensity:
                                                VisualDensity.compact,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            s.name,
                                            style: const TextStyle(
                                              fontFamily: "CarterOne",
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          if (s.price != 0)
                                            Text(
                                              '+ Rp. ${formatPrice(s.price)}',
                                              style: TextStyle(
                                                fontFamily: "CarterOne",
                                                color: AppColors.orangePrimary
                                                    .withOpacity(0.75),
                                                fontSize: 15,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                color: AppColors.creamBackground,
                padding: const EdgeInsets.fromLTRB(19, 9, 19, 23),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Total Item Price:',
                          style: const TextStyle(
                            fontFamily: "CarterOne",
                            fontWeight: FontWeight.w700,
                            color: AppColors.orangePrimary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Rp. ${formatPrice(total)}',
                          style: const TextStyle(
                            fontFamily: "CarterOne",
                            fontWeight: FontWeight.w700,
                            color: AppColors.orangePrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    widget.bottomBuilder(
                      context,
                      total,
                      qty,
                      setQuantity,
                      hasRequiredSelections,
                      picked,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                final delta = details.primaryDelta ?? 0;
                if (delta > 0) {
                  _dragDownDistance += delta;
                }
              },
              onVerticalDragEnd: (_) {
                if (_dragDownDistance > 100) {
                  closeSheet();
                }
                _dragDownDistance = 0;
              },
              child: SizedBox(
                height: 60,
                width: double.infinity,
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 5),
                      Container(
                        width: 120,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.brownDark,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 32,
            right: 12,
            child: IconButton(
              iconSize: 32,
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: AppColors.brownDark),
            ),
          ),
        ],
      ),
    );
  }
}
