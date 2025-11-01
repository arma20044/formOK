import 'package:form/model/model.dart';
import 'package:form/repo/repo.dart';

import '../../datasources/datasources.dart';


class MiCuentaUltimasFacturasRepositoryImpl extends MiCuentaUltimasFacturasRepository {
  final MiCuentaUltimasFacturasDatasource datasource;

  MiCuentaUltimasFacturasRepositoryImpl(this.datasource);

  @override
  Future<MiCuentaUltimasFacturasResponse> getMiCuentaUltimasFacturas(
    String nis,
    String cantidad,
    String token
  ) {
    return datasource.getMiCuentaUltimasFacturas(
      nis,
      cantidad,
      token
    );
  }
}
