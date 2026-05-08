import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pepe_self_ordering_flutter/src/data/models/models.dart';
import 'package:pepe_self_ordering_flutter/src/state/app_state.dart';
import 'package:pepe_self_ordering_flutter/src/state/cart_state.dart';
import 'package:pepe_self_ordering_flutter/src/theme/app_theme.dart';
import 'package:pepe_self_ordering_flutter/src/widgets/common_widgets.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});
  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  TrackOrderData? receipt;
  String? error;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final app = context.read<AppState>();
    if (app.currentOrderUid == null) {
      setState(() {
        loading = false;
        error = 'Failed to load receipt';
      });
      return;
    }
    try {
      receipt = await app.orderRepo.trackOrder(app.currentOrderUid!);
    } catch (e) {
      error = e.toString();
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartState>();
    if (loading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (receipt == null)
      return Scaffold(
        body: Center(child: Text(error ?? 'Failed to load receipt')),
      );
    final subtotal = receipt!.subtotal;
    final service = (subtotal * 0.1).toInt();
    final tax = ((subtotal + service) * 0.1).toInt();
    final grand = subtotal + service + tax;
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  receipt!.tableNo,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  receipt!.outletName,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(31, 0, 31, 24),
              itemCount: receipt!.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 24),
              itemBuilder: (_, i) {
                final item = receipt!.items[i];
                return Row(
                  children: [
                    NetworkRoundedImage(url: item.pictureUrl, size: 80),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${item.quantity > 1 ? '${item.quantity}x ' : ''}${item.name}',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            item.subitems.join(', '),
                            style: const TextStyle(fontSize: 11),
                          ),
                          Text(
                            'Rp. ${formatPrice(item.total)}',
                            style: const TextStyle(
                              color: AppColors.orangePrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                  text: 'Make Another Order',
                  onPressed: () async {
                    await context.read<AppState>().storage.clearLastOrderUid();
                    context.read<AppState>().currentOrderUid = null;
                    cart.clear();
                    if (!context.mounted) return;
                    context.go('/qr_scanner');
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
    final style = TextStyle(
      fontSize: bold ? 18 : 16,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text('Rp. ${formatPrice(amount)}', style: style),
        ],
      ),
    );
  }
}
