import 'package:form/model/model.dart';

abstract class MiCuentaUltimasFacturasRepository {
  Future<MiCuentaUltimasFacturasResponse> getMiCuentaUltimasFacturas(
    String nis,
    String cantidad,
    String token
  );
}
