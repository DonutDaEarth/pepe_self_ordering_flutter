import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:pepe_self_ordering_flutter/src/data/api/api_client.dart';
import 'package:pepe_self_ordering_flutter/src/data/models/models.dart';
import 'package:pepe_self_ordering_flutter/src/data/storage/auth_storage.dart';

class AuthRepository {
  AuthRepository(this._storage);
  final AuthStorage _storage;
  final Dio _dio = ApiClient.instance.dio;

  Future<String?> register(String email, String password) async {
    try {
      final regRes = await _dio.post(
        '/users/register/customer',
        data: RegisterRequest(email: email, password: password).toJson(),
      );
      if (regRes.data['success'] == true) {
        return login(email, password);
      }
      return regRes.data['message']?.toString() ?? 'Registration failed';
    } catch (_) {
      return 'Network error occurred';
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      final res = await _dio.post(
        '/users/login',
        data: LoginRequest(email: email, password: password).toJson(),
      );
      final data = LoginResponse.fromJson(res.data);
      if (!data.success) return data.message;
      await _storage.saveAuth(
        token: data.token,
        userId: _extractUserIdFromJwt(data.token),
        email: email,
      );
      return null;
    } catch (_) {
      return 'Network error occurred';
    }
  }

  Future<void> logout() => _storage.clearAuthData();

  int _extractUserIdFromJwt(String token) {
    try {
      final payload = token.split('.')[1];
      final normalized = base64Url.normalize(payload);
      final decoded = jsonDecode(utf8.decode(base64Url.decode(normalized)));
      return decoded['userId'] ?? 0;
    } catch (_) {
      return 0;
    }
  }
}

class MenuRepository {
  MenuRepository(this._storage);
  final AuthStorage _storage;
  final Dio _dio = ApiClient.instance.dio;

  Future<List<MenuCategoryData>> getOutletMenus(String outletId) async {
    final token = await _storage.getToken();
    if (token == null) throw Exception('No authentication token found');
    final res = await _dio.get(
      '/outlet-menus/outlet/$outletId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final parsed = OutletMenusResponse.fromJson(res.data);
    return parsed.data
        .map((c) => MenuCategoryData(
              category: c.category,
              menus: c.menus
                  .where((m) => m.isSelling)
                  .map(
                    (m) => MenuItemData(
                      id: m.id,
                      price: m.price,
                      name: m.name,
                      desc: m.desc,
                      isSelling: m.isSelling,
                      pictureUrl: m.pictureUrl,
                      subitems: m.subitems.where((s) => s.isSelling).toList(),
                    ),
                  )
                  .toList(),
            ))
        .toList();
  }

  Future<List<MenuCategoryData>> searchMenus(String outletId, String keyword) async {
    final token = await _storage.getToken();
    if (token == null) throw Exception('No authentication token found');
    final res = await _dio.get(
      '/outlet-menus/search',
      queryParameters: {'outlet_id': outletId, 'keyword': keyword},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final parsed = OutletMenusResponse.fromJson(res.data);
    return parsed.data;
  }
}

class OrderRepository {
  OrderRepository(this._storage);
  final AuthStorage _storage;
  final Dio _dio = ApiClient.instance.dio;

  Future<CreateOrderResponse> createOrder(CreateOrderRequest request) async {
    final token = await _storage.getToken();
    if (token == null) throw Exception('No authentication token found');
    final res = await _dio.post(
      '/orders',
      data: request.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return CreateOrderResponse.fromJson(res.data);
  }

  Future<TrackOrderData> trackOrder(String uid) async {
    final token = await _storage.getToken();
    if (token == null) throw Exception('No authentication token found');
    final res = await _dio.get(
      '/orders/track/$uid',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final parsed = TrackOrderResponse.fromJson(res.data);
    if (!parsed.success || parsed.data == null) {
      throw Exception('Failed to load receipt');
    }
    return parsed.data!;
  }
}
