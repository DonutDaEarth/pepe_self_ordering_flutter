class RegisterRequest {
  RegisterRequest({required this.email, required this.password});
  final String email;
  final String password;
  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class LoginRequest {
  LoginRequest({required this.email, required this.password});
  final String email;
  final String password;
  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class AuthUser {
  AuthUser({required this.id, required this.email});
  final int id;
  final String email;
  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      AuthUser(id: json['id'] ?? 0, email: json['email'] ?? '');
}

class LoginResponse {
  LoginResponse({
    required this.success,
    required this.message,
    required this.token,
    required this.user,
  });
  final bool success;
  final String message;
  final String token;
  final AuthUser? user;
  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        token: json['token'] ?? '',
        user: json['user'] == null ? null : AuthUser.fromJson(json['user']),
      );
}

class MenuCategoryData {
  MenuCategoryData({required this.category, required this.menus});
  final String category;
  final List<MenuItemData> menus;
  factory MenuCategoryData.fromJson(Map<String, dynamic> json) => MenuCategoryData(
        category: json['category'] ?? '',
        menus: ((json['menus'] as List?) ?? [])
            .map((e) => MenuItemData.fromJson(e))
            .toList(),
      );
}

class MenuItemData {
  MenuItemData({
    required this.id,
    required this.price,
    required this.name,
    required this.desc,
    required this.isSelling,
    required this.pictureUrl,
    required this.subitems,
  });
  final int id;
  final int price;
  final String name;
  final String desc;
  final bool isSelling;
  final String? pictureUrl;
  final List<SubitemData> subitems;
  factory MenuItemData.fromJson(Map<String, dynamic> json) => MenuItemData(
        id: json['m_id'] ?? json['id'] ?? 0,
        price: json['price'] ?? 0,
        name: json['name'] ?? '',
        desc: json['desc'] ?? '',
        isSelling: json['is_selling'] ?? true,
        pictureUrl: json['picture_url'],
        subitems: ((json['subitems'] as List?) ?? [])
            .map((e) => SubitemData.fromJson(e))
            .toList(),
      );
}

class SubitemData {
  SubitemData({
    required this.id,
    required this.name,
    required this.price,
    required this.isSelling,
  });
  final int id;
  final String name;
  final int price;
  final bool isSelling;
  factory SubitemData.fromJson(Map<String, dynamic> json) => SubitemData(
        id: json['id'] ?? json['menu_id'] ?? 0,
        name: json['name'] ?? '',
        price: json['price'] ?? 0,
        isSelling: json['is_selling'] ?? true,
      );
}

class OutletMenusResponse {
  OutletMenusResponse({required this.success, required this.data});
  final bool success;
  final List<MenuCategoryData> data;
  factory OutletMenusResponse.fromJson(Map<String, dynamic> json) => OutletMenusResponse(
        success: json['success'] ?? false,
        data: ((json['data'] as List?) ?? [])
            .map((e) => MenuCategoryData.fromJson(e))
            .toList(),
      );
}

class CreateOrderRequest {
  CreateOrderRequest({
    required this.outletId,
    required this.tableNo,
    required this.userId,
    required this.orderItems,
  });
  final int outletId;
  final String tableNo;
  final int userId;
  final List<OrderItemRequest> orderItems;
  Map<String, dynamic> toJson() => {
        'outlet_id': outletId,
        'table_no': tableNo,
        'user_id': userId,
        'order_item': orderItems.map((e) => e.toJson()).toList(),
      };
}

class OrderItemRequest {
  OrderItemRequest({
    required this.menuId,
    required this.quantity,
    required this.subitems,
  });
  final int menuId;
  final int quantity;
  final List<SubitemRequest> subitems;
  Map<String, dynamic> toJson() => {
        'menu_id': menuId,
        'quantity': quantity,
        'subitems': subitems.map((e) => e.toJson()).toList(),
      };
}

class SubitemRequest {
  SubitemRequest({required this.menuId, this.quantity = 1});
  final int menuId;
  final int quantity;
  Map<String, dynamic> toJson() => {'menu_id': menuId, 'quantity': quantity};
}

class CreateOrderResponse {
  CreateOrderResponse({required this.success, required this.message, required this.uid});
  final bool success;
  final String message;
  final String uid;
  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) => CreateOrderResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        uid: (json['data']?['uid'] ?? '').toString(),
      );
}

class TrackOrderResponse {
  TrackOrderResponse({required this.success, required this.data});
  final bool success;
  final TrackOrderData? data;
  factory TrackOrderResponse.fromJson(Map<String, dynamic> json) => TrackOrderResponse(
        success: json['success'] ?? false,
        data: json['data'] == null ? null : TrackOrderData.fromJson(json['data']),
      );
}

class TrackOrderData {
  TrackOrderData({
    required this.tableNo,
    required this.outletName,
    required this.subtotal,
    required this.items,
  });
  final String tableNo;
  final String outletName;
  final int subtotal;
  final List<TrackOrderItem> items;
  factory TrackOrderData.fromJson(Map<String, dynamic> json) {
    final parsedItems = (((json['or_order_item'] ?? {})['items'] as List?) ?? [])
        .map((e) => TrackOrderItem.fromJson(e))
        .toList();
    return TrackOrderData(
      tableNo: json['table_no'] ?? '',
      outletName: (json['outlet']?['name'] ?? '').toString(),
      subtotal: json['subtotal'] ?? 0,
      items: parsedItems,
    );
  }
}

class TrackOrderItem {
  TrackOrderItem({
    required this.menuId,
    required this.quantity,
    required this.total,
    required this.name,
    required this.pictureUrl,
    required this.subitems,
  });
  final int menuId;
  final int quantity;
  final int total;
  final String name;
  final String? pictureUrl;
  final List<String> subitems;
  factory TrackOrderItem.fromJson(Map<String, dynamic> json) => TrackOrderItem(
        menuId: json['menu_id'] ?? 0,
        quantity: json['quantity'] ?? 1,
        total: json['total'] ?? 0,
        name: json['name'] ?? '',
        pictureUrl: json['picture_url'],
        subitems: ((json['subitems'] as List?) ?? [])
            .map((e) => (e['name'] ?? '').toString())
            .toList(),
      );
}

class ScannedQrData {
  ScannedQrData({required this.id, required this.outlet, required this.table});
  final String id;
  final String outlet;
  final String table;
}
