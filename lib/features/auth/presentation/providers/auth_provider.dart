import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form/model/auth_state.dart';
import 'package:form/model/login_model.dart';

import '../../../../core/api/mi_ande_api.dart';
import '../../../../infrastructure/login_datasource_impl.dart';
import '../../../../repositories/login_repository_impl.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

class AuthNotifier extends Notifier<AuthState> {
  static const _tokenKey = 'token';
  final _storage = const FlutterSecureStorage();

  @override
  AuthState build() {
    _checkToken(); // revisa token al iniciar
    return const AuthChecking();
  }

  Future<void> _checkToken() async {
    final storedToken = await _storage.read(key: _tokenKey);
    if (storedToken != null) {
      state = AuthAuthenticated(storedToken);
    } else {
      state = const AuthUnauthenticated();
    }
  }

  Future<void> login(
    String numeroDocumento,
    String password,
    String tipoDocumento,
  ) async {
    final repoLogin = LoginRepositoryImpl(LoginDatasourceImpl(MiAndeApi()));
    final Login loginResponse = await repoLogin.getLogin(
      numeroDocumento,
      password,
      tipoDocumento,
    );

    final token = loginResponse.token;

    // Guardamos en storage
    await _storage.write(key: _tokenKey, value: token);

    // Actualizamos estado con token obligatorio
    state = AuthAuthenticated(token!);
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    state = const AuthUnauthenticated();
  }
}

