import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form/core/auth/auth_repository.dart';
import 'package:form/core/auth/model/auth_state_data.dart';
import 'package:form/core/auth/model/user_model.dart';


import 'model/auth_state.dart';

class AuthNotifier extends AsyncNotifier<AuthStateData> {
  @override
  Future<AuthStateData> build() async {
    // Check initial authentication status (e.g., from stored tokens)
    return AuthStateData(state: AuthState.unauthenticated);
  }

  static const _userKey = 'user_data';

  Future<void> login(
    String numeroDocumento,
    String password,
    String tipoDocumento,
  ) async {
    final _storage = const FlutterSecureStorage();

    state = const AsyncLoading();

    //state = const AsyncValue.data(AuthStateData(state: AuthState.loading));
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final responseLogin = await authRepository.login(
        numeroDocumento,
        password,
        tipoDocumento,
      );
      if (!responseLogin.error) {
        //state = const AsyncValue.data(AuthStateData(state: AuthState.authenticated));

        final user = UserModel(
          nombre: responseLogin.resultado!.nombre!,
          apellido: responseLogin.resultado!.apellido!,
          numeroDocumento: numeroDocumento,
          tipoDocumento: tipoDocumento,
          password: password,
          cedulaRepresentante: '', //LLEGARA DESDE EL FORM
          tipoSolicitante: '', //LLEGARA DESDE EL FORM
          token: responseLogin.token!,
        );

        await _storage.write(key: _userKey, value: jsonEncode(user.toMap()));

        state = AsyncData(
          AuthStateData(state: AuthState.authenticated, user: user),
        );

        Fluttertoast.showToast(
          msg: "Inicio de Sesión Exitosa", // Mensaje de error
          toastLength: Toast.LENGTH_SHORT, // Duración corta del toast
          gravity: ToastGravity.BOTTOM, // Posición del toast (abajo)
          backgroundColor: Colors.green, // Color de fondo rojo para error
          textColor: Colors.white, // Color del texto
          fontSize: 16.0, // Tamaño de la fuente
        );
      } else {
        state = const AsyncValue.data(
          AuthStateData(state: AuthState.error),
        ); // Or a more specific error state
        Fluttertoast.showToast(
          msg: "Error en el inicio de sesión", // Mensaje de error
          toastLength: Toast.LENGTH_SHORT, // Duración corta del toast
          gravity: ToastGravity.BOTTOM, // Posición del toast (abajo)
          backgroundColor: Colors.redAccent, // Color de fondo rojo para error
          textColor: Colors.white, // Color del texto
          fontSize: 16.0, // Tamaño de la fuente
        );
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      Fluttertoast.showToast(
        msg: "Error en el inicio de sesión: $e", // Mensaje de error
        toastLength: Toast.LENGTH_SHORT, // Duración corta del toast
        gravity: ToastGravity.BOTTOM, // Posición del toast (abajo)
        backgroundColor: Colors.redAccent, // Color de fondo rojo para error
        textColor: Colors.white, // Color del texto
        fontSize: 16.0, // Tamaño de la fuente
      );
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.data(AuthStateData(state: AuthState.loading));
    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.logout();
      state = const AsyncValue.data(
        AuthStateData(state: AuthState.unauthenticated),
      );
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthStateData>(
  AuthNotifier.new,
);
