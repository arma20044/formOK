import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:form/core/auth/auth_repository.dart';
import 'package:form/core/auth/model/auth_state_data.dart';
import 'package:form/core/auth/model/user_model.dart';
import 'package:form/model/login_model.dart';
import 'package:form/model/storage/userDatos.dart';
import 'model/auth_state.dart';

class AuthNotifier extends AsyncNotifier<AuthStateData> {
  late final AuthRepository _authRepository = ref.read(authRepositoryProvider);
  static const _userKey = 'user_data';
  static const _userDatosAnexos = 'user_datos_anexos';
  final _storage = const FlutterSecureStorage();
  bool _autoLoginDone = false;
  static const _indicadorBloqueo = 'user_indicador_bloqueo';

  @override
  Future<AuthStateData> build() async {
    // Solo devuelve estado inicial
    final initial = const AuthStateData(state: AuthState.unauthenticated);

    // Llamar login automático **una sola vez** aquí
    if (!_autoLoginDone) {
      _autoLoginDone = true;
      _attemptLoginAutoFromStorage();
    }

    return initial;
  }

  Future<void> _attemptLoginAutoFromStorage() async {
    try {
      final datosSesion = await _storage.read(key: _userKey);
      if (datosSesion != null) {
        final datosJson = json.decode(datosSesion);
        final datosUser = DatosUser.fromJson(datosJson);

        final user = await _attemptLoginAuto(datosUser);
        if (user != null) {
          state = AsyncData(
            AuthStateData(state: AuthState.authenticated, user: user),
          );
        }
      }
    } catch (_) {
      state = const AsyncData(AuthStateData(state: AuthState.unauthenticated));
    }
  }

  Future<void> attemptAutoLogin() async {
    if (_autoLoginDone) return; // ✅ evita múltiples llamadas
    _autoLoginDone = true;

    try {
      String? datosSesion = await _storage.read(key: _userKey);
      if (datosSesion != null) {
        final datosJson = json.decode(datosSesion);
        final datosUser = DatosUser.fromJson(datosJson);

        final user = await _attemptLoginAuto(datosUser);
        if (user != null) {
          state = AsyncData(
            AuthStateData(state: AuthState.authenticated, user: user),
          );
          return;
        }
      }

      state = const AsyncData(AuthStateData(state: AuthState.unauthenticated));
    } catch (_) {
      state = const AsyncData(AuthStateData(state: AuthState.unauthenticated));
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
        Uri.encodeComponent(tipoSolicitante),
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
        cedulaRepresentante: cedulaSolicitante,
        tipoSolicitante: tipoSolicitante,
        token: response.token!,
        correo: response.resultado!.correo!,
        direccion: response.resultado!.direccion!,
        pais: response.resultado!.pais!,
        departamento: response.resultado!.departamento!,
        ciudad: response.resultado!.ciudad!,
        telefonoCelular: response.resultado!.telefonoCelular!,
        tipoCliente: response.resultado!.tipoCliente!,
        modificarPassword: response.resultado!.modificarPassword!,
        userDatosAnexos: response.resultado?.suministrosList,
        verificado: response.resultado!.verificado!,

      );

      final List<SuministrosList?>? datosAnexos =
          response.resultado?.suministrosList;

      await _storage.write(
        key: _userDatosAnexos,
        value: jsonEncode(datosAnexos),
      );

      await _storage.write(key: _userKey, value: jsonEncode(user.toMap()));

      state = AsyncData(
        AuthStateData(
          state: AuthState.authenticated,
          user: user,
          userDatosAnexos: datosAnexos,
        ),
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

  Future<void> actualizarIndicadorBloqueoNIS(
    num nisRad,
    bool nuevoValor,
  ) async {
    final currentState = state.value;
    if (currentState == null) return;

    final user = currentState.user;
    if (user == null) return;

    final suministros = user.userDatosAnexos;
    if (suministros == null || suministros.isEmpty) return;

    // Actualizamos solo el suministro con el NIS indicado
    final updatedSuministros = suministros.map((s) {
      if (s!.nisRad == nisRad) {
        return s.copyWith(indicadorBloqueoWeb: nuevoValor ? 1 : 2);
      }
      return s;
    }).toList();

    // Clonamos el usuario con los datos actualizados
    final updatedUser = user.copyWith(userDatosAnexos: updatedSuministros);

    // Actualizamos el estado global
    state = AsyncData(currentState.copyWith(user: updatedUser));
  }

  Future<void> actualizarBloqueoWeb({
    required num nis,
    required bool valor,
  }) async {
    final currentState = state.value;
    if (currentState == null || currentState.userDatosAnexos == null) return;

    // Crear nueva lista con el suministro actualizado
    final nuevaLista = currentState.userDatosAnexos!.map((suministro) {
      if (suministro?.nisRad == nis) {
        return SuministrosList(
          indicadorAcuerdoLey6524: suministro?.indicadorAcuerdoLey6524,
          indicadorLey6524: suministro?.indicadorLey6524,
          nisRad: suministro?.nisRad,
          indicadorBloqueoWeb: valor ? 1 : 0,
        );
      }
      return suministro;
    }).toList();

    // Actualizar el estado global
    state = AsyncData(currentState.copyWith(userDatosAnexos: nuevaLista));

    // Opcional: actualizar almacenamiento seguro si necesitas persistirlo
    try {
      await _storage.write(
        key: _userDatosAnexos,
        value: jsonEncode(nuevaLista),
      );
    } catch (e) {
      debugPrint('Error guardando userDatosAnexos: $e');
    }
  }

  Future<void> logoutForzado() async {
  // Limpia storage
  await _storage.delete(key: _userKey);

  // Limpia estado
  state = const AsyncValue.data(
    AuthStateData(state: AuthState.unauthenticated),
  );
}
}




final authProvider = AsyncNotifierProvider<AuthNotifier, AuthStateData>(
  AuthNotifier.new,
);
