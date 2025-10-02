

import '../model/model.dart';

abstract class TipoReclamoDatasource {

  Future<List<TipoReclamo>> getTipoReclamo(String tipoReclamo);


}