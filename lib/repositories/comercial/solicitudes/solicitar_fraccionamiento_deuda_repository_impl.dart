import 'package:form/datasources/datasources.dart';
import 'package:form/model/model.dart';
import 'package:form/repo/repo.dart';

class SolicitarFraccionamientoDeudaRepositoryImpl
    extends SolicitarFraccionamientoDeudaRepository {
  final SolicitarFraccionamientoDeudaDatasource datasource;

  SolicitarFraccionamientoDeudaRepositoryImpl(this.datasource);

  @override
  Future<SolicitarFraccionamientoResponse> getSolicitarFraccionamientoDeuda(
    String nis,
    String solicitudOTP,
    String responseSimulacion,
    String token,
    String verificarAdjunto,
  ) {
    return datasource.getSolicitarFraccionamientoDeuda(
      nis,
      solicitudOTP,
      responseSimulacion,
      token,
      verificarAdjunto,
    );
  }
}
