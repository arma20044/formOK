import '../model/model.dart';

abstract class ConsultaFacturasDatasource {

  Future<ConsultaFacturas> getConsultaFacturas(String nis, String cantidad, String token);


}