import 'package:dio/dio.dart';
import 'package:form/core/enviromens/Enrivoment.dart';
import 'package:form/model/model.dart';

import '../core/api/mi_ande_api.dart';

import '../datasources/datasources.dart';

class ConsultaDocumentoDatasourceImpl extends ConsultaDocumentoDatasource {
  late final Dio dio;

  //  ConsultaDocumentoDatasourceImpl(MiAndeApi api) : dio = api.dio;

  ConsultaDocumentoDatasourceImpl(MiAndeApi api) : dio = api.dio;

  @override
  Future<ConsultaDocumentoResultado> getConsultaDocumento(
    String numerodocumento,
    String tipoDocumento,
  ) async {
    late List<String> rucString;
    if (tipoDocumento.contains('TD002')) {
      rucString = numerodocumento.split('-');
    }

    var data = FormData.fromMap({
      'cedula': tipoDocumento.contains('TD002') ? rucString[0] : numerodocumento,
      'dv': tipoDocumento.contains('TD002') ? rucString[1] : '',
      'ruc':  tipoDocumento.contains('TD002') ? rucString[0] : '',
    });

    String urlConsulta = tipoDocumento.compareTo('TD001') == 0
        ? '/v4/mitic/consultaPorCedulaMobile'
        : '/v4/mitic/consultaSetMobile';

    final response = await dio.post(
      "${Environment.hostCtxOpen}$urlConsulta",
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType, // 👈 importante
      ),
    );

    print('URL llamada: ${response.requestOptions.uri}');

    if (response.statusCode == 200) {
      final rawMap = response.data['resultado'] as Map<String, dynamic>;
      return ConsultaDocumentoResultado.fromJson(rawMap);
      /*return ConsultaDocumentoResponse(
        error: true,
        errorValList: [],
        mensaje: "",
        resultado: ConsultaDocumentoResultado(
          nacionalidadBean: "nacionalidadBean",
          fechNacim: "fechNacim",
          cedula: 1,
          profesionBean: "profesionBean",
          apellido: "apellido",
          estadoCivil: "estadoCivil",
          sexo: "sexo",
          nombres: "nombres",
        ),
      );*/
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
