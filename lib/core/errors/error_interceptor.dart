import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/router/app_router.dart';
import 'package:form/main.dart';

class ErrorInterceptor extends Interceptor {
  static bool _loggingOut = false;

  static void reset() {
    _loggingOut = false;
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    final data = response.data;

    if (data is Map<String, dynamic> && data['error'] == true) {
      String mensaje = "Ha ocurrido un error inesperado";

      final tokenError = data['tokenerror'] != null &&
          data['tokenerror'].toString().isNotEmpty;

      if (tokenError) {
        mensaje = "Sesión expirada. Inicie sesión nuevamente.";

        _logout();

      } else if (data['errorValidacion'] == true &&
          data['errorValList'] != null) {

        mensaje =
            "Errores de validación: ${data['errorValList'].join(", ")}";

        rootScaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(mensaje),
            backgroundColor: Colors.red,
          ),
        );
      }

      return handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: mensaje,
        ),
      );
    }

    return handler.next(response);
  }


  Future<void> _logout() async {
    if (_loggingOut) return;

    _loggingOut = true;

    try {
      await container
          .read(authProvider.notifier)
          .logout();

      container
          .read(goRouterProvider)
          .go('/login');

    } finally {
      // No poner false aquí
      // se libera cuando el usuario inicia sesión nuevamente
    }
  }
}