import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  Future<void> login(String username, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    // Assuming successful login returns a token
    const token = 'your_jwt_token_here'; 
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
  }
}