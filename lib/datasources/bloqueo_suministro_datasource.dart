import '../model/model.dart';

abstract class BloqueoSuministroDatasource {
  Future<BloqueoSuministroResponse> getBloqueoSuministro(
    String nis,
    num indicadorBloqueo,
    String token
  );
}
