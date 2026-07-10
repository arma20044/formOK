import '../model/model.dart';

abstract class ServiciosNisDatasource {
  Future<ServiciosNisTelefonoResponse> getServiciosNis(
    String nis,
    String token,
  );
  Future<ServiciosNisTelefonoResponse> getServiciosBorrarCelular(
    String nis,
    String numeroMovil,
    String token,
  );
  Future<ServiciosNisTelefonoResponse> getServiciosModificarServicio(
    String nis,
    String numeroMovil,
    String token,
    String codigoServicio,
    String estado,
  );
}
