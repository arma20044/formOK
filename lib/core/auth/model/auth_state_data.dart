import 'package:form/core/auth/model/auth_state.dart';
import 'package:form/core/auth/model/user_model.dart';

class AuthStateData {
  final AuthState state;
  final UserModel? user;
  final String? errorMessage;

  const AuthStateData({
    required this.state,
    this.user,
    this.errorMessage,
  });

  AuthStateData copyWith({
    AuthState? state,
    UserModel? user,
    String? errorMessage,
  }) =>
      AuthStateData(
        state: state ?? this.state,
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
