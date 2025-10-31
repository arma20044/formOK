import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:form/main.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final data = response.data;

    // Verifica si es un Map y tiene "error"
    if (data is Map<String, dynamic> && data['error'] == true) {
      String mensaje = "Ha ocurrido un error inesperado";

      if (data['tokenerror'] != null && data['tokenerror'].toString().isNotEmpty) {
        mensaje = "Error de autenticación: ${data['tokenerror']}";
      } else if (data['errorValidacion'] == true && data['errorValList'] != null) {
        mensaje = "Errores de validación: ${data['errorValList'].join(", ")}";
      }

      // Mostrar SnackBar usando GlobalKey
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(mensaje),
          backgroundColor: Colors.red,
        ),
      );

      // Rechazar la respuesta para que el .catchError() también lo capture si quieres
      return handler.reject(
        DioError(
          requestOptions: response.requestOptions,
          response: response,
          type: DioErrorType.badResponse,
          error: mensaje,
        ),
      );
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // Aquí puedes manejar errores de red globales si quieres
    super.onError(err, handler);
  }
}
