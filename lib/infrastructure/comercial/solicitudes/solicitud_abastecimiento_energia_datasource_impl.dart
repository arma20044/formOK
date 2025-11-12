import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/core/enviromens/Enrivoment.dart';
import 'package:form/datasources/datasources.dart';
import 'package:form/model/model.dart';

class SolicitudAbastecimientoDatasourceImp
    extends SolicitudAbastecimientoDatasource {
  late final Dio dio;

  //   OlicitudAbastecimiento(MiAndeApi api) : dio = api.dio;

  SolicitudAbastecimientoDatasourceImp(MiAndeApi api) : dio = api.dio;

  @override
  Future<SolicitudAbastecimientoResponse> getSolicitudAbastecimiento(
    String titularNombres,
    String titularApellidos,
    String titularDocumentoNumero,
    String titularNumeroTelefono,
    String titularCorreo,
    String idTipoReclamo,
    List<ArchivoAdjunto>? selectedFileSolicitudList,
    List<ArchivoAdjunto>? selectedFileFotocopiaAutenticadaList,
    List<ArchivoAdjunto>? selectedFileFotocopiaSimpleCedulaSolicitanteList,
    List<ArchivoAdjunto>? selectedFileCopiaSimpleCarnetElectricistaList,
    List<ArchivoAdjunto>? selectedFileOtrosDocumentosList,
  ) async {
    final Map<String, Object> formMap = {
      'titularNombres': titularNombres,
      'titularApellidos': titularApellidos,
      'titularDocumentoNumero': titularDocumentoNumero,
      'titularNumeroTelefono': titularNumeroTelefono,
      'titularCorreo': titularCorreo,
      'idTipoReclamo': idTipoReclamo,
      'clientKey': Environment.clientKey,
    };

    if (selectedFileSolicitudList!.isNotEmpty) {
      int pos = 0;
      for (var foto in selectedFileSolicitudList) {
        pos++;
        formMap['saee_adjuntoSaee$pos'] = [
          await MultipartFile.fromFile(
            foto.file.path,
            filename: foto.file.path.split('/').last,
          ),
        ];
        formMap['saee_adjuntoSaee${pos}Extra'] = jsonEncode(foto.info);
      }
    }

    /* if (selectedFileFotocopiaAutenticada != null) {
      formMap['saee_adjuntoSaee1'] = [
        await MultipartFile.fromFile(
          selectedFileFotocopiaAutenticada.file.path,
          filename: selectedFileFotocopiaAutenticada.file.path.split('/').last,
        ),
      ];
      formMap['saee_adjuntoSaee1Extra'] = jsonEncode(
        selectedFileFotocopiaAutenticada.info,
      );
    }*/

    // Crear FormData
    final data = FormData.fromMap(formMap);

    final response = await dio.post(
      "${Environment.hostCtxOpen}/v4/solicitudAbastecimientoEnergiaElectrica/nuevo",
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType, // 👈 importante
      ),
    );

    print('URL llamada: ${response.requestOptions.uri}');

    if (response.statusCode == 200) {
      // Dio ya devuelve un Map
      final Map<String, dynamic> jsonData =
          response.data as Map<String, dynamic>;

      // Convierte todo a tu modelo
      final historico = SolicitudAbastecimientoResponse.fromJson(jsonData);

      return historico;
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
