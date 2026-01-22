import 'package:dio/dio.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/core/enviromens/enrivoment.dart';
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
        'clientKey': environment.clientKey,
      });

      final response = await dio.post(
        "${environment.hostCtxOpen}/v4/suministro/historicoConsumoMontoWebHostRecuperar",
        data: data,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return RecuperarHistorico.fromJson(response.data);
        } else {
          throw Exception(
            "Formato inesperado: se esperaba un JSON tipo Map<String,dynamic>",
          );
        }
      }

      throw Exception('Error HTTP ${response.statusCode}');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception("Timeout al conectar con el servidor.");
      }

      if (e.response != null) {
        if (e.response?.data["errorValidacion"]) {
          throw Exception(
            "Error de Validación: ${e.response?.data["errorValList"][0]}",
          );
        }
        throw Exception("Error del servidor: ${e.response?.statusCode}");
      }

      throw Exception("Error de red: ${e.message}");
    } catch (e) {
      // Cualquier otro error desconocido

      throw Exception("Error inesperado: $e");
    }
  }
}
