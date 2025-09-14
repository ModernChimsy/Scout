// lib/auth/token_manager.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  final _storage = const FlutterSecureStorage();

  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';

  // Save tokens
  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  // Retrieve access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  // Retrieve refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  // Clear all tokens (for logout)
  Future<void> clearTokens() async {
    await _storage.deleteAll();
  }
}
