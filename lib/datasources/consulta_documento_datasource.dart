

import '../model/model.dart';

abstract class ConsultaDocumentoDatasource {

  Future<ConsultaDocumentoResultado> getConsultaDocumento(String numerodocumento, String tipoDocumento);


}