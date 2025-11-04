import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/core/enviromens/Enrivoment.dart';
import 'package:form/datasources/datasources.dart';
import 'package:form/model/model.dart';

class RecuperarHistoricoDatasourceImpl extends RecuperarHistoricoDatasource {
  late final Dio dio;

  //   RecuperarHistoricoDatasourceImpl(MiAndeApi api) : dio = api.dio;

  RecuperarHistoricoDatasourceImpl(MiAndeApi api) : dio = api.dio;

  @override
  Future<RecuperarHistorico> getRecuperarHistorico(
    String id,
    String token,
  ) async {
    var data = FormData.fromMap({
      'id': id,
      'kwfxtoken': token,
      'clientKey': Environment.clientKey,
    });

    final response = await dio.post(
      "${Environment.hostCtxOpen}/v4/suministro/historicoConsumoMontoWebHostRecuperar",
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
      final historico = RecuperarHistorico.fromJson(jsonData);

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
