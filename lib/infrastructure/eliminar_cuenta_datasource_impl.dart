import 'package:dio/dio.dart';
import 'package:form/model/model.dart';

import '../core/api/mi_ande_api.dart';
import '../core/enviromens/enrivoment.dart';
import '../datasources/datasources.dart';

class EliminarCuentaDatasourceImpl extends EliminarCuentaDatasource {
  late final Dio dio;

  //  EliminarCuentaDatasourceImpl(MiAndeApi api) : dio = api.dio;

  EliminarCuentaDatasourceImpl(MiAndeApi api) : dio = api.dio;

  @override
  Future<EliminarCuentaResponse> getEliminarCuenta(
       String xToken,
  ) async {
    var data = FormData.fromMap({'kwfxtoken': xToken});

    final response = await dio.post(
      "${environment.hostCtxRegistroUnico}/v1/eliminarCuenta",
      data: data,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    if (response.statusCode == 200) {
      final olvidoContrasenhaResponse = EliminarCuentaResponse.fromJson(
        response.data,
      );
      return olvidoContrasenhaResponse;
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
