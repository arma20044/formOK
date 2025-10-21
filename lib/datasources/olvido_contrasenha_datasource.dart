



import 'package:form/model/olvido_contrasenha.dart';



abstract class OlvidoContrasenhaDatasource {

  Future<OlvidoContrasenhaResponse> getOlvidoContrasenha(String tipoDocumento, String documentoIdentificacion, String viaCambio, String cedulaRepresenante, String tipoSolicitante);


}