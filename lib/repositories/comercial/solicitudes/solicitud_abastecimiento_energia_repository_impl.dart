import 'package:form/datasources/datasources.dart';
import 'package:form/model/model.dart';
import 'package:form/repo/repo.dart';

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
    ArchivoAdjunto? archivo,
  ) {
    return datasource.getSolicitudAbastecimiento(
      titularNombres,
      titularApellidos,
      titularDocumentoNumero,
      titularNumeroTelefono,
      titularCorreo,
      idTipoReclamo,
      archivo,
    );
  }
}
