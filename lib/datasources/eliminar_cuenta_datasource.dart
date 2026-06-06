




import 'package:form/model/model.dart';

abstract class EliminarCuentaDatasource {

  Future<EliminarCuentaResponse> getEliminarCuenta(String xToken);


}