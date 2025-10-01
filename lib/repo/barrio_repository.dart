



import '../model/barrio.dart';


abstract class BarrioRepository {

  Future<List<Barrio>> getBarrio(num idCiudad);


}