



import 'package:form/datasources/reclamo_recuperado_datasource.dart';
import 'package:form/model/model.dart';
import 'package:form/repo/repo.dart';

class ReclamoRecuperadoRepositoryImpl extends ReclamoRecuperadoRepository{


  final ReclamoRecuperadoDatasource datasource;

  ReclamoRecuperadoRepositoryImpl(this.datasource);

  @override
  Future<ReclamoRecuperadoResponse> getReclamoRecuperado(String telefono) {
    return datasource.getReclamoRecuperado(telefono);
  }

} 