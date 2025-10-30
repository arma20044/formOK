import 'package:form/model/model.dart';

abstract class BloqueoSuministroRepository {
  Future<BloqueoSuministroResponse> getBloqueoSuministro(
    String nis,
    num indicadorBloqueo,
  );
}
