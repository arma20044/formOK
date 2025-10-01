



import '../datasources/ciudad_datasource.dart';
import '../model/ciudad.dart';
import '../repo/ciudad_repository.dart';

class CiudadRepositoryImpl extends CiudadRepository{


  final CiudadDatasource datasource;

  CiudadRepositoryImpl(this.datasource);

  @override
  Future<List<Ciudad>> getCiudad(num idDepartamento) {
    return datasource.getCiudad(idDepartamento);
  }

} 