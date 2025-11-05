import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
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
          //baseUrl: Environment.hostCtxSiga, // 👈 usa el Environment global
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          headers: {'x-so': Platform.isAndroid ? 'android' : 'ios'},
          //queryParameters: {'clientKey':Environment.clientKey}
        ),
      ) {
    // Interceptor para debug
    dio.interceptors.add(ErrorInterceptor());
    dio.interceptors.add(
    InterceptorsWrapper(
      onError: (DioException e, handler) {
        if (e.response?.statusCode == 200) {
          if(e.error == true ){
            print(e.message);

          }
          // Token expirado → limpiar sesión
          //container.read(authProvider.) = false;
          //container.read(tokenProvider.notifier).state = null;

          // Redirigir al login globalmente
          final router = container.read(goRouterProvider);
          router.go('/login');
        }
        handler.next(e);
      },
    ),
  );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final formData = options.data as FormData;

          // Agregamos clientKey
          formData.fields.add(
            MapEntry(
              'clientKey',
              utf8.decode(utf8.encode(Environment.clientKey)),
            ),
          );

          print(
            '➡️ [${Environment.name}] Petición: ${options.method} ${options.uri}',
          );
          print('Datos enviados: ${options.data}');

          if (options.data is FormData) {
            final formData = options.data as FormData;
            print('Datos enviados (FormData):');
            for (var field in formData.fields) {
              print('  ${field.key}: ${field.value}');
            }
            for (var file in formData.files) {
              print('  Archivo: ${file.key} -> ${file.value.filename}');
            }
          } else {
            print('Datos enviados: ${options.data}');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          print(
            '✅ [${Environment.name}] Respuesta de: ${response.requestOptions.uri}',
          );
          print('Status code: ${response.statusCode}');
          print('Datos recibidos: ${response.data}');
          return handler.next(response);
        },
        onError: (DioError e, handler) {
          print('❌ [${Environment.name}] Error en: ${e.requestOptions.uri}');
          print('Status code: ${e.response?.statusCode}');
          print('Mensaje de error: ${e.message}');
          return handler.next(e);
        },
      ),
    );

  }
}
