import '../model/archivo_adjunto_model.dart';
import '../model/model.dart';

abstract class MiCuentaRegistroDatasource {
  Future<MiCuentaRegistroResponse> getMiCuentaRegistro(
    String actualizarDatos,
    num tipoRegistro,
    num tipoSolicitante,
    num tipoDocumento,
    num tipoCliente,
    String cedulaRepresentante,
    String numeroDocumento,
    String nombre,
    String apellido,
    String pais,
    String departamento,
    String ciudad,
    String direccion,
    String correo,
    String telefonoFijo,
    String numeroTelefonoCelular,
    String password,
    String confirmacionPassword,
    String passwordAnterior,
    num tipoVerificacion,

    String solicitudOTP,
    String codigoOTP,

    ArchivoAdjunto? ci1,
    String? ci1Extra,
    ArchivoAdjunto? ci2,
    String? ci2Extra,

    ArchivoAdjunto? fotoPersonal1,
    String? fotoPersonal1Extra,
    ArchivoAdjunto? fotoPersonal2,
    String? fotoPersonal2Extra,
  );
}
