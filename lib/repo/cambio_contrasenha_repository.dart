





import 'package:form/model/Cambio_contrasenha.dart';

abstract class CambioContrasenhaRepository {

  Future<CambioContrasenhaResponse> getCambioContrasenha(String contrasenhaAnterior, String nuevaContrasenha, String confirmarNuevaContrasenha, String tipoCliente, String token);


}