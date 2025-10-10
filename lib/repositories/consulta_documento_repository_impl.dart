



import 'package:form/datasources/consulta_documento_datasource.dart';
import 'package:form/model/model.dart';

import '../repo/consulta_documento_repository.dart';

class ConsultaDocumentoRepositoryImpl extends ConsultaDocumentoRepository{


  final ConsultaDocumentoDatasource datasource;

  ConsultaDocumentoRepositoryImpl(this.datasource);

  @override
  Future<ConsultaDocumentoResultado> getConsultaDocumento(String numerodocumento, String tipoDocumento) {
    return datasource.getConsultaDocumento(numerodocumento,tipoDocumento);
  }

} 