import 'package:form/repo/repo.dart';

import '../../datasources/datasources.dart';
import '../../model/model.dart';

class RecuperarHistoricoRepositoryImpl
    extends RecuperarHistoricoRepository {
  final RecuperarHistoricoDatasource datasource;

  RecuperarHistoricoRepositoryImpl(this.datasource);

  @override
  Future<RecuperarHistorico> getRecuperarHistorico(
    String id,
    String token
  ) {
    return datasource.getRecuperarHistorico(id,token);
  }
}
