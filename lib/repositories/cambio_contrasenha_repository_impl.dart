



import 'package:form/model/Cambio_contrasenha.dart';
import 'package:form/repo/repo.dart';
import '../datasources/datasources.dart';


class CambioContrasenhaRepositoryImpl extends CambioContrasenhaRepository{


  final CambioContrasenhaDatasource datasource;

  CambioContrasenhaRepositoryImpl(this.datasource);

  @override
  Future<CambioContrasenhaResponse> getCambioContrasenha(String contrasenhaAnterior, String nuevaContrasenha, String confirmarNuevaContrasenha, String tipoCliente,String token) {
    return datasource.getCambioContrasenha(contrasenhaAnterior, nuevaContrasenha, confirmarNuevaContrasenha, tipoCliente,token);
  }

} 