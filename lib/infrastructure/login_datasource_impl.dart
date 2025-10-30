import 'package:dio/dio.dart';
import 'package:form/core/enviromens/Enrivoment.dart';
import 'package:form/model/login_model.dart';

import '../core/api/mi_ande_api.dart';

import '../datasources/Login_datasource.dart';

class LoginDatasourceImpl extends LoginDatasource {
  late final Dio dio;

  //  LoginDatasourceImpl(MiAndeApi api) : dio = api.dio;

  LoginDatasourceImpl(MiAndeApi api) : dio = api.dio;

  @override
  Future<Login> getLogin(
    String username,
    String password,
    String tipoDocumento,
    String tipoSolicitante,
    String documentoSolicitante,
  ) async {
    var data = FormData.fromMap({
      'tipoDocumento': tipoDocumento,
      'password': password,
      'documentoIdentificacion': username,
      'cedulaRepresentante': documentoSolicitante.isEmpty
          ? 'lteor'
          : documentoSolicitante,
      'tipoSolicitante': tipoSolicitante.isEmpty
          ? 'Sin registros'
          : tipoSolicitante,
    });

    final response = await dio.post(
      "${Environment.hostCtxRegistroUnico}/v2/acceder",
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType, // 👈 importante
      ),
    );

    print('URL llamada: ${response.requestOptions.uri}');

    if (response.statusCode == 200) {
      //final List<dynamic> rawList = response.data;
      //return rawList.map((json) => Login.fromJson(json)).toList();
      // return rawList.map((json) => Login.fromJson(json)).first;
      final loginResponse = Login.fromJson(response.data);

      return loginResponse;
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
