


import '../datasources/reclamo_datasource.dart';
import '../model/archivo_adjunto_model.dart';
import '../model/reclamo_model.dart';
import '../repo/reclamo_repository.dart';

class ReclamoRepositoryImpl extends ReclamoRepository{


  final ReclamoDatasource datasource;

  ReclamoRepositoryImpl(this.datasource);

  @override
  Future<ReclamoResponse> getReclamo(String telefono, num tipoReclamo, String nis, String nombreApellido, num departamento, num ciudad, num barrio, String direccion, String correo, String referencia,ArchivoAdjunto? archivo,String adjuntoObligatorio, double? latitud, double? longitud ) {
    return datasource.getReclamo(telefono, tipoReclamo, nis,nombreApellido,departamento,ciudad,barrio,direccion,correo,referencia,archivo,adjuntoObligatorio,latitud,longitud);
  }

} 