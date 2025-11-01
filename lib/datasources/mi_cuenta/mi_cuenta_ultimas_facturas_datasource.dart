




import 'package:form/model/model.dart';



abstract class MiCuentaUltimasFacturasDatasource {

  Future<MiCuentaUltimasFacturasResponse> getMiCuentaUltimasFacturas(String nis, String cantidad,String token);


}