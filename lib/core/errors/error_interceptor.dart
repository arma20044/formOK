import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/router/app_router.dart';
import 'package:form/main.dart';

class ErrorInterceptor extends Interceptor {
  bool _redirecting = false;

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final data = response.data;

    if (data is Map<String, dynamic> && data['error'] == true) {
      String mensaje = "Ha ocurrido un error inesperado";
      bool isAuthError = false;

      if (data['tokenerror'] != null &&
          data['tokenerror'].toString().isNotEmpty) {
        mensaje = "Sesión expirada. Inicie sesión nuevamente.";
        isAuthError = true;
      } else if (data['errorValidacion'] == true &&
          data['errorValList'] != null) {
        mensaje =
            "Errores de validación: ${data['errorValList'].join(", ")}";
      }

      // 🔔 Snackbar global
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(mensaje),
          backgroundColor: Colors.red,
        ),
      );

      // 🔐 REDIRECCIÓN CON GOROUTER
      if (isAuthError && !_redirecting) {
        _redirecting = true;

        Future.microtask(() {
          container.read(authProvider.notifier).logout();
          
          container.read(goRouterProvider).push('/login');
          _redirecting = false;
        });
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
}
