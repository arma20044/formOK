import 'package:dio/dio.dart';
import 'package:form/core/enviromens/enrivoment.dart';
import 'package:form/model/model.dart';

import '../core/api/mi_ande_api.dart';
import '../datasources/datasources.dart';

class ReclamoRecuperadoDatasourceImpl extends ReclamoRecuperadoDatasource {
  late final Dio dio;

  //  ReclamoRecuperadoDatasourceImpl(MiAndeApi api) : dio = api.dio;

  ReclamoRecuperadoDatasourceImpl(MiAndeApi api) : dio = api.dio;

  @override
  Future<ReclamoRecuperadoResponse> getReclamoRecuperado(
    String telefono,
  ) async {
    final formMap = {'telefono': telefono};

    // Crear FormData
    final data = FormData.fromMap(formMap);

    final response = await dio.post(
      "${Environment.hostCtxGra}/v1/reclamo/recuperarUltimo",
      data: data,
      // options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    if (response.statusCode == 200) {
      final reclamoRecuperadoResponse = ReclamoRecuperadoResponse.fromJson(
        response.data,
      );

      return reclamoRecuperadoResponse;
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
