import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form/core/auth/auth_repository.dart';
import 'package:form/core/auth/model/auth_state_data.dart';
import 'package:form/core/auth/model/user_model.dart';

import '../../infrastructure/infrastructure.dart';

import '../../model/login_model.dart';
import '../../repositories/login_repository_impl.dart';
import '../api/mi_ande_api.dart';
import 'model/auth_state.dart';

class AuthNotifier extends AsyncNotifier<AuthStateData> {
  @override
  Future<AuthStateData> build() async {
    // Check initial authentication status (e.g., from stored tokens)
    return AuthStateData(state: AuthState.unauthenticated);
  }

  static const _userKey = 'user_data';

  Future<void> login(String numeroDocumento, String password, String tipoDocumento) async {
    final _storage = const FlutterSecureStorage();
    state = const AsyncValue.data(AuthStateData(state: AuthState.loading));
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final responseLogin = await authRepository.login(numeroDocumento, password, tipoDocumento);
      if (!responseLogin.error) {
        //state = const AsyncValue.data(AuthStateData(state: AuthState.authenticated));

        final user = UserModel(
          nombre: responseLogin.resultado!.nombre!,
          apellido: responseLogin.resultado!.apellido!,
          token: responseLogin.token!,
        );

        await _storage.write(key: _userKey, value: jsonEncode(user.toMap()));
       
        state = AsyncData(AuthStateData(state: AuthState.authenticated, user: user));


      } else {
        state = const AsyncValue.data(AuthStateData(state: AuthState.error)); // Or a more specific error state
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.data(AuthStateData(state: AuthState.loading));
    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.logout();
      state = const AsyncValue.data(AuthStateData(state: AuthState.unauthenticated));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthStateData>(AuthNotifier.new);