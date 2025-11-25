import 'package:form/model/model.dart';

abstract class SolicitarFraccionamientoDeudaDatasource {
  Future<SolicitarFraccionamientoResponse> getSolicitarFraccionamientoDeuda(
    String nis, 
    String solicitudOTP,
    String responseSimulacion,
    String token,
    String verificarAdjunto,
  );
}
