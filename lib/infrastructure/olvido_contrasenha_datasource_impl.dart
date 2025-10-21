


import 'package:dio/dio.dart';
import 'package:form/model/olvido_contrasenha.dart';

import '../core/api/mi_ande_api.dart';
import '../core/enviromens/Enrivoment.dart';
import '../datasources/datasources.dart';


class OlvidoContrasenhaDatasourceImpl extends OlvidoContrasenhaDatasource {

  late final Dio dio;

  //  OlvidoContrasenhaDatasourceImpl(MiAndeApi api) : dio = api.dio;


  OlvidoContrasenhaDatasourceImpl(MiAndeApi api) : dio = api.dio;

  

   

  @override
  Future<OlvidoContrasenhaResponse> getOlvidoContrasenha(String tipoDocumento, String documentoIdentificacion, String viaCambio, String cedulaRepresenante, String tipoSolicitante) async{

   var data = FormData.fromMap({      
       'tipoDocumento': tipoDocumento,
       'documentoIdentificacion': documentoIdentificacion,
       'viaCambio': viaCambio,
       'cedulaRepresentante':cedulaRepresenante,
       'tipoSolicitante': tipoSolicitante
      });

    
  
    final response = await dio.post("${Environment.hostCtxRegistroUnico}/v1/recuperarPassword",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType, // 👈 importante
        )
    );

    print('URL llamada: ${response.requestOptions.uri}');

  if (response.statusCode == 200) {
      final olvidoContrasenhaResponse = OlvidoContrasenhaResponse.fromJson(response.data);
      return olvidoContrasenhaResponse;
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