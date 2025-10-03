


import 'package:form/datasources/consulta_facturas_datasource.dart';
import 'package:form/model/model.dart';
import 'package:form/repo/repo.dart';






class ConsultaFacturasRepositoryImpl extends ConsultaFacturasRepository{


  final ConsultaFacturasDatasource datasource;

  ConsultaFacturasRepositoryImpl(this.datasource);

  @override
  Future<ConsultaFacturas> getConsultaFacturas(String nis, String cantidad, String token ) {
    return datasource.getConsultaFacturas(nis, cantidad, token);
  }

} 