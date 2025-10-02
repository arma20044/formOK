

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:form/core/enviromens/enrivoment.dart';
import 'package:form/model/model.dart';

import '../core/api/mi_ande_api.dart';
import '../datasources/reclamo_datasource.dart';
import '../model/archivo_adjunto_model.dart';


class ReclamoDatasourceImpl extends ReclamoDatasource {
  late final Dio dio;

  //  ReclamoDatasourceImpl(MiAndeApi api) : dio = api.dio;

  ReclamoDatasourceImpl(MiAndeApi api) : dio = api.dio;

  @override
  Future<ReclamoResponse> getReclamo(
    String telefono,
    num tipoReclamo,
    String nis,
    String nombreApellido,
    num departamento,
    num ciudad,
    num barrio,
    String direccion,
    String correo,
    String referencia,
    ArchivoAdjunto? archivo,
    String adjuntoObligatorio,
    double? latitud,
    double? longitud
  ) async {
    final formMap = {
      

      'telefono': telefono,
      'idTipoReclamoCliente': tipoReclamo,
      'nis': nis,
      'nombreApellido': nombreApellido,
      'idDepartamento': departamento,
      'idCiudad': ciudad,
      'idBarrio': barrio,
      'direccion': direccion,
      'correo': correo,
      'referencia': referencia,
      'adjuntoObligatorio': adjuntoObligatorio,
    };

    // Solo agregar archivo si existe
    if (archivo != null) {
      formMap['reclamo_adjunto1'] = [
        await MultipartFile.fromFile(
          archivo.file.path,
          filename: archivo.file.path.split('/').last,
        ),
      ];
      formMap['reclamo_adjunto1Extra'] = jsonEncode(archivo.info);
    }

    if(latitud != null && longitud != null){
      formMap['latitud'] = latitud;
      formMap['longitud'] = longitud;
    }

    // Crear FormData
    final data = FormData.fromMap(formMap);

    final response = await dio.post("${Environment.hostCtxGra}/v1/reclamo/nuevoViaApp",
      data: data,
     // options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    if (response.statusCode == 200) {
      final reclamoResponse = ReclamoResponse.fromJson(response.data);

      return reclamoResponse;
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
