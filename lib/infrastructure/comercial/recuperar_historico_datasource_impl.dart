
import 'package:dio/dio.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/core/enviromens/Enrivoment.dart';
import 'package:form/datasources/datasources.dart';
import 'package:form/model/model.dart';

class RecuperarHistoricoDatasourceImpl extends RecuperarHistoricoDatasource {
  final Dio dio;

  RecuperarHistoricoDatasourceImpl(MiAndeApi api) : dio = api.dio;

  @override
  Future<RecuperarHistorico> getRecuperarHistorico(
    String id,
    String token,
  ) async {
    try {
      final data = FormData.fromMap({
        'id': id,
        'kwfxtoken': token,
        'clientKey': Environment.clientKey,
      });

      final response = await dio.post(
        "${Environment.hostCtxOpen}/v4/suministro/historicoConsumoMontoWebHostRecuperar",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      print('➡️ URL llamada: ${response.requestOptions.uri}');
      print('📦 Status Code: ${response.statusCode}');
      print('📥 Response Data: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return RecuperarHistorico.fromJson(response.data);
        } else {
          throw Exception("Formato inesperado: se esperaba un JSON tipo Map<String,dynamic>");
        }
      }

      throw Exception('Error HTTP ${response.statusCode}');

    } on DioException catch (e) {
      // Manejo mejorado de errores HTTP y de red
      print("❌ DioException: ${e.message}");
      print("❌ Response: ${e.response?.data}");

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception("Timeout al conectar con el servidor.");
      }

      if (e.response != null) {
        if(e.response?.data["errorValidacion"]){
          throw Exception("Error de Validación: ${e.response?.data["errorValList"][0]}");
        }
           throw Exception("Error del servidor: ${e.response?.statusCode}");
      }

      throw Exception("Error de red: ${e.message}");
    } catch (e) {
      // Cualquier otro error desconocido
      print("❌ Error inesperado: $e");
      throw Exception("Error inesperado: $e");
    }
  }
}
