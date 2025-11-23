import 'package:form/model/model.dart';

abstract class SolicitudFraccionamientoRepository {
  Future<SolicitudFraccionamientoResponse> getSolicitudFraccionamiento(
   String nis,
    String conCuenta,
    String cantidadCuotas,
    String entrega,
    String deuda,
    String tieneInteres,
    String tieneMultas,
    String simular,
    String token
  );
}
