



import '../model/ciudad.dart';

abstract class CiudadRepository {

  Future<List<Ciudad>> getCiudad(num idDepartamento);


}