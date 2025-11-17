import 'package:form/model/model.dart';

abstract class FacturaFijaDatasource {
  Future<FacturaFijaResponse> getFacturaFija(
    String nis, 
  );
}
