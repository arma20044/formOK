import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/core/enviromens/enrivoment.dart';
import 'package:form/datasources/comercial/solicitudes/solicitud_yo_facturo_mi_luz_datasource.dart';
import 'package:form/model/model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SolicitudYoFacturoMiLuzDatasourceImp
    extends SolicitudYoFacturoMiLuzDatasource {
  late final Dio dio;

  //   OlicitudAbastecimiento(MiAndeApi api) : dio = api.dio;

  SolicitudYoFacturoMiLuzDatasourceImp(MiAndeApi api) : dio = api.dio;

  @override
  Future<SolicitudYoFacturoMiLuzResponse> getSolicitudYoFacturoMiLuz(
    String tipoTension,
    String nis,
    String lectura,
    String titularNumeroTelefono,
    List<ArchivoAdjunto>? selectedFileSolicitudList,
    List<ArchivoAdjunto>? selectedFileFotocopiaAutenticadaList,
    List<ArchivoAdjunto>? selectedFileFotocopiaSimpleCedulaSolicitanteList,
    List<ArchivoAdjunto>? selectedFileCopiaSimpleCarnetElectricistaList,
    List<ArchivoAdjunto>? selectedFileTituloPropiedadList,
    List<ArchivoAdjunto>? selectedFileOtrosDocumentosList,
    String? solicitudOTP,
    String? codigoOTP
  ) async {
    final Map<String, Object> formMap = {
      'nis': nis,
      'lectura': lectura,     
      'numeroMovil': titularNumeroTelefono,   
      'clientKey': environment.clientKey,     
      'solicitudOTP': solicitudOTP ?? 'N',
      'codigoOTP': codigoOTP ?? '00',
    };
    try {
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
    } catch (e) {
      log(e.toString());
    }

    if (selectedFileFotocopiaAutenticadaList!.isNotEmpty) {
      int pos = 0;
      for (var foto in selectedFileFotocopiaAutenticadaList) {
        pos++;
        formMap['saee_adjuntoTituloPropiedad$pos'] = [
          await MultipartFile.fromFile(
            foto.file.path,
            filename: foto.file.path.split('/').last,
          ),
        ];
        formMap['saee_adjuntoTituloPropiedad${pos}Extra'] = jsonEncode(
          foto.info,
        );
      }
    }

    if (selectedFileFotocopiaSimpleCedulaSolicitanteList!.isNotEmpty) {
      int pos = 0;
      for (var foto in selectedFileFotocopiaSimpleCedulaSolicitanteList) {
        pos++;
        formMap['saee_adjuntoCiSolicitante$pos'] = [
          await MultipartFile.fromFile(
            foto.file.path,
            filename: foto.file.path.split('/').last,
          ),
        ];
        formMap['saee_adjuntoCiSolicitante${pos}Extra'] = jsonEncode(foto.info);
      }
    }

    if (selectedFileCopiaSimpleCarnetElectricistaList!.isNotEmpty) {
      int pos = 0;
      for (var foto in selectedFileCopiaSimpleCarnetElectricistaList) {
        pos++;
        formMap['saee_adjuntoCarnetElectricista$pos'] = [
          await MultipartFile.fromFile(
            foto.file.path,
            filename: foto.file.path.split('/').last,
          ),
        ];
        formMap['saee_adjuntoCarnetElectricista${pos}Extra'] = jsonEncode(
          foto.info,
        );
      }
    }

    if (selectedFileTituloPropiedadList != null && selectedFileTituloPropiedadList.isNotEmpty) {
      int pos = 0;
      for (var foto in selectedFileTituloPropiedadList) {
        pos++;
        formMap['saee_adjuntoTituloPropiedad$pos'] = [
          await MultipartFile.fromFile(
            foto.file.path,
            filename: foto.file.path.split('/').last,
          ),
        ];
        formMap['saee_adjuntoTituloPropiedad${pos}Extra'] = jsonEncode(
          foto.info,
        );
      }
    }

    if (selectedFileOtrosDocumentosList != null && selectedFileOtrosDocumentosList.isNotEmpty) {
      int pos = 0;
      for (var foto in selectedFileOtrosDocumentosList) {
        pos++;
        formMap['saee_adjuntoOtro$pos'] = [
          await MultipartFile.fromFile(
            foto.file.path,
            filename: foto.file.path.split('/').last,
          ),
        ];
        formMap['saee_adjuntoOtro${pos}Extra'] = jsonEncode(foto.info);
      }
    }
    // Crear FormData
    final data = FormData.fromMap(formMap);

    String urlFinal = tipoTension == 'BT' 
    ? "v4/suministro/lecturaAportadaPublico"
    : "v4/suministro/lecturaAportadaPublicoMT";

    final response = await dio.post(
      "${environment.hostCtxOpen}/$urlFinal",
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType, 
      ),
    );



    if (response.statusCode == 200) {
      // Dio ya devuelve un Map
      final Map<String, dynamic> jsonData =
          response.data as Map<String, dynamic>;

      // Convierte todo a tu modelo
      final historico = SolicitudYoFacturoMiLuzResponse.fromJson(jsonData);

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
