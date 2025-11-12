import 'package:form/model/model.dart';

abstract class SolicitudAbastecimientoRepository {
  Future<SolicitudAbastecimientoResponse> getSolicitudAbastecimiento(
    String titularNombres,
    String titularApellidos,
    String titularDocumentoNumero,
    String titularNumeroTelefono,
    String titularCorreo,
    String idTipoReclamo,
     ArchivoAdjunto? archivo,
  );
}
