



import '../datasources/barrio_datasource.dart';
import '../model/barrio.dart';
import '../repo/barrio_repository.dart';

class BarrioRepositoryImpl extends BarrioRepository{


  final BarrioDatasource datasource;

  BarrioRepositoryImpl(this.datasource);

  @override
  Future<List<Barrio>> getBarrio(num idCiudad) {
    return datasource.getBarrio(idCiudad);
  }

} 