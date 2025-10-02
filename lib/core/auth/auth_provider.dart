import 'package:flutter/material.dart';
import 'package:form/core/auth/auth_service.dart';


class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoggedIn = false;
  String? _userToken;

  bool get isLoggedIn => _isLoggedIn;
  String? get userToken => _userToken;

  AuthProvider() {
    _loadAuthStatus();
  }

  Future<void> _loadAuthStatus() async {
    _userToken = await _authService.getToken();
    _isLoggedIn = _userToken != null;
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    await _authService.login(username, password);
    await _loadAuthStatus(); // Reload status after login
  }

  Future<void> logout() async {
    await _authService.logout();
    _userToken = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}