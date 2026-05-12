import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pepe_self_ordering_flutter/src/data/models/models.dart';
import 'package:pepe_self_ordering_flutter/src/state/app_state.dart';
import 'package:pepe_self_ordering_flutter/src/state/cart_state.dart';
import 'package:pepe_self_ordering_flutter/src/theme/app_theme.dart';
import 'package:pepe_self_ordering_flutter/src/widgets/app_header.dart';
import 'package:pepe_self_ordering_flutter/src/widgets/format_price.dart';
import 'package:pepe_self_ordering_flutter/src/widgets/network_rounded_image.dart';
import 'package:pepe_self_ordering_flutter/src/widgets/primary_button.dart';
import 'package:pepe_self_ordering_flutter/src/widgets/summary_row.dart';
import 'package:pepe_self_ordering_flutter/src/screens/menu_detail_sheet.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isPlacingOrder = false;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final cart = context.watch<CartState>();
    final subtotal = cart.subtotal();
    final service = (subtotal * 0.1).toInt();
    final tax = ((subtotal + service) * 0.1).toInt();
    final grand = subtotal + service + tax;
    return Scaffold(
      body: Column(
        children: [
          AppHeader(
            showSearch: false,
            onBack: () => context.pop(),
            outlet: app.outletName,
            table: app.tableNumber,
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(17, 28, 17, 24),
              itemCount: cart.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 24),
              itemBuilder: (_, i) {
                final item = cart.items[i];
                final cachedMenu = app.menuById[item.menuId];
                return InkWell(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (_) => MenuDetailSheet(
                      menu: MenuItemData(
                        id: item.menuId,
                        price: item.basePrice,
                        name: item.name,
                        desc: item.description,
                        isSelling: true,
                        pictureUrl: item.imageUrl,
                        subitems: cachedMenu?.subitems ?? item.allSubitems,
                      ),
                      initialPicked: item.selectedSubitems,
                      initialQuantity: item.quantity,
                      allowSelection: true,
                      onPickedChanged: (nextPicked) {
                        cart.updateLine(
                          i,
                          selectedSubitems: nextPicked,
                          subitemIds: nextPicked.values
                              .map((e) => e.id)
                              .toList(),
                        );
                      },
                      bottomBuilder:
                          (
                            context,
                            total,
                            quantity,
                            setQuantity,
                            canSubmit,
                            picked,
                          ) {
                            return Row(
                              children: [
                                const Text(
                                  'Quantity In Cart:',
                                  style: TextStyle(
                                    fontFamily: "CarterOne",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: AppColors.brownDark,
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        minimumSize: const Size(36, 36),
                                        padding: EdgeInsets.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Container(
                                        height: 36,
                                        width: 36,
                                        decoration: BoxDecoration(
                                          color: AppColors.orangePrimary,
                                          borderRadius: BorderRadius.circular(
                                            9,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.25,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: quantity == 1
                                              ? const Icon(
                                                  Icons.delete,
                                                  color: Color.fromARGB(
                                                    255,
                                                    149,
                                                    14,
                                                    12,
                                                  ),
                                                  size: 16,
                                                )
                                              : const Text(
                                                  "-",
                                                  style: TextStyle(
                                                    fontFamily: "CarterOne",
                                                    color: AppColors.brownDark,
                                                    fontSize: 30,
                                                  ),
                                                ),
                                        ),
                                      ),
                                      onPressed: () {
                                        final nextQty = quantity - 1;
                                        cart.updateQuantity(i, nextQty);
                                        if (nextQty <= 0) {
                                          Navigator.pop(context);
                                          return;
                                        }
                                        setQuantity(nextQty);
                                      },
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      '$quantity',
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontFamily: "CarterOne",
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        minimumSize: const Size(36, 36),
                                        padding: EdgeInsets.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Container(
                                        height: 36,
                                        width: 36,
                                        decoration: BoxDecoration(
                                          color: AppColors.orangePrimary,
                                          borderRadius: BorderRadius.circular(
                                            9,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.25,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "+",
                                            style: TextStyle(
                                              fontFamily: "CarterOne",
                                              color: AppColors.brownDark,
                                              fontSize: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        final nextQty = quantity >= 99
                                            ? quantity
                                            : quantity + 1;
                                        cart.updateQuantity(i, nextQty);
                                        setQuantity(nextQty);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                    ),
                  ),
                  child: SizedBox(
                    height: 96,
                    child: Row(
                      children: [
                        NetworkRoundedImage(url: item.imageUrl, size: 96),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontFamily: "CarterOne",
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                item.subitemsDisplay(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: "Actor",
                                  fontSize: 11,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Rp. ${formatPrice(item.totalPrice())}',
                                        style: const TextStyle(
                                          fontFamily: "CarterOne",
                                          fontSize: 15,
                                          color: AppColors.orangePrimary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 27,
                                        width: 27,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            minimumSize: const Size(27, 27),
                                            padding: EdgeInsets.zero,
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.greenButton,
                                              borderRadius:
                                                  BorderRadius.circular(9),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withValues(alpha: 0.25),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: item.quantity == 1
                                                  ? const Icon(
                                                      Icons.delete,
                                                      color: Color.fromARGB(
                                                        255,
                                                        149,
                                                        14,
                                                        12,
                                                      ),
                                                      size: 16,
                                                    )
                                                  : const Text(
                                                      "-",
                                                      style: TextStyle(
                                                        fontFamily: "CarterOne",
                                                        color:
                                                            AppColors.brownDark,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          onPressed: () => cart.updateQuantity(
                                            i,
                                            item.quantity - 1,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12),

                                      Text(
                                        '${item.quantity}',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontFamily: "CarterOne",
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(width: 12),

                                      SizedBox(
                                        height: 27,
                                        width: 27,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            minimumSize: const Size(27, 27),
                                            padding: EdgeInsets.zero,
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.greenButton,
                                              borderRadius:
                                                  BorderRadius.circular(9),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withValues(alpha: 0.25),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: const Center(
                                              child: Text(
                                                "+",
                                                style: TextStyle(
                                                  fontFamily: "CarterOne",
                                                  color: AppColors.brownDark,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                          onPressed: () => cart.updateQuantity(
                                            i,
                                            item.quantity >= 99
                                                ? item.quantity
                                                : item.quantity + 1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            height: 239,
            padding: const EdgeInsets.fromLTRB(19, 18, 19, 20),
            decoration: const BoxDecoration(
              color: AppColors.beigeLight,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              children: [
                SummaryRow('Subtotal', subtotal),
                SummaryRow('Service Charge (10%)', service),
                SummaryRow('Tax (10%)', tax),
                const Divider(color: AppColors.orangeDark, thickness: 2),
                SummaryRow('Grand Total', grand, bold: true),
                const Spacer(),
                PrimaryButton(
                  text: 'Proceed to Payment',
                  enabled: cart.items.isNotEmpty && !isPlacingOrder,
                  child: isPlacingOrder
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(
                              Color(0xFFFEF4E0),
                            ),
                          ),
                        )
                      : null,
                  onPressed: isPlacingOrder
                      ? null
                      : () async {
                          setState(() => isPlacingOrder = true);
                          try {
                            final receiptJson = {
                              'table_no': app.tableNumber,
                              'outlet_name': app.outletName,
                              'subtotal': subtotal,
                              'items': cart.items
                                  .map(
                                    (e) => {
                                      'menu_id': e.menuId,
                                      'quantity': e.quantity,
                                      'total': e.totalPrice(),
                                      'name': e.name,
                                      'picture_url': e.imageUrl,
                                      'subitems': e.selectedSubitems.values
                                          .map((s) => s.name)
                                          .toList(),
                                    },
                                  )
                                  .toList(),
                            };
                            await app.storage.saveLastReceiptJson(
                              jsonEncode(receiptJson),
                            );
                            if (!context.mounted) return;
                            context.go('/payment_success');
                          } finally {
                            if (!mounted) return;
                            setState(() => isPlacingOrder = false);
                          }
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
