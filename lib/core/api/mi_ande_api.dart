import 'dart:io';

import 'package:dio/dio.dart';

import '../enviromens/Enrivoment.dart';

/// Clase para manejar todas las peticiones a la API
class MiAndeApi {
  final Dio dio;

  MiAndeApi()
    : dio = Dio(
        BaseOptions(
          //baseUrl: Environment.hostCtxSiga, // 👈 usa el Environment global
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 3),
          headers: {
            'x-so' : Platform.isAndroid ? 'android': 'ios'
          }
          //queryParameters: {'clientKey':Environment.clientKey}
        ),
      ) {
    // Interceptor para debug
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final formData = options.data as FormData;
          formData.fields.add(MapEntry('clientKey', Environment.clientKey));
          print(
            '➡️ [${Environment.name}] Petición: ${options.method} ${options.uri}',
          );
          print('Datos enviados: ${options.data}');
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
