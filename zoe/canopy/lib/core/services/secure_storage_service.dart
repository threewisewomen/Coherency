import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../models/user_model.dart';

class SecureStorageService {
  static const String _accessTokenKey = 'access_token';
  static const String _userKey = 'user_data';
  static const String _expiresAtKey = 'expires_at';

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Token management
  static Future<void> saveToken({
    required String accessToken,
    required DateTime expiresAt,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(
        key: _expiresAtKey, value: expiresAt.toIso8601String());
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  static Future<DateTime?> getTokenExpiry() async {
    final expiryString = await _storage.read(key: _expiresAtKey);
    return expiryString != null ? DateTime.parse(expiryString) : null;
  }

  static Future<bool> isTokenValid() async {
    final token = await getAccessToken();
    if (token == null) return false;

    final expiry = await getTokenExpiry();
    if (expiry == null) return false;

    return DateTime.now().isBefore(
        expiry.subtract(const Duration(minutes: 5))); // 5-minute buffer
  }

  // User data management
  static Future<void> saveUser(User user) async {
    await _storage.write(key: _userKey, value: json.encode(user.toJson()));
  }

  static Future<User?> getUser() async {
    final userString = await _storage.read(key: _userKey);
    if (userString == null) return null;
    try {
      return User.fromJson(json.decode(userString));
    } catch (e) {
      return null;
    }
  }

  // Clear all data
  static Future<void> clearAll() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _userKey);
    await _storage.delete(key: _expiresAtKey);
  }

  // Check if user data exists
  static Future<bool> hasUserData() async {
    final token = await getAccessToken();
    final user = await getUser();
    return token != null && user != null;
  }
}
