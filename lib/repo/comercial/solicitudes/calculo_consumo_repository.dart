import 'package:form/model/model.dart';

abstract class CalculoConsumoRepository {
  Future<CalculoConsumoResponse> getCalculoConsumo(
    String nis,
    String lecturaActual
  );
}
