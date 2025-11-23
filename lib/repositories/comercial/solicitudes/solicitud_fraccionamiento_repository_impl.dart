import 'package:form/datasources/datasources.dart';
import 'package:form/model/model.dart';
import 'package:form/repo/repo.dart';

class SolicitudFraccionamientoRepositoryImpl
    extends SolicitudFraccionamientoRepository {
  final SolicitudFraccionamientoDatasource datasource;

  SolicitudFraccionamientoRepositoryImpl(this.datasource);

  @override
  Future<SolicitudFraccionamientoResponse> getSolicitudFraccionamiento(
    String nis,
    String conCuenta,
    String cantidadCuotas,
    String entrega,
    String deuda,
    String tieneInteres,
    String tieneMultas,
    String simular,
    String token,
  ) {
    return datasource.getSolicitudFraccionamiento(
      nis,
      conCuenta,
      cantidadCuotas,
      entrega,
      deuda,
      tieneInteres,
      tieneMultas,
      simular,
      token,
    );
  }
}
