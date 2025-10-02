

import '../model/login_model.dart';

abstract class LoginDatasource {
  Future<Login> getLogin(
    String username,
    String password,
    String tipoDocumento,
  );
}
