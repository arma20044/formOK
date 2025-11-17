import 'package:form/model/model.dart';

abstract class FacturaFijaRepository {
  Future<FacturaFijaResponse> getFacturaFija(
    String nis,
  );
}
