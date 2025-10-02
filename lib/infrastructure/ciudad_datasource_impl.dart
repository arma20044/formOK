


import 'package:dio/dio.dart';

import '../core/api/mi_ande_api.dart';
import '../core/enviromens/Enrivoment.dart';
import '../datasources/ciudad_datasource.dart';
import '../model/ciudad.dart';

class CiudadDatasourceImpl extends CiudadDatasource {

  late final Dio dio;

  //  CiudadDatasourceImpl(MiAndeApi api) : dio = api.dio;


  CiudadDatasourceImpl(MiAndeApi api) : dio = api.dio;

  

   

  @override
  Future<List<Ciudad>> getCiudad(num idDepartamento) async{

   var data = FormData.fromMap({      
        'idDepartamento': idDepartamento,
      });

    
  
    final response = await dio.post("${Environment.hostCtxGra}/v1/reclamo/listarCiudades",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType, // 👈 importante
        )
    );

    print('URL llamada: ${response.requestOptions.uri}');

  if (response.statusCode == 200) {
      final List<dynamic> rawList = response.data['respuesta']['datos'];
      return rawList.map((json) => Ciudad.fromJson(json)).toList();
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