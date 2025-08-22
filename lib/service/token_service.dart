import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenService {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'jwt');
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt');
  }

  static bool isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  static Map<String, dynamic> decodeToken(String token) {
    try {
      return JwtDecoder.decode(token);
    } catch (e) {
      print('Error decoding token: $e');
      return {};
    }
  }

  static String getUsername(String token) {
    final payload = decodeToken(token);
    return payload['sub'] ?? 'User'; // 'sub' usually contains username
  }

  static Future<void> logout() async {
    await _storage.delete(key: 'jwt');
  }
}
