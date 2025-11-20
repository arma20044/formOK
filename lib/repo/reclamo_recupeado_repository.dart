

import 'package:form/model/model.dart';


abstract class ReclamoRecuperadoRepository {

  Future<ReclamoRecuperadoResponse> getReclamoRecuperado(String telefono);


}