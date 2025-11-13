import 'package:dio/dio.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/core/enviromens/Enrivoment.dart';
import 'package:form/datasources/datasources.dart';
import 'package:form/model/model.dart';

class RegistroNumeroCelularDatasourceImp
    extends RegistroNumeroCelularDatasource {
  late final Dio dio;

  //   OlicitudAbastecimiento(MiAndeApi api) : dio = api.dio;

  RegistroNumeroCelularDatasourceImp(MiAndeApi api) : dio = api.dio;

  @override
  Future<RegistroNumeroCelularResponse> getRegistroNumeroCelular(
    String nis,
    String numeroMovil,
    String fechaAlta, //dd/MM/yyyy HH:mm:ss
    String solicitudOTP,
    String codigoOTP,
  ) async {
    final Map<String, Object> formMap = {
      'nis': nis,
      'numeroMovil': numeroMovil,
      'fechaAlta': fechaAlta,
      'solicitudOTP': solicitudOTP,
      'codigoOTP': codigoOTP,
      'clientKey': Environment.clientKey,
    };

    // Crear FormData
    final data = FormData.fromMap(formMap);

    final response = await dio.post(
      "${Environment.hostCtxOpen}/v3/cliente/numeroTelefonoViaApp",
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
      final historico = RegistroNumeroCelularResponse.fromJson(jsonData);

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
