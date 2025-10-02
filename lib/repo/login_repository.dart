import '../model/login_model.dart';

abstract class LoginRepository {
  Future<Login> getLogin(
    String username,
    String password,
    String tipoDocumento,
  );
}
