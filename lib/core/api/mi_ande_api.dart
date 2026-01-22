import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:form/core/enviromens/enrivoment.dart';
import 'package:form/core/errors/error_interceptor.dart';
import 'package:form/core/router/app_router.dart';
import 'package:form/main.dart';



/// Clase para manejar todas las peticiones a la API
class MiAndeApi {
  final Dio dio;

  MiAndeApi()
      : dio = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 20),
            headers: {'x-so': Platform.isAndroid ? 'android' : 'ios'},
          ),
        ) {
    // Interceptor personalizados
    dio.interceptors.add(ErrorInterceptor());

    // Manejo global de errores (token expirado)
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, handler) {
          final status = e.response?.statusCode;

          // Token expirado → 401
          if (status == 401) {
            final router = container.read(goRouterProvider);
            router.go('/login');
          }

          return handler.next(e);
        },
      ),
    );

    // Logs + agregar clientKey
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Agregar clientKey SOLO si es FormData
          if (options.data is FormData) {
            final fd = options.data as FormData;
            fd.fields.add(
              MapEntry(
                'clientKey',
                utf8.decode(utf8.encode(environment.clientKey)),
              ),
            );
          }

         

          if (options.data is FormData) {
            final fd = options.data as FormData;

            for (var field in fd.fields) {
             // print('  ${field.key}: ${field.value}');
             debugPrint("field: $field");
            }
            for (var file in fd.files) {
             // print('  Archivo: ${file.key} -> ${file.value.filename}');
              debugPrint("file: $file");
            }
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('✅ [${environment.name}] ${response.requestOptions.uri}');
          debugPrint('Status: ${response.statusCode}');
          debugPrint('Respuesta: ${response.data}');

          
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          debugPrint('❌ Error en: ${e.requestOptions.uri}');
          debugPrint('Status: ${e.response?.statusCode}');
          debugPrint('Mensaje: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }
}
