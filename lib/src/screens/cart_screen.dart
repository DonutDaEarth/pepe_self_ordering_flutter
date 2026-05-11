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

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
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
                return SizedBox(
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
                                    SizedBox(height: 10),
                                  ],
                                ),
                                Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      child: Container(
                                        height: 27,
                                        width: 27,
                                        decoration: BoxDecoration(
                                          color: AppColors.greenButton,
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
                                          child: item.quantity == 1
                                              ? Icon(
                                                  Icons.delete,
                                                  color: const Color.fromARGB(
                                                    255,
                                                    149,
                                                    14,
                                                    12,
                                                  ),
                                                  size: 16,
                                                )
                                              : Text(
                                                  "-",
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
                                        item.quantity - 1,
                                      ),
                                    ),
                                    Text(
                                      '${item.quantity}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "CarterOne",
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),

                                    TextButton(
                                      child: Container(
                                        height: 27,
                                        width: 27,
                                        decoration: BoxDecoration(
                                          color: AppColors.greenButton,
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
                                        item.quantity + 1,
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
                _SummaryRow('Subtotal', subtotal),
                _SummaryRow('Service Charge (10%)', service),
                _SummaryRow('Tax (10%)', tax),
                const Divider(color: AppColors.orangeDark, thickness: 2),
                _SummaryRow('Grand Total', grand, bold: true),
                const Spacer(),
                PrimaryButton(
                  text: 'Proceed to Payment',
                  enabled: cart.items.isNotEmpty,
                  onPressed: () async {
                    final req = CreateOrderRequest(
                      outletId: int.tryParse(app.outletId ?? '') ?? 1,
                      tableNo: app.tableNumber,
                      userId: app.userId ?? 1,
                      orderItems: cart.items
                          .map(
                            (e) => OrderItemRequest(
                              menuId: e.menuId,
                              quantity: e.quantity,
                              subitems: e.subitemIds
                                  .map((id) => SubitemRequest(menuId: id))
                                  .toList(),
                            ),
                          )
                          .toList(),
                    );
                    final res = await app.orderRepo.createOrder(req);
                    await app.storage.saveLastOrderUid(res.uid);
                    app.currentOrderUid = res.uid;
                    if (!context.mounted) return;
                    context.go('/payment_success');
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.amount, {this.bold = false});
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
