import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/core/enviromens/Enrivoment.dart';
import 'package:form/datasources/datasources.dart';
import 'package:form/model/model.dart';

class HistoricoConsumoMontoDatasourceImpl
    extends HistoricoConsumoMontoDatasource {
  late final Dio dio;

  //   HistoricoConsumoMontoDatasourceImpl(MiAndeApi api) : dio = api.dio;

  HistoricoConsumoMontoDatasourceImpl(MiAndeApi api) : dio = api.dio;

  @override
  Future<HistoricoConsumoMonto> getHistoricoConsumoMonto(
    String nis,
    String conCuenta,
    String token,
  ) async {
    var data = FormData.fromMap({
      'nis': nis,
      'conCuenta': conCuenta,
      'kwfxtoken': token,
      'clientKey': Environment.clientKey,
    });

    final response = await dio.post(
      "${Environment.hostCtxOpen}/v4/suministro/historicoConsumoMontoWebHost",
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
      final historico = HistoricoConsumoMonto.fromJson(jsonData);

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
