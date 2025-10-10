



import '../model/model.dart';

abstract class ConsultaDocumentoRepository {

  Future<ConsultaDocumentoResultado> getConsultaDocumento(String numerodocumento, String tipoDocumento);


}