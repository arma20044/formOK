import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:form/core/enviromens/enrivoment.dart';

import 'package:form/model/model.dart';

import '../../core/api/mi_ande_api.dart';
import '../../datasources/datasources.dart';

class MiCuentaUltimasFacturasDatasourceImpl extends MiCuentaUltimasFacturasDatasource {
  late final Dio dio;

  //  MiCuentaUltimasFacturasDatasourceImpl(MiAndeApi api) : dio = api.dio;

  MiCuentaUltimasFacturasDatasourceImpl(MiAndeApi api) : dio = api.dio;

  @override
  Future<MiCuentaUltimasFacturasResponse> getMiCuentaUltimasFacturas(
    String nis,
    String cantidad,
    String token
  ) async {
    final formMap = {'cantidad': cantidad, 'nis': nis, 'kwfxtoken':token };

    // Crear FormData
    final data = FormData.fromMap(formMap);

    final response = await dio.post(
      "${Environment.hostCtxMiCuenta}/v3/suministro/ultimasFacturas",
      data: data,
      // options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    if (response.statusCode == 200) {
      final micuentaultimasfacturasResponse = MiCuentaUltimasFacturasResponse.fromJson(
        response.data,
      );

      return micuentaultimasfacturasResponse;
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
