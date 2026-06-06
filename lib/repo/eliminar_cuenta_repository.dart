







import 'package:form/model/model.dart';

abstract class EliminarCuentaRepository {

  Future<EliminarCuentaResponse> getEliminarCuenta(String xToken);


}