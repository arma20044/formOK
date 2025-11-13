import 'package:form/datasources/datasources.dart';
import 'package:form/model/model.dart';
import 'package:form/repo/repo.dart';

class RegistroNumeroCelularRepositoryImpl
    extends RegistroNumeroCelularRepository {
  final RegistroNumeroCelularDatasource datasource;

  RegistroNumeroCelularRepositoryImpl(this.datasource);

  @override
  Future<RegistroNumeroCelularResponse> getRegistroNumeroCelular(
    String nis,
    String numeroMovil,
    String fechaAlta, //dd/MM/yyyy HH:mm:ss
    String solicitudOTP,
    String codigoOTP,
  ) {
    return datasource.getRegistroNumeroCelular(
     nis,
     numeroMovil,
     fechaAlta,
     solicitudOTP,
     codigoOTP
    );
  }
}
