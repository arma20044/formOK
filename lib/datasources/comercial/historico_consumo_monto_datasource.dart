import '../../model/model.dart';

abstract class HistoricoConsumoMontoDatasource {
  Future<HistoricoConsumoMonto> getHistoricoConsumoMonto(
    String nis,
    String conCuenta,
    String token,
  );
}
