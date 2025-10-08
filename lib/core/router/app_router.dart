import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/auth/model/auth_state.dart';
import 'package:form/core/auth/model/auth_state_data.dart';

import 'package:form/main.dart';

import 'package:form/presentation/auth/login_screen.dart';
import 'package:form/presentation/screens/reclamos/reclamos_falta_energia_screen.dart';
import 'package:form/presentation/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';



final goRouterProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ValueNotifier<int>(0);

  ref.listen<AsyncValue<AuthStateData>>(authProvider, (previous, next) {
    refreshListenable.value++;
  });

  ref.onDispose(() => refreshListenable.dispose());

  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: refreshListenable,
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    ],
    redirect: (context, state) {
      // Si está cargando, no redirige
      if (authState.isLoading) return null;

      final isLoggedIn = authState.value?.state == AuthState.authenticated;
      final loggingIn = state.uri.path == '/login';

      //if (!isLoggedIn && !loggingIn) return '/login';
      if (isLoggedIn && loggingIn) return '/';
      return null;
    },
  );
});
