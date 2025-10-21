



import 'package:form/model/olvido_contrasenha.dart';
import 'package:form/repo/repo.dart';
import '../datasources/datasources.dart';


class OlvidoContrasenhaRepositoryImpl extends OlvidoContrasenhaRepository{


  final OlvidoContrasenhaDatasource datasource;

  OlvidoContrasenhaRepositoryImpl(this.datasource);

  @override
  Future<OlvidoContrasenhaResponse> getOlvidoContrasenha(String tipoDocumento, String documentoIdentificacion, String viaCambio, String cedulaRepresenante, String tipoSolicitante) {
    return datasource.getOlvidoContrasenha(tipoDocumento, documentoIdentificacion, viaCambio, cedulaRepresenante, tipoSolicitante);
  }

} 