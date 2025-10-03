

import '../datasources/Login_datasource.dart';


import '../model/login_model.dart';
import '../repo/Login_repository.dart';

class LoginRepositoryImpl extends LoginRepository{


  final LoginDatasource datasource;

  LoginRepositoryImpl(this.datasource);

  @override
  Future<Login> getLogin(String numeroDocumento, String password, String tipoDocumento ) {
    return datasource.getLogin( numeroDocumento, password, tipoDocumento);
  }

} 