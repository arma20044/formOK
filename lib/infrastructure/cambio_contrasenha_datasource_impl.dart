import 'package:dio/dio.dart';
import 'package:form/model/Cambio_contrasenha.dart';

import '../core/api/mi_ande_api.dart';
import '../core/enviromens/Enrivoment.dart';
import '../datasources/datasources.dart';

class CambioContrasenhaDatasourceImpl extends CambioContrasenhaDatasource {
  late final Dio dio;

  //  CambioContrasenhaDatasourceImpl(MiAndeApi api) : dio = api.dio;

  CambioContrasenhaDatasourceImpl(MiAndeApi api) : dio = api.dio;

  @override
  Future<CambioContrasenhaResponse> getCambioContrasenha(
    String contrasenhaAnterior,
    String nuevaContrasenha,
    String confirmarNuevaContrasenha,
    String tipoCliente,
    String token,
  ) async {
    var data = FormData.fromMap({
      'password': contrasenhaAnterior,
      'nuevoPassword': nuevaContrasenha,
      'confirmarPassword': confirmarNuevaContrasenha,
      'tipoCliente': tipoCliente,
      'kwfxtoken': token,
    });

    final response = await dio.post(
      "${Environment.hostCtxRegistroUnico}/v1/cambiarPassword",
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType, // 👈 importante
      ),
    );

    print('URL llamada: ${response.requestOptions.uri}');

    if (response.statusCode == 200) {
      final cambioContrasenhaResponse = CambioContrasenhaResponse.fromJson(
        response.data,
      );
      return cambioContrasenhaResponse;
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
