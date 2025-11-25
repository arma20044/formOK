import 'package:dio/dio.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/core/enviromens/Enrivoment.dart';
import 'package:form/datasources/datasources.dart';
import 'package:form/model/model.dart';

class SolicitarFraccionamientoDatasourceImp
    extends SolicitarFraccionamientoDeudaDatasource {
  late final Dio dio;

  //   OlicitudAbastecimiento(MiAndeApi api) : dio = api.dio;

  SolicitarFraccionamientoDatasourceImp(MiAndeApi api) : dio = api.dio;

  @override
  Future<SolicitarFraccionamientoResponse> getSolicitarFraccionamientoDeuda(
    String nis,
    String solicitudOTP,
    String responseSimulacion,
    String token,
    String verificarAdjunto,
  ) async {
    final Map<String, Object> formMap = {
      'nis': nis,
      'solicitudOTP': solicitudOTP,
      'responseSimulacion': responseSimulacion,
      'kwfxtoken': token,
      'verificarAdjunto': verificarAdjunto,
      'clientKey': Environment.clientKey,
    };

    // Crear FormData
    final data = FormData.fromMap(formMap);

    final response = await dio.post(
      "${Environment.hostCtxMiCuenta}/v4/fraccionamientoDeuda/nuevo",
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType, // 👈 importante
      ),
    );

    print('URL llamada: ${response.requestOptions.uri}');

    if (response.statusCode == 200) {
      // Dio ya devuelve un Map
      final Map<String, dynamic> jsonData =
          response.data as Map<String, dynamic>;

      // Convierte todo a tu modelo
      final historico = SolicitarFraccionamientoResponse.fromJson(jsonData);

      return historico;
    } else {
      throw Exception('Error ${response.statusCode}');
    }

    /*if (response.statusCode == 200) {
    print('Datos: ${response.data}');
  } else {
    print('Error ${response.statusCode}: ${response.data}');
  }*/
  }
}
