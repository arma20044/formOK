

import '../datasources/departamento_datasource.dart';
import '../model/departamento.dart';
import '../repo/departamento_repository.dart';

class DepartamentoRepositoryImpl extends DepartamentoRepository{


  final DepartamentoDatasource datasource;

  DepartamentoRepositoryImpl(this.datasource);

  @override
  Future<List<Departamento>> getDepartamento() {
    return datasource.getDepartamento();
  }

} 