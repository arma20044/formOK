import 'package:form/model/model.dart';

abstract class SolicitarFraccionamientoDeudaRepository {
  Future<SolicitarFraccionamientoResponse> getSolicitarFraccionamientoDeuda(
    String nis,
    String solicitudOTP,
    String responseSimulacion,
    String token,
    String verificarAdjunto,
  );
}
