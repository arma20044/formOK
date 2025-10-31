import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:form/core/enviromens/enrivoment.dart';

import 'package:form/model/model.dart';

import '../core/api/mi_ande_api.dart';
import '../datasources/datasources.dart';

class BloqueoSuministroDatasourceImpl extends BloqueoSuministroDatasource {
  late final Dio dio;

  //  BloqueoSuministroDatasourceImpl(MiAndeApi api) : dio = api.dio;

  BloqueoSuministroDatasourceImpl(MiAndeApi api) : dio = api.dio;

  @override
  Future<BloqueoSuministroResponse> getBloqueoSuministro(
    String nis,
    num indicadorBloqueo,
    String token
  ) async {
    final formMap = {'indicadorBloqueo': indicadorBloqueo, 'nis': nis, 'kwfxtoken':token };

    // Crear FormData
    final data = FormData.fromMap(formMap);

    final response = await dio.post(
      "${Environment.hostCtxMiCuenta}/v3/suministro/bloquearDesbloquear",
      data: data,
      // options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    if (response.statusCode == 200) {
      final bloqueosuministroResponse = BloqueoSuministroResponse.fromJson(
        response.data,
      );

      return bloqueosuministroResponse;
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
