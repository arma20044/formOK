import 'package:form/model/model.dart';

abstract class HistoricoConsumoMontoRepository {
  Future<HistoricoConsumoMonto> getHistoricoConsumoMonto(
    String nis,
    String conCuenta,
    String token,
  );
}
