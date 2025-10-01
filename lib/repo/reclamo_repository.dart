

import 'package:form/model/model.dart';

import '../model/archivo_adjunto_model.dart';

abstract class ReclamoRepository {

  Future<ReclamoResponse> getReclamo(String telefono, num tipoReclamo, String nis, String nombreApellido, num departamento, num ciudad, num barrio,
  String direccion, String correo, String referencia,ArchivoAdjunto? archivo,String adjuntoObligatorio, double? latitud, double? longitud);


}