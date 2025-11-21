import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:form/core/enviromens/enrivoment.dart';
import 'package:form/model/favoritos/datos_reclamo_model.dart';
import 'package:form/model/favoritos/favoritos_model.dart';
import 'package:form/model/favoritos/favoritos_tipo_model.dart';
import 'package:form/model/model.dart';
import 'package:form/utils/utils.dart';

import '../core/api/mi_ande_api.dart';
import '../datasources/reclamo_datasource.dart';

class ReclamoDatasourceImpl extends ReclamoDatasource {
  late final Dio dio;

  //  ReclamoDatasourceImpl(MiAndeApi api) : dio = api.dio;

  ReclamoDatasourceImpl(MiAndeApi api) : dio = api.dio;

  @override
  Future<ReclamoResponse> getReclamo(
    String telefono,
    TipoReclamo tipoReclamo,
    String nis,
    String nombreApellido,
    Departamento departamento,
    Ciudad ciudad,
    Barrio barrio,
    String direccion,
    String correo,
    String referencia,
    ArchivoAdjunto? archivo,
    String adjuntoObligatorio,
    double? latitud,
    double? longitud,
  ) async {
    final formMap = {
      'telefono': telefono,
      'idTipoReclamoCliente': tipoReclamo.idTipoReclamoCliente,
      'nis': nis,
      'nombreApellido': nombreApellido,
      'idDepartamento': departamento.idDepartamento,
      'idCiudad': ciudad.idCiudad,
      'idBarrio': barrio.idBarrio,
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

    if (latitud != null && longitud != null) {
      formMap['latitud'] = latitud;
      formMap['longitud'] = longitud;
    }

    // Crear FormData
    final data = FormData.fromMap(formMap);

    final response = await dio.post(
      "${Environment.hostCtxGra}/v1/reclamo/nuevoViaApp",
      data: data,
      // options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    if (response.statusCode == 200) {
      final reclamoResponse = ReclamoResponse.fromJson(response.data);

      //AGREGAR A FAVORITOS PARA ULTIMOS RECLAMOS REALIZADOS
      final nuevoFavorito = Favorito(
        id: reclamoResponse.reclamo!.numeroReclamo!,
        title: reclamoResponse.reclamo!.numeroReclamo!,
        tipo: FavoritoTipo.datosReclamo,
        datos:DatosReclamo(
          grupoReclamo: 'FE', 
          numeroReclamo: reclamoResponse.reclamo!.numeroReclamo!, 
          fechaReclamo: obtenerFechaActual(), 
          idDepartamento: departamento.idDepartamento.toInt(), 
          departamentoDescripcion: departamento.nombre!, 
          idCiudad: ciudad.idCiudad.toInt(), 
          ciudadDescripcion: ciudad.nombre!, 
          idBarrio: barrio.idBarrio.toInt(), 
          barrioDescripcion: barrio.nombre!, 
          idTipoReclamoCliente: tipoReclamo.idTipoReclamoCliente.toInt(), 
          telefono: telefono, 
          nombreApellido: nombreApellido, 
          direccion: direccion, 
          correo: correo, 
          nis: nis, 
          adjuntoObligatorio: adjuntoObligatorio, 
          referencia: referencia)
      );

      await toggleFavoritoReclamo(nuevoFavorito);

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
