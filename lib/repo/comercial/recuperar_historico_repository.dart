import 'package:form/model/model.dart';

abstract class RecuperarHistoricoRepository {
  Future<RecuperarHistorico> getRecuperarHistorico(
     String id,
    String token
  );
}
