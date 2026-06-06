
import 'package:form/repo/repo.dart';
import '../datasources/datasources.dart';
import '../model/model.dart';


class EliminarCuentaRepositoryImpl extends EliminarCuentaRepository{


  final EliminarCuentaDatasource datasource;

  EliminarCuentaRepositoryImpl(this.datasource);

  @override
  Future<EliminarCuentaResponse> getEliminarCuenta(String xToken) {
    return datasource.getEliminarCuenta(xToken);
  }

} 