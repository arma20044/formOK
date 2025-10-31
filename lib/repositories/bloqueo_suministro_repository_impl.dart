import 'package:form/repo/repo.dart';

import '../datasources/datasources.dart';

import '../model/model.dart';

class BloqueoSuministroRepositoryImpl extends BloqueoSuministroRepository {
  final BloqueoSuministroDatasource datasource;

  BloqueoSuministroRepositoryImpl(this.datasource);

  @override
  Future<BloqueoSuministroResponse> getBloqueoSuministro(
    String nis,
    num indicadorBloqueo,
    String token
  ) {
    return datasource.getBloqueoSuministro(
      nis,
      indicadorBloqueo,
      token
    );
  }
}
