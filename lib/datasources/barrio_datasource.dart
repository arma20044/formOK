



import '../model/barrio.dart';


abstract class BarrioDatasource {

  Future<List<Barrio>> getBarrio(num idCiudad);


}