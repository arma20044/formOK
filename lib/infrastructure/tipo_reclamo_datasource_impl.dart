

import 'package:dio/dio.dart';


import '../core/api/mi_ande_api.dart';
import '../core/enviromens/Enrivoment.dart';
import '../datasources/datasources.dart';
import '../model/model.dart';


class TipoReclamoDatasourceImpl extends TipoReclamoDatasource {

  late final Dio dio;

  TipoReclamoDatasourceImpl(MiAndeApi api) : dio = api.dio;

   

  @override
  Future<List<TipoReclamo>> getTipoReclamo(String tipoReclamo) async{
    

     var data = FormData.fromMap({       
        'categoriaWebAppJsonArray': '[\'${tipoReclamo}\']',
      });
  
    final response = await dio.post("${Environment.hostCtxGra}/v1/reclamo/listarTipoReclamoPorCategoria",
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