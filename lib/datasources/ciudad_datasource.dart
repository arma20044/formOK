



import '../model/ciudad.dart';

abstract class CiudadDatasource {

  Future<List<Ciudad>> getCiudad(num idDepartamento);


}