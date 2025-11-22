import '../datasources/datasources.dart';
import '../model/model.dart';
import '../repo/repo.dart';

class MiCuentaRegistroRepositoryImpl extends MiCuentaRegistroRepository {
  final MiCuentaRegistroDatasource datasource;

  MiCuentaRegistroRepositoryImpl(this.datasource);

  //   catastro_adjuntoCi1Extra, catastro_adjuntoCi2Extra, catastro_adjuntoFotoPersonal1Extra, catastro_adjuntoFotoPersonal2Extra,

  @override
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
  }) {
    return datasource.getMiCuentaRegistro(
    actualizarDatos:  actualizarDatos,
      tipoCliente:tipoCliente,
      tipoSolicitante:tipoSolicitante,
      tipoDocumento:tipoDocumento,
      cedulaRepresentante:cedulaRepresentante,
      numeroDocumento:numeroDocumento,
      nombre:nombre,
      apellido: apellido,
      pais: pais,
      departamento:departamento,
      ciudad:ciudad,
      direccion:direccion,
      correo:correo,
      telefonoFijo:telefonoFijo,
      numeroTelefonoCelular:numeroTelefonoCelular,
      password:password,
      confirmacionPassword:confirmacionPassword,
      passwordAnterior:passwordAnterior,
      tipoVerificacion:tipoVerificacion,

      solicitudOTP:solicitudOTP,
      codigoOTP:codigoOTP,

      ci1:ci1,
      ci1Extra:ci1Extra,
      ci2:ci2,
      ci2Extra:ci2Extra,

      fotoPersonal1:fotoPersonal1,
      fotoPersonal1Extra:fotoPersonal1Extra,
      fotoPersonal2:fotoPersonal2,
      fotoPersonal2Extra:fotoPersonal2Extra,
    );
  }
}
