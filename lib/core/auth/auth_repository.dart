import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/model/login_model.dart';

import '../../infrastructure/login_datasource_impl.dart';
import '../../repositories/login_repository_impl.dart';
import '../api/mi_ande_api.dart';

class AuthRepository {
  Future<bool> login(String numeroDocumento, String password, String tipoDocumento) async {
    
    try{
    //llamada API
    final repoLogin = LoginRepositoryImpl(LoginDatasourceImpl(MiAndeApi()));

    final responseLogin = repoLogin.getLogin(numeroDocumento, password, tipoDocumento);

    return true;
    }
    catch(e){
      throw Exception(e);      
    }
    
    
  }

  Future<void> logout() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    // Clear any stored authentication tokens
  }
}

final authRepositoryProvider = Provider((ref) => AuthRepository());