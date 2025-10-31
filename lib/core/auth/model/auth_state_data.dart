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
