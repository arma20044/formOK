



import 'package:form/model/servicios_nis_telefono.dart';
import 'package:form/repo/repo.dart';
import '../datasources/datasources.dart';


class ServiciosNisRepositoryImpl extends ServiciosNisRepository{


  final ServiciosNisDatasource datasource;

  ServiciosNisRepositoryImpl(this.datasource);

  @override
  Future<ServiciosNisTelefonoResponse> getServiciosNis(String nis,String token) {
    return datasource.getServiciosNis(nis,token);
  }

} 