import 'package:form/model/model.dart';

abstract class RegistroNumeroCelularRepository {
  Future<RegistroNumeroCelularResponse> getRegistroNumeroCelular(
    String nis,
    String numeroMovil,
    String fechaAlta,  //dd/MM/yyyy HH:mm:ss
    String solicitudOTP,
    String codigoOTP   
  );
}
