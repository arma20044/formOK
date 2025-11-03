import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:form/core/enviromens/enrivoment.dart';

import 'package:form/model/model.dart';

import '../../core/api/mi_ande_api.dart';
import '../../datasources/datasources.dart';

class MiCuentaSituacionActualDatasourceImpl extends MiCuentaSituacionActualDatasource {
  late final Dio dio;

  //  MiCuentaSituacionActualDatasourceImpl(MiAndeApi api) : dio = api.dio;

  MiCuentaSituacionActualDatasourceImpl(MiAndeApi api) : dio = api.dio;

  @override
  Future<MiCuentaSituacionActualResponse> getMiCuentaSituacionActual(
    String nis,   
    String token
  ) async {
    final formMap = { 'nis': nis, 'kwfxtoken':token };

    // Crear FormData
    final data = FormData.fromMap(formMap);

    final response = await dio.post(
      "${Environment.hostCtxMiCuenta}/v3/suministro/situacionActual",
      data: data,
      // options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    if (response.statusCode == 200) {
      final micuentasituacionactualResponse = MiCuentaSituacionActualResponse.fromJson(
        response.data,
      );

      return micuentasituacionactualResponse;
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
