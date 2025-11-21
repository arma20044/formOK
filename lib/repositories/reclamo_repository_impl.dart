


import 'package:form/model/barrio.dart';
import 'package:form/model/ciudad.dart';
import 'package:form/model/departamento.dart';
import 'package:form/model/tipo_reclamo_model.dart';

import '../datasources/reclamo_datasource.dart';
import '../model/archivo_adjunto_model.dart';
import '../model/reclamo_model.dart';
import '../repo/reclamo_repository.dart';

class ReclamoRepositoryImpl extends ReclamoRepository{


  final ReclamoDatasource datasource;

  ReclamoRepositoryImpl(this.datasource);

  @override
  Future<ReclamoResponse> getReclamo(String telefono, TipoReclamo tipoReclamo, String nis, String nombreApellido, Departamento departamento, Ciudad ciudad, Barrio barrio, String direccion, String correo, String referencia,ArchivoAdjunto? archivo,String adjuntoObligatorio, double? latitud, double? longitud ) {
    return datasource.getReclamo(telefono, tipoReclamo, nis,nombreApellido,departamento,ciudad,barrio,direccion,correo,referencia,archivo,adjuntoObligatorio,latitud,longitud);
  }

} 