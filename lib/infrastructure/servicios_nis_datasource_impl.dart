import 'package:dio/dio.dart';

import '../core/api/mi_ande_api.dart';
import '../core/enviromens/enrivoment.dart';
import '../datasources/datasources.dart';
import '../model/model.dart';

class ServiciosNisDatasourceImpl extends ServiciosNisDatasource {
  late final Dio dio;

  //  ServiciosNisDatasourceImpl(MiAndeApi api) : dio = api.dio;

  ServiciosNisDatasourceImpl(MiAndeApi api) : dio = api.dio;

  @override
  Future<ServiciosNisTelefonoResponse> getServiciosNis(
    String nis,
    String token,
  ) async {
    var data = FormData.fromMap({'nis': nis, 'kwfxtoken': token});

    final response = await dio.post(
      "${environment.hostCtxMiCuenta}/v3/serviciosNisTelefono/listar",
      data: data,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    if (response.statusCode == 200) {
      final serviciosNisResponse = ServiciosNisTelefonoResponse.fromJson(
        response.data,
      );
      return serviciosNisResponse;
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
