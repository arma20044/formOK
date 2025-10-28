import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:form/core/auth/auth_repository.dart';
import 'package:form/core/auth/model/auth_state_data.dart';
import 'package:form/core/auth/model/user_model.dart';
import 'package:form/model/storage/userDatos.dart';
import 'model/auth_state.dart';

class AuthNotifier extends AsyncNotifier<AuthStateData> {
  late final AuthRepository _authRepository = ref.read(authRepositoryProvider);
  static const _userKey = 'user_data';
  final _storage = const FlutterSecureStorage();

  @override
  Future<AuthStateData> build() async {
    // Estado inicial: cargando
    //state = const AsyncLoading();

    try {
      String? datosSesion = await _storage.read(key: _userKey);

      if (datosSesion != null) {
        final datosJson = json.decode(datosSesion);
        final datosUser = DatosUser.fromJson(datosJson);

        final user = await _attemptLoginAuto(datosUser);
        if (user != null) {
          return AuthStateData(state: AuthState.authenticated, user: user);
        }
      }

      // Si no hay datos o login automático falla
      return const AuthStateData(state: AuthState.unauthenticated);
    } catch (_) {
      return const AuthStateData(state: AuthState.unauthenticated);
    }
  }

  // Login automático sin tocar state
  Future<UserModel?> _attemptLoginAuto(DatosUser datos) async {
    try {
      final user = await login(
        datos.numeroDocumento,
        datos.password,
        datos.tipoDocumento,
        datos.tipoSolicitante,
        datos.cedulaRepresentante,
        true,
      );
      return user.numeroDocumento.isNotEmpty ? user : null;
    } catch (_) {
      return null;
    }
  }

  // Login manual
  Future<UserModel> login(
    String numeroDocumento,
    String password,
    String tipoDocumento,
    String tipoSolicitante,
    String cedulaSolicitante,
    bool loginSilencioso,
  ) async {
    state = const AsyncLoading();

    try {
      final response = await _authRepository.login(
        numeroDocumento,
        password,
        tipoDocumento,
        tipoSolicitante,
        cedulaSolicitante,
        
      );

      if (response.error) {
        state = const AsyncValue.data(AuthStateData(state: AuthState.error));
        if (!loginSilencioso) {
          _showToast("Error en el inicio de sesión", false);
        }
        return UserModel.empty();
      }

      final user = UserModel(
        nombre: response.resultado!.nombre!,
        apellido: response.resultado!.apellido!,
        numeroDocumento: numeroDocumento,
        tipoDocumento: tipoDocumento,
        password: password,
        cedulaRepresentante: '',
        tipoSolicitante: '',
        token: response.token!,
        correo: response.resultado!.correo!,
        direccion: response.resultado!.direccion!,
        pais: response.resultado!.pais!,
        departamento: response.resultado!.departamento!,
        ciudad: response.resultado!.ciudad!,
        telefonoCelular: response.resultado!.telefonoCelular!,
        tipoCliente: response.resultado!.tipoCliente!,
        modificarPassword: response.resultado!.modificarPassword!,
      );

      await _storage.write(key: _userKey, value: jsonEncode(user.toMap()));

      state = AsyncData(
        AuthStateData(state: AuthState.authenticated, user: user),
      );
      if (!loginSilencioso) {
        _showToast("Inicio de Sesión Exitosa", true);
      }

      return user;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      if (!loginSilencioso) {
        _showToast("Error en el inicio de sesión: $e", false);
      }
      return UserModel.empty();
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.data(AuthStateData(state: AuthState.loading));

    try {
      await _authRepository.logout();
      await _storage.delete(key: _userKey);

      state = const AsyncValue.data(
        AuthStateData(state: AuthState.unauthenticated),
      );
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  void _showToast(String msg, bool success) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: success ? Colors.green : Colors.redAccent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> actualizarPassword(String nuevoPassword) async {
    final currentState = state.value;
    if (currentState == null || currentState.user == null) return;

    final user = currentState.user!;

    // Crear un nuevo objeto usuario con el password actualizado
    final updatedUser = user.copyWith(
      password: nuevoPassword,
      modificarPassword: 'N',
    );

    // Guardar en el almacenamiento seguro
    await _storage.write(key: _userKey, value: jsonEncode(updatedUser.toMap()));

    // Actualizar el estado global
    state = AsyncData(
      AuthStateData(state: AuthState.authenticated, user: updatedUser),
    );
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthStateData>(
  AuthNotifier.new,
);
