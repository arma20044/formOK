



import 'package:dio/dio.dart';
import 'package:form/core/enviromens/Enrivoment.dart';

import '../core/api/mi_ande_api.dart';
import '../datasources/departamento_datasource.dart';
import '../model/departamento.dart';

class DepartamentoDatasourceImpl extends DepartamentoDatasource {

  late final Dio dio;

  //  DepartamentoDatasourceImpl(MiAndeApi api) : dio = api.dio;


  DepartamentoDatasourceImpl(MiAndeApi api) : dio = api.dio;

  

    var data = FormData.fromMap({
        //'clientKey': 'iBLQWFskMfSF5oGhD2a1UYNZyuYo0tdh',
        //'categoriaWebAppJsonArray': '["FE"]',
      });

  @override
  Future<List<Departamento>> getDepartamento() async{

  

    
  
    final response = await dio.post("${Environment.hostCtxGra}/v1/reclamo/listarDepartamentos",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType, // 👈 importante
        )
    );

    print('URL llamada: ${response.requestOptions.uri}');

  if (response.statusCode == 200) {
      final List<dynamic> rawList = response.data['respuesta']['datos'];
      return rawList.map((json) => Departamento.fromJson(json)).toList();
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