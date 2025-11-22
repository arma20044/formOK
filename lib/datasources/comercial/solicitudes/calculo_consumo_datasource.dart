import 'package:form/model/model.dart';

abstract class CalculoConsumoDatasource {
  Future<CalculoConsumoResponse> getCalculoConsumo(
    String nis, 
    String lecturaActual
  );
}
