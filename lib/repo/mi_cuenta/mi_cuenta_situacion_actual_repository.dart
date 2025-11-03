import 'package:form/model/model.dart';

abstract class MiCuentaSituacionActualRepository {
  Future<MiCuentaSituacionActualResponse> getMiCuentaSituacionActual(
    String nis,    
    String token
  );
}
