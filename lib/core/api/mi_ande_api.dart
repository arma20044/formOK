import 'package:dio/dio.dart';

/// Clase para manejar todas las peticiones a la API
class MiAndeApi {
  final Dio dio;

  MiAndeApi()
      : dio = Dio(BaseOptions(
         baseUrl: 'https://desa1.ande.gov.py:8481/sigaWs/api',
         //baseUrl: 'http://10.0.2.2:8082/siga_middle/api',
          // connectTimeout: 5000,
          // receiveTimeout: 3000,
        )) {
    // Agregar interceptor para debug
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('➡️ Petición: ${options.method} ${options.uri}');
          print('Datos enviados: ${options.data}');
          return handler.next(options); // continúa la petición
        },
        onResponse: (response, handler) {
          print('✅ Respuesta de: ${response.requestOptions.uri}');
          print('Status code: ${response.statusCode}');
          print('Datos recibidos: ${response.data}');
          return handler.next(response); // continúa la respuesta
        },
        onError: (DioError e, handler) {
          print('❌ Error en: ${e.requestOptions.uri}');
          print('Status code: ${e.response?.statusCode}');
          print('Mensaje de error: ${e.message}');
          return handler.next(e); // continúa el error
        },
      ),
    );
  }
}