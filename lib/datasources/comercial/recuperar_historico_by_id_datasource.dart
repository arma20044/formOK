import 'package:form/model/comercial/historico_recuperar.dart';

import '../../model/model.dart';

abstract class RecuperarHistoricoDatasource {
  Future<RecuperarHistorico> getRecuperarHistorico(String id, String token);
}
