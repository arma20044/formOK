import '../datasources/datasources.dart';
import '../model/archivo_adjunto_model.dart';
import '../model/model.dart';
import '../repo/repo.dart';

class MiCuentaRegistroRepositoryImpl extends MiCuentaRegistroRepository {
  final MiCuentaRegistroDatasource datasource;

  MiCuentaRegistroRepositoryImpl(this.datasource);

  //   catastro_adjuntoCi1Extra, catastro_adjuntoCi2Extra, catastro_adjuntoFotoPersonal1Extra, catastro_adjuntoFotoPersonal2Extra,

  @override
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
  ) {
    return datasource.getMiCuentaRegistro(
      actualizarDatos,
      tipoRegistro,
      tipoSolicitante,
      tipoDocumento,
      tipoCliente,
      cedulaRepresentante,
      numeroDocumento,
      nombre,
      apellido,
      pais,
      departamento,
      ciudad,
      direccion,
      correo,
      telefonoFijo,
      numeroTelefonoCelular,
      password,
      confirmacionPassword,
      passwordAnterior,
      tipoVerificacion,

      solicitudOTP,
      codigoOTP,

      ci1,
      ci1Extra,
      ci2,
      ci2Extra,

      fotoPersonal1,
      fotoPersonal1Extra,
      fotoPersonal2,
      fotoPersonal2Extra,
    );
  }
}
