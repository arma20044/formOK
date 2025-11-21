



import '../model/model.dart';

abstract class ReclamoDatasource {

  Future<ReclamoResponse> getReclamo(String telefono, TipoReclamo tipoReclamo, String nis, String nombreApellido, Departamento departamento, Ciudad ciudad, Barrio barrio,
  String direccion, String correo, String referencia,ArchivoAdjunto? archivo, String adjuntoObligatorio, double? latitud, double? longitud);


}