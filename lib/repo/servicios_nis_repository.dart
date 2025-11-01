







import '../model/model.dart';

abstract class ServiciosNisRepository {

  Future<ServiciosNisTelefonoResponse> getServiciosNis(String nis, String token);


}