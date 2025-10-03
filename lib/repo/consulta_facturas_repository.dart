

import 'package:form/model/model.dart';



abstract class ConsultaFacturasRepository {

  Future<ConsultaFacturas> getConsultaFacturas(String nis, String cantidad, String token);


}