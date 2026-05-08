import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:pepe_self_ordering_flutter/src/data/models/models.dart';
import 'package:pepe_self_ordering_flutter/src/state/app_state.dart';
import 'package:pepe_self_ordering_flutter/src/state/cart_state.dart';
import 'package:pepe_self_ordering_flutter/src/theme/app_theme.dart';
import 'package:pepe_self_ordering_flutter/src/widgets/common_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();
  final confirm = TextEditingController();
  String? error;
  bool loading = false;

  Future<void> submit() async {
    setState(() => error = null);
    if (name.text.trim().isEmpty)
      return setState(() => error = 'Name is required');
    if (email.text.trim().isEmpty)
      return setState(() => error = 'Email is required');
    if (pass.text.length < 8)
      return setState(() => error = 'Password must be at least 8 characters');
    if (pass.text != confirm.text)
      return setState(() => error = 'Passwords do not match');
    setState(() => loading = true);
    final app = context.read<AppState>();
    final result = await app.authRepo.register(email.text.trim(), pass.text);
    setState(() => loading = false);
    if (!mounted) return;
    if (result == null) {
      context.go('/qr_scanner');
    } else {
      setState(() => error = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24, top: 50),
        child: Column(
          children: [
            Container(
              height: 246,
              width: double.infinity,
              // color: AppColors.,
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/pepe_app_logo.png',
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Column(
                children: [
                  // const SizedBox(height: 24),
                  LabeledTextField(label: 'Name', controller: name),
                  const SizedBox(height: 24),
                  LabeledTextField(label: 'E-mail', controller: email),
                  const SizedBox(height: 24),
                  LabeledTextField(
                    label: 'Password',
                    controller: pass,
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  LabeledTextField(
                    label: 'Confirmed Password',
                    controller: confirm,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  if (error != null)
                    Text(error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 40),
                  TextButton(
                    onPressed: () => context.push('/login'),
                    child: const Text(
                      'Already have an account?',
                      style: TextStyle(color: AppColors.orangePrimary),
                    ),
                  ),
                  const SizedBox(height: 10),
                  PrimaryButton(
                    text: loading ? 'Loading...' : 'Register',
                    onPressed: loading ? null : submit,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final pass = TextEditingController();
  String? error;
  bool loading = false;
  Future<void> submit() async {
    if (email.text.trim().isEmpty || pass.text.trim().isEmpty) {
      setState(() => error = 'Email and password are required');
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    final result = await context.read<AppState>().authRepo.login(
      email.text.trim(),
      pass.text,
    );
    setState(() => loading = false);
    if (!mounted) return;
    if (result == null) {
      context.go('/qr_scanner');
    } else {
      setState(() => error = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppHeader(showSearch: false, onBack: () => context.pop()),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Column(
                  children: [
                    const SizedBox(height: 56),
                    const Text(
                      'Login to an existing account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        color: AppColors.orangePrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 56),
                    LabeledTextField(label: 'E-mail', controller: email),
                    const SizedBox(height: 24),
                    LabeledTextField(
                      label: 'Password',
                      controller: pass,
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    if (error != null)
                      Text(error!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 64),
                    PrimaryButton(
                      text: loading ? 'Loading...' : 'Login',
                      onPressed: loading ? null : submit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});
  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool handled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              if (handled) return;
              final value = capture.barcodes.first.rawValue;
              if (value == null) return;
              final parsed = AppState.parseQr(value);
              if (parsed == null) return;
              handled = true;
              context.read<AppState>().setOutlet(parsed);
              context.read<CartState>().clear();
              context.go('/main_menu');
            },
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Container(
                width: 227,
                height: 227,
                decoration: BoxDecoration(
                  // color: AppColors.orangePrimary,
                  borderRadius: BorderRadius.circular(24),
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/pepe_app_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 260,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.orangePrimary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      "Scan your Table's QR Code",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.brownDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () async {
                      await context.read<AppState>().authRepo.logout();
                      if (!mounted) return;
                      context.read<CartState>().clear();
                      context.go('/register');
                    },
                    child: const Text(
                      'Log out of Current Account',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});
  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final search = TextEditingController();
  bool loading = true;
  String? error;
  List<MenuCategoryData> categories = [];

  @override
  void initState() {
    super.initState();
    loadMenus();
  }

  Future<void> loadMenus([String q = '']) async {
    final app = context.read<AppState>();
    if (app.outletId == null) {
      setState(() {
        error = 'No outlet ID provided';
        loading = false;
      });
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      categories = q.isEmpty
          ? await app.menuRepo.getOutletMenus(app.outletId!)
          : await app.menuRepo.searchMenus(app.outletId!, q);
    } catch (e) {
      error = e.toString();
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final cartCount = context.watch<CartState>().count();
    return Scaffold(
      body: Column(
        children: [
          AppHeader(
            showSearch: true,
            onBack: () => context.pop(),
            outlet: app.outletName,
            table: app.tableNumber,
            searchController: search,
            onSearchChanged: loadMenus,
          ),
          Expanded(
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.orangePrimary,
                    ),
                  )
                : error != null
                ? Center(child: Text(error!))
                : ListView(
                    padding: const EdgeInsets.only(top: 11, bottom: 90),
                    children: categories
                        .map(
                          (c) => Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: _MenuCategoryWidget(category: c),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: cartCount > 0
          ? SafeArea(
              minimum: const EdgeInsets.fromLTRB(18, 0, 18, 23),
              child: PrimaryButton(
                text: 'Proceed to Cart ($cartCount)',
                onPressed: () => context.push('/cart'),
              ),
            )
          : null,
    );
  }
}

class _MenuCategoryWidget extends StatelessWidget {
  const _MenuCategoryWidget({required this.category});
  final MenuCategoryData category;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          child: Text(
            category.category,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 17),
          child: Divider(color: AppColors.orangeDivider, thickness: 2),
        ),
        ...category.menus.map((menu) => _MenuCard(menu: menu)),
      ],
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.menu});
  final MenuItemData menu;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
      child: InkWell(
        onTap: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => _MenuDetailSheet(menu: menu),
        ),
        child: SizedBox(
          height: 96,
          child: Row(
            children: [
              NetworkRoundedImage(url: menu.pictureUrl, size: 96),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      menu.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      menu.desc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11),
                    ),
                    const Spacer(),
                    Text(
                      'Rp. ${formatPrice(menu.price)}',
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.orangePrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuDetailSheet extends StatefulWidget {
  const _MenuDetailSheet({required this.menu});
  final MenuItemData menu;
  @override
  State<_MenuDetailSheet> createState() => _MenuDetailSheetState();
}

class _MenuDetailSheetState extends State<_MenuDetailSheet> {
  final Map<String, SubitemData> picked = {};
  int qty = 1;
  @override
  Widget build(BuildContext context) {
    final total =
        (widget.menu.price +
            picked.values.fold<int>(0, (p, e) => p + e.price.toInt())) *
        qty;
    return Container(
      color: AppColors.beigeLight,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NetworkRoundedImage(url: widget.menu.pictureUrl, size: 180),
              const SizedBox(height: 12),
              Text(
                widget.menu.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(widget.menu.desc),
              const SizedBox(height: 12),
              ...widget.menu.subitems.map(
                (s) => RadioListTile<bool>(
                  dense: true,
                  value: true,
                  groupValue: picked.containsKey(s.name),
                  onChanged: (_) => setState(() => picked[s.name] = s),
                  title: Text(s.name),
                  subtitle: s.price == 0
                      ? null
                      : Text('+ Rp. ${formatPrice(s.price)}'),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () =>
                        setState(() => qty = qty > 1 ? qty - 1 : 1),
                    icon: const Icon(Icons.remove),
                  ),
                  Text('$qty'),
                  IconButton(
                    onPressed: () => setState(() => qty++),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              Text(
                'Total Item Price: Rp. ${formatPrice(total)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.orangePrimary,
                ),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                text: 'Add To Cart',
                onPressed: () {
                  context.read<CartState>().add(
                    CartLine(
                      name: widget.menu.name,
                      description: widget.menu.desc,
                      basePrice: widget.menu.price,
                      selectedSubitems: picked,
                      quantity: qty,
                      menuId: widget.menu.id,
                      subitemIds: picked.values.map((e) => e.id).toList(),
                      imageUrl: widget.menu.pictureUrl,
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              item.subitemsDisplay(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11),
                            ),
                            const Spacer(),
                            Text(
                              'Rp. ${formatPrice(item.totalPrice())}',
                              style: const TextStyle(
                                fontSize: 15,
                                color: AppColors.orangePrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () =>
                                cart.updateQuantity(i, item.quantity + 1),
                            icon: const Icon(Icons.add),
                          ),
                          Text('${item.quantity}'),
                          IconButton(
                            onPressed: () =>
                                cart.updateQuantity(i, item.quantity - 1),
                            icon: const Icon(Icons.remove),
                          ),
                        ],
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

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});
  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) context.go('/receipt');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                // color: AppColors.orangePrimary,
              ),
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                'assets/images/pepe_cat.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 26,
                color: AppColors.orangePrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
