import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/auth/auth_repository.dart';

import '../../infrastructure/infrastructure.dart';

import '../../model/login_model.dart';
import '../../repositories/login_repository_impl.dart';
import '../api/mi_ande_api.dart';
import 'model/auth_state.dart';

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    // Check initial authentication status (e.g., from stored tokens)
    return AuthState.unauthenticated;
  }

  Future<void> login(String numeroDocumento, String password, String tipoDocumento) async {
    state = const AsyncValue.data(AuthState.loading);
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final success = await authRepository.login(numeroDocumento, password, tipoDocumento);
      if (success) {
        state = const AsyncValue.data(AuthState.authenticated);
      } else {
        state = const AsyncValue.data(AuthState.error); // Or a more specific error state
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.data(AuthState.loading);
    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.logout();
      state = const AsyncValue.data(AuthState.unauthenticated);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);