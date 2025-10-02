import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infrastructure/infrastructure.dart';
import '../../model/login_model.dart';
import '../../repositories/login_repository_impl.dart';
import '../api/mi_ande_api.dart';

// Simulación de un "API"
Future<Login> loginApi(String numeroDocumento, String password, String tipoDocumento) async {

  final repoLogin = LoginRepositoryImpl(LoginDatasourceImpl(MiAndeApi()));


   
    final response = await repoLogin.getLogin(numeroDocumento, password, tipoDocumento);

    if (response.error == false) {
      return response;
    } else {
      throw Exception('Login failed');
    }
  

  

  
 
}

class AuthNotifier extends AsyncNotifier<Login?> {
  @override
  Future<Login?> build() async {
    // Estado inicial: no hay usuario logueado
    return null;
  }

  Future<void> login(String email, String password, String tipoDoc) async {
    state = const AsyncLoading();
    try {
      final user = await loginApi(email, password, tipoDoc);
      state = AsyncData(user);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void logout() {
    state = const AsyncData(null);
  }
}
