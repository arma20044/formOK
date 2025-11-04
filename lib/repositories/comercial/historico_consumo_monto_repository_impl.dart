import 'package:form/repo/repo.dart';

import '../../datasources/datasources.dart';
import '../../model/model.dart';

class HistoricoConsumoMontoRepositoryImpl
    extends HistoricoConsumoMontoRepository {
  final HistoricoConsumoMontoDatasource datasource;

  HistoricoConsumoMontoRepositoryImpl(this.datasource);

  @override
  Future<HistoricoConsumoMonto> getHistoricoConsumoMonto(
    String nis,
    String conCuenta,
    String token,
  ) {
    return datasource.getHistoricoConsumoMonto(nis,conCuenta,token);
  }
}
