

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/enviromens/enrivoment.dart';
import 'package:form/datasources/consulta_facturas_datasource.dart';
import 'package:form/model/model.dart';

import '../core/api/mi_ande_api.dart';
import '../model/archivo_adjunto_model.dart';


class ConsultaFacturasDatasourceImpl extends ConsultaFacturasDatasource {
  late final Dio dio;
  

  //  ConsultaFacturasDatasourceImpl(MiAndeApi api) : dio = api.dio;

  ConsultaFacturasDatasourceImpl(MiAndeApi api) : dio = api.dio;

  @override
  Future<ConsultaFacturas> getConsultaFacturas(    
    String nis,
    String cantidad,
    String token
  ) async {




    final formMap = {
      

      'nis': nis,
      'cantidad': cantidad,
     'kwfxtoken' : token
    };

     

    // Crear FormData
    final data = FormData.fromMap(formMap);

    //final response = await dio.post("${Environment.hostCtxOpen}/v5/suministro/ultimasFacturasPublico",
    final response = await dio.post("${Environment.hostCtxMiCuenta}/v3/suministro/ultimasFacturas",
      data: data,
     // options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    if (response.statusCode == 200) {
      final consultaFacturasResponse = ConsultaFacturas.fromJson(response.data);

      return consultaFacturasResponse;
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
