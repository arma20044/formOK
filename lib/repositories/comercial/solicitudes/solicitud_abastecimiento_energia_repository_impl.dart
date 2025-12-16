import 'package:form/datasources/datasources.dart';
import 'package:form/model/model.dart';
import 'package:form/repo/repo.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SolicitudAbastecimientoRepositoryImpl
    extends SolicitudAbastecimientoRepository {
  final SolicitudAbastecimientoDatasource datasource;

  SolicitudAbastecimientoRepositoryImpl(this.datasource);

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
    LatLng? latitudLongitud
  ) {
    return datasource.getSolicitudAbastecimiento(
      titularNombres,
      titularApellidos,
      titularDocumentoNumero,
      titularNumeroTelefono,
      titularCorreo,
      idTipoReclamo,
      selectedFileSolicitudList,
      selectedFileFotocopiaAutenticadaList,
      selectedFileFotocopiaSimpleCedulaSolicitanteList,
      selectedFileCopiaSimpleCarnetElectricistaList,
      selectedFileOtrosDocumentosList,
      latitudLongitud
    );
  }
}
