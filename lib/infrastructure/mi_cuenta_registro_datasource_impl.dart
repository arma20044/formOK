import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/enviromens/enrivoment.dart';
import 'package:form/model/model.dart';

import '../core/api/mi_ande_api.dart';
import '../datasources/datasources.dart';
import '../model/storage/userDatos.dart';

class MiCuentaRegistroDatasourceImpl extends MiCuentaRegistroDatasource {
  late final Dio dio;

  //  MiCuentaRegistroDatasourceImpl(MiAndeApi api) : dio = api.dio;

  MiCuentaRegistroDatasourceImpl(MiAndeApi api) : dio = api.dio;

  @override
  Future<MiCuentaRegistroResponse> getMiCuentaRegistro({
    required String actualizarDatos,
    required num tipoCliente,
    required String tipoSolicitante,
    required String tipoDocumento,
    required String cedulaRepresentante,
    required String numeroDocumento,
    required String nombre,
    required String apellido,
    required String pais,
    required String departamento,
    required String ciudad,
    required String direccion,
    required String correo,
    required String telefonoFijo,
    required String numeroTelefonoCelular,
    required String password,
    required String confirmacionPassword,
    required String passwordAnterior,
    required String tipoVerificacion,

    required String solicitudOTP,
    required String codigoOTP,

    ArchivoAdjunto? ci1,
    String? ci1Extra,
    ArchivoAdjunto? ci2,
    String? ci2Extra,

    ArchivoAdjunto? fotoPersonal1,
    String? fotoPersonal1Extra,
    ArchivoAdjunto? fotoPersonal2,
    String? fotoPersonal2Extra,
  }) async {
    late final formMap = {
      'actualizarDatos': actualizarDatos,
      'tipoCliente': tipoCliente,
      'tipoSolicitante': tipoSolicitante,
      'tipoDocumento': tipoDocumento,
      'cedulaRepresentante': cedulaRepresentante,
      'numeroDocumento': numeroDocumento,
      'nombre': nombre,
      'apellido': apellido,
      'pais': pais,
      'departamento': departamento,
      'ciudad': ciudad,
      'direccion': direccion,
      'correo': correo,
      'telefonoFijo': telefonoFijo,
      'numeroTelefonoCelular': numeroTelefonoCelular,
      'password': password,
      'confirmacionPassword': confirmacionPassword,
      'passwordAnterior': passwordAnterior,
      'tipoVerificacion': tipoVerificacion,

      'solicitudOTP': solicitudOTP,
      'codigoOTP': codigoOTP,
    };

    // Solo agregar archivo si existe
    if (ci1 != null) {
      formMap['catastro_adjuntoCi1'] = [
        await MultipartFile.fromFile(
          ci1.file.path,
          filename: ci1.file.path.split('/').last,
        ),
      ];
      formMap['catastro_adjuntoCi1Extra'] = jsonEncode(ci1.info);
    }

    if (ci2 != null) {
      formMap['catastro_adjuntoCi2'] = [
        await MultipartFile.fromFile(
          ci2.file.path,
          filename: ci2.file.path.split('/').last,
        ),
      ];
      formMap['catastro_adjuntoCi2Extra'] = jsonEncode(ci2.info);
    }

    if (fotoPersonal1 != null) {
      formMap['catastro_adjuntoFotoPersonal1'] = [
        await MultipartFile.fromFile(
          fotoPersonal1.file.path,
          filename: fotoPersonal1.file.path.split('/').last,
        ),
      ];
      formMap['catastro_adjuntoFotoPersonal1Extra'] = jsonEncode(
        fotoPersonal1.info,
      );
    }

    if (fotoPersonal2 != null) {
      formMap['catastro_adjuntoFotoPersonal2'] = [
        await MultipartFile.fromFile(
          fotoPersonal2.file.path,
          filename: fotoPersonal2.file.path.split('/').last,
        ),
      ];
      formMap['catastro_adjuntoFotoPersonal2Extra'] = jsonEncode(
        fotoPersonal2.info,
      );
    }

    // Crear FormData
    final data = FormData.fromMap(formMap);

    //ver
    final _storage = const FlutterSecureStorage();
    String? datosSesion = await _storage.read(key: 'user_data');

    String token = "";
    if (datosSesion != null) {
      var datosJson = json.decode(datosSesion);
      final jsonObject = DatosUser.fromJson(datosJson);
      token = jsonObject.token;
    }

    String url = "";
    if (tipoCliente == 1 && (token != "")) {
      url = '${Environment.hostCtxRegistroUnico}/v1/actualizarDatos';
    } else {
      url = '${Environment.hostCtxRegistroUnico}/v1/agregar';
    }

    final response = await dio.post(
      url,
      data: data,
      // options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    if (response.statusCode == 200) {
      final miCuentaRegistroResponse = MiCuentaRegistroResponse.fromJson(
        response.data,
      );

      return miCuentaRegistroResponse;
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
