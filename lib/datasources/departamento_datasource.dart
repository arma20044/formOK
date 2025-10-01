

import '../model/departamento.dart';

abstract class DepartamentoDatasource {

  Future<List<Departamento>> getDepartamento();


}