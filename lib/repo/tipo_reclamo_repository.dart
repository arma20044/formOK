



import '../model/model.dart';

abstract class TipoReclamoRepository {

  Future<List<TipoReclamo>> getTipoReclamo(String tipoReclamo);


}