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
            onBack: () => context.replace("/qr_scanner"),
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
            style: const TextStyle(
              fontFamily: "CarterOne",
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
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
          useSafeArea: true,
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
                        fontFamily: "CarterOne",
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      menu.desc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontFamily: "Actor", fontSize: 12),
                    ),
                    const Spacer(),
                    Text(
                      'Rp. ${formatPrice(menu.price)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: "CarterOne",
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
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height,
      color: AppColors.beigeLight,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NetworkRoundedImage(
                        url: widget.menu.pictureUrl,
                        size: 180,
                        detailMode: true,
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 19),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.menu.name,
                              style: const TextStyle(
                                fontFamily: "CarterOne",
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
                                onChanged: (_) =>
                                    setState(() => picked[s.name] = s),
                                title: Text(s.name),
                                subtitle: s.price == 0
                                    ? null
                                    : Text('+ Rp. ${formatPrice(s.price)}'),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ],
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
            ],
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
