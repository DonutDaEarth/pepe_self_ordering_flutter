import 'package:flutter/foundation.dart';
import 'package:pepe_self_ordering_flutter/src/data/models/models.dart';

class CartLine {
  CartLine({
    required this.name,
    required this.description,
    required this.basePrice,
    required this.selectedSubitems,
    required this.quantity,
    required this.menuId,
    required this.subitemIds,
    this.imageUrl,
  });
  final String name;
  final String description;
  final int basePrice;
  final Map<String, SubitemData> selectedSubitems;
  final int quantity;
  final int menuId;
  final List<int> subitemIds;
  final String? imageUrl;

  CartLine copyWith({int? quantity}) => CartLine(
    name: name,
    description: description,
    basePrice: basePrice,
    selectedSubitems: selectedSubitems,
    quantity: quantity ?? this.quantity,
    menuId: menuId,
    subitemIds: subitemIds,
    imageUrl: imageUrl,
  );

  int totalPrice() =>
      (basePrice +
          selectedSubitems.values.fold<int>(0, (p, e) => p + e.price.toInt())) *
      quantity;

  String subitemsDisplay() =>
      selectedSubitems.values.map((e) => e.name).join(', ');
}

class CartState extends ChangeNotifier {
  final List<CartLine> _items = [];
  List<CartLine> get items => _items;

  void add(CartLine item) {
    final idx = _items.indexWhere(
      (e) =>
          e.name == item.name &&
          e.basePrice == item.basePrice &&
          mapEquals(e.selectedSubitems, item.selectedSubitems),
    );
    if (idx >= 0) {
      _items[idx] = _items[idx].copyWith(
        quantity: _items[idx].quantity + item.quantity,
      );
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void updateQuantity(int index, int quantity) {
    if (index < 0 || index >= _items.length) return;
    if (quantity <= 0) {
      _items.removeAt(index);
    } else {
      _items[index] = _items[index].copyWith(quantity: quantity);
    }
    notifyListeners();
  }

  int subtotal() => _items.fold(0, (p, e) => p + e.totalPrice());
  int count() => _items.fold(0, (p, e) => p + e.quantity);
  void clear() {
    _items.clear();
    notifyListeners();
  }
}
