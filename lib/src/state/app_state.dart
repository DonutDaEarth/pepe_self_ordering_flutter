import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pepe_self_ordering_flutter/src/data/models/models.dart';
import 'package:pepe_self_ordering_flutter/src/data/repositories/repositories.dart';
import 'package:pepe_self_ordering_flutter/src/data/storage/auth_storage.dart';

class AppState extends ChangeNotifier {
  final AuthStorage storage = AuthStorage();
  late final AuthRepository authRepo = AuthRepository(storage);
  late final MenuRepository menuRepo = MenuRepository(storage);
  late final OrderRepository orderRepo = OrderRepository(storage);

  final Map<int, MenuItemData> menuById = {};

  bool isBootLoading = true;
  String startRoute = '/register';
  String tableNumber = 'Table A7B';
  String outletName = 'Outlet Brooklyn Tower';
  String? outletId;
  int? userId;
  String? currentOrderUid;

  Future<void> bootstrap() async {
    if (!isBootLoading) return;
    final token = await storage.getToken();
    currentOrderUid = await storage.getLastOrderUid();
    userId = await storage.getUserId();
    startRoute = token == null
        ? '/register'
        : (currentOrderUid != null ? '/receipt' : '/qr_scanner');
    isBootLoading = false;
    notifyListeners();
  }

  void setOutlet(ScannedQrData data) {
    tableNumber = 'Table ${data.table}';
    outletName = data.outlet;
    outletId = data.id;
    notifyListeners();
  }

  void cacheMenus(List<MenuCategoryData> categories) {
    for (final category in categories) {
      for (final menu in category.menus) {
        menuById[menu.id] = menu;
      }
    }
  }

  static ScannedQrData? parseQr(String raw) {
    try {
      final decoded = raw.startsWith('{') ? raw : utf8.decode(hexToBytes(raw));
      final json = jsonDecode(decoded);
      if (json['id'] == null ||
          json['outlet'] == null ||
          json['table'] == null) {
        return null;
      }
      return ScannedQrData(
        id: json['id'].toString(),
        outlet: json['outlet'].toString(),
        table: json['table'].toString(),
      );
    } catch (_) {
      return null;
    }
  }

  static List<int> hexToBytes(String hex) {
    final clean = hex.replaceAll(' ', '');
    return List.generate(clean.length ~/ 2, (i) {
      final index = i * 2;
      return int.parse(clean.substring(index, index + 2), radix: 16);
    });
  }
}
