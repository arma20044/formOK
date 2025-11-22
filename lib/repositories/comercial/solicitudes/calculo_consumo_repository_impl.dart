import 'package:form/datasources/datasources.dart';
import 'package:form/model/model.dart';
import 'package:form/repo/repo.dart';

class CalculoConsumoRepositoryImpl
    extends CalculoConsumoRepository {
  final CalculoConsumoDatasource datasource;

  CalculoConsumoRepositoryImpl(this.datasource);

  @override
  Future<CalculoConsumoResponse> getCalculoConsumo(
    String nis,
    String lecturaActual
  ) {
    return datasource.getCalculoConsumo(
     nis,
     lecturaActual
    );
  }
}
