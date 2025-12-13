import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/api/auth_interceptor.dart';
import 'package:form/core/errors/error_interceptor.dart';
import 'package:form/core/router/app_router.dart';
import 'package:form/main.dart';

import '../enviromens/Enrivoment.dart';

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
                utf8.decode(utf8.encode(Environment.clientKey)),
              ),
            );
          }

          print('➡️ [${Environment.name}] ${options.method} ${options.uri}');
          print('Datos enviados: ${options.data}');

          if (options.data is FormData) {
            final fd = options.data as FormData;

            for (var field in fd.fields) {
              print('  ${field.key}: ${field.value}');
            }
            for (var file in fd.files) {
              print('  Archivo: ${file.key} -> ${file.value.filename}');
            }
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ [${Environment.name}] ${response.requestOptions.uri}');
          print('Status: ${response.statusCode}');
          print('Respuesta: ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print('❌ Error en: ${e.requestOptions.uri}');
          print('Status: ${e.response?.statusCode}');
          print('Mensaje: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }
}
