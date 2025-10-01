import 'package:dio/dio.dart';

import '../core/api/mi_ande_api.dart';
import '../datasources/barrio_datasource.dart';

import '../model/barrio.dart';

class BarrioDatasourceImpl extends BarrioDatasource {
  late final Dio dio;

  //  BarrioDatasourceImpl(MiAndeApi api) : dio = api.dio;

  BarrioDatasourceImpl(MiAndeApi api) : dio = api.dio;

  @override
  Future<List<Barrio>> getBarrio(num idCiudad) async {
    var data = FormData.fromMap({
      'clientKey': 'iBLQWFskMfSF5oGhD2a1UYNZyuYo0tdh',
      'idCiudad': idCiudad,
      'tipoLista' : 2,
      'filtro': idCiudad
    });

    final response = await dio.post(
      "/gra/v1/reclamo/listarBarrios",
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType, // 👈 importante
      ),
    );

    print('URL llamada: ${response.requestOptions.uri}');

    if (response.statusCode == 200) {
      final List<dynamic> rawList = response.data['respuesta']['datos'];
      return rawList.map((json) => Barrio.fromJson(json)).toList();
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
