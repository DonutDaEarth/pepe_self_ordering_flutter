import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const _tokenKey = 'jwt_token';
  static const _userIdKey = 'user_id';
  static const _userEmailKey = 'user_email';
  static const _lastOrderUidKey = 'last_order_uid';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<String?> getToken() async => (await _prefs).getString(_tokenKey);
  Future<int?> getUserId() async => (await _prefs).getInt(_userIdKey);
  Future<String?> getLastOrderUid() async =>
      (await _prefs).getString(_lastOrderUidKey);

  Future<void> saveAuth({
    required String token,
    required int userId,
    required String email,
  }) async {
    final prefs = await _prefs;
    await prefs.setString(_tokenKey, token);
    await prefs.setInt(_userIdKey, userId);
    await prefs.setString(_userEmailKey, email);
  }

  Future<void> saveLastOrderUid(String uid) async =>
      (await _prefs).setString(_lastOrderUidKey, uid);

  Future<void> clearLastOrderUid() async => (await _prefs).remove(_lastOrderUidKey);

  Future<void> clearAuthData() async => (await _prefs).clear();
}
