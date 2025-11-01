





import '../model/model.dart';

abstract class ServiciosNisDatasource {

  Future<ServiciosNisTelefonoResponse> getServiciosNis(String nis,String token);


}