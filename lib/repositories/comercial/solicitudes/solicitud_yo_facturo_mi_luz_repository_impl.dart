import 'package:form/datasources/datasources.dart';
import 'package:form/model/model.dart';
import 'package:form/repo/repo.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SolicitudYoFacturoMiLuzRepositoryImpl
    extends SolicitudYoFacturoMiLuzRepository {
  final SolicitudYoFacturoMiLuzDatasource datasource;

  SolicitudYoFacturoMiLuzRepositoryImpl(this.datasource);

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
    String? codigoOTP,

   
    String? lecturaActualActiva,
    String? lecturaActualReactiva,
    String? lecturaActualPotencia,
  ) {
    return datasource.getSolicitudYoFacturoMiLuz(
      tipoTension,
      nis,
      lectura,
      titularNumeroTelefono,
      selectedFileSolicitudList,
      selectedFileFotocopiaAutenticadaList,
      selectedFileFotocopiaSimpleCedulaSolicitanteList,
      selectedFileCopiaSimpleCarnetElectricistaList,
      selectedFileTituloPropiedadList,
      selectedFileOtrosDocumentosList,
      solicitudOTP,
      codigoOTP,

      
    lecturaActualActiva,
     lecturaActualReactiva,
     lecturaActualPotencia,
     
    );
  }
}
