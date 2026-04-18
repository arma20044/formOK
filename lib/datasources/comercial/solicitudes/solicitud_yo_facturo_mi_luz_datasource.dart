import 'package:form/model/model.dart';

abstract class SolicitudYoFacturoMiLuzDatasource {
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
  );
}
