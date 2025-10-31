import 'package:form/core/auth/model/auth_state.dart';
import 'package:form/core/auth/model/user_model.dart';
import 'package:form/model/login_model.dart';

class AuthStateData {
  final AuthState state;
  final UserModel? user;
  final String? errorMessage;
  final List<SuministrosList?>? userDatosAnexos;
  final bool? indicadorBloqueoNIS;

  const AuthStateData({
    required this.state,
    this.user,
    this.errorMessage,
    this.userDatosAnexos,
    this.indicadorBloqueoNIS,
  });

  AuthStateData copyWith({
    AuthState? state,
    UserModel? user,
    String? errorMessage,
    List<SuministrosList?>? userDatosAnexos,
    bool? indicadorBloqueoNIS,
  }) => AuthStateData(
    state: state ?? this.state,
    user: user ?? this.user,
    errorMessage: errorMessage ?? this.errorMessage,
    userDatosAnexos: userDatosAnexos ?? this.userDatosAnexos,
    indicadorBloqueoNIS: indicadorBloqueoNIS,
  );
}


extension AuthStateDataX on AuthStateData {
  AuthStateData actualizarBloqueoWeb({
    required num nis,
    required bool valor,
  }) {
    if (userDatosAnexos == null) return this;

    final nuevaLista = userDatosAnexos!.map((suministro) {
      if (suministro?.nisRad == nis) {
        return SuministrosList(
          indicadorAcuerdoLey6524: suministro?.indicadorAcuerdoLey6524,
          indicadorLey6524: suministro?.indicadorLey6524,
          nisRad: suministro?.nisRad,
          indicadorBloqueoWeb: valor ? 1 : 0,
        );
      }
      return suministro;
    }).toList();

    return copyWith(userDatosAnexos: nuevaLista);
  }
}
