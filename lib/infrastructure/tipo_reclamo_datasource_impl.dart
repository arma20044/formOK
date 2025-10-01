

import 'package:dio/dio.dart';

import '../datasources/datasources.dart';
import '../model/model.dart';


class TipoReclamoDatasourceImpl extends TipoReclamoDatasource {

  late final Dio dio;

  TipoReclamoDatasourceImpl() : dio = Dio(
    BaseOptions()
  );

    var data = FormData.fromMap({
        'clientKey': 'iBLQWFskMfSF5oGhD2a1UYNZyuYo0tdh',
        'categoriaWebAppJsonArray': '["FE"]',
      });

  @override
  Future<List<TipoReclamo>> getTipoReclamo() async{
  
    final response = await dio.post(
      "https://desa1.ande.gov.py:8481/sigaWs/api/gra/v1/reclamo/listarTipoReclamoPorCategoria",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType, // 👈 importante
        )
    );

  if (response.statusCode == 200) {
      final List<dynamic> rawList = response.data['respuesta']['datos'];
      return rawList.map((json) => TipoReclamo.fromJson(json)).toList();
    } else {
      throw Exception('Error ${response.statusCode}');
    }

     
    
  }
  
}