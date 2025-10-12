import 'package:form/model/model.dart';

abstract class MiCuentaRegistroRepository {
  Future<MiCuentaRegistroResponse> getMiCuentaRegistro({
    required String actualizarDatos,
    required num tipoCliente,
    required String tipoSolicitante,
    required String tipoDocumento,
    required String cedulaRepresentante,
    required String numeroDocumento,
    required String nombre,
    required String apellido,
    required String pais,
    required String departamento,
    required String ciudad,
    required String direccion,
    required String correo,
    required String telefonoFijo,
    required String numeroTelefonoCelular,
    required String password,
    required String confirmacionPassword,
    required String passwordAnterior,
    required String tipoVerificacion,

    required String solicitudOTP,
    required String codigoOTP,

    ArchivoAdjunto? ci1,
    String? ci1Extra,
    ArchivoAdjunto? ci2,
    String? ci2Extra,

    ArchivoAdjunto? fotoPersonal1,
    String? fotoPersonal1Extra,
    ArchivoAdjunto? fotoPersonal2,
    String? fotoPersonal2Extra,
  });
}
