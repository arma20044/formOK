import 'package:form/repo/repo.dart';

import '../datasources/datasources.dart';

import '../model/model.dart';

class BloqueoSuministroRepositoryImpl extends BloqueoSuministroRepository {
  final BloqueoSuministroDatasource datasource;

  BloqueoSuministroRepositoryImpl(this.datasource);

  @override
  Future<BloqueoSuministroResponse> getBloqueoSuministro(
    String nis,
    num indicadorBloqueo
  ) {
    return datasource.getBloqueoSuministro(
      nis,
      indicadorBloqueo
    );
  }
}
