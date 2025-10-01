



import 'package:form/repo/repo.dart';

import '../datasources/datasources.dart';
import '../model/model.dart';

class TipoReclamoRepositoryImpl extends TipoReclamoRepository{


  final TipoReclamoDatasource datasource;

  TipoReclamoRepositoryImpl(this.datasource);

  @override
  Future<List<TipoReclamo>> getTipoReclamo() {
    return datasource.getTipoReclamo();
  }

} 