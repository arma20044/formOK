




import 'package:form/model/model.dart';



abstract class MiCuentaSituacionActualDatasource {

  Future<MiCuentaSituacionActualResponse> getMiCuentaSituacionActual(String nis,String token);


}