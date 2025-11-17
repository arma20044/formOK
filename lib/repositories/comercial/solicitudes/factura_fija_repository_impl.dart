import 'package:form/datasources/datasources.dart';
import 'package:form/model/model.dart';
import 'package:form/repo/repo.dart';

class FacturaFijaRepositoryImpl
    extends FacturaFijaRepository {
  final FacturaFijaDatasource datasource;

  FacturaFijaRepositoryImpl(this.datasource);

  @override
  Future<FacturaFijaResponse> getFacturaFija(
    String nis,
  ) {
    return datasource.getFacturaFija(
     nis,
    );
  }
}
