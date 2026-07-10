import 'package:form/model/servicios_nis_telefono.dart';
import 'package:form/repo/repo.dart';
import '../datasources/datasources.dart';

class ServiciosNisRepositoryImpl extends ServiciosNisRepository {
  final ServiciosNisDatasource datasource;

  ServiciosNisRepositoryImpl(this.datasource);

  @override
  Future<ServiciosNisTelefonoResponse> getServiciosNis(
    String nis,
    String token,
  ) {
    return datasource.getServiciosNis(nis, token);
  }

  @override
  Future<ServiciosNisTelefonoResponse> getServiciosBorrarCelular(
    String nis,
    String numeroMovil,
    String token,
  ) {
    return datasource.getServiciosBorrarCelular(nis, numeroMovil, token);
  }

  @override
  Future<ServiciosNisTelefonoResponse> getServiciosModificarServicio(
    String nis,
    String numeroMovil,
    String token,
    String codigoServicio,
    String estado,
  ) {
    return datasource.getServiciosModificarServicio(
      nis,
      numeroMovil,
      token,
      codigoServicio,
      estado,
    );
  }
}
