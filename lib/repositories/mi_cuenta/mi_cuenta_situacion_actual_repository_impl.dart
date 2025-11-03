import 'package:form/model/model.dart';
import 'package:form/repo/repo.dart';

import '../../datasources/datasources.dart';


class MiCuentaSituacionActualRepositoryImpl extends MiCuentaSituacionActualRepository {
  final MiCuentaSituacionActualDatasource datasource;

  MiCuentaSituacionActualRepositoryImpl(this.datasource);

  @override
  Future<MiCuentaSituacionActualResponse> getMiCuentaSituacionActual(
    String nis,    
    String token
  ) {
    return datasource.getMiCuentaSituacionActual(
      nis,      
      token
    );
  }
}
