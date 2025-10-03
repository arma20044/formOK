import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/auth/model/auth_state_data.dart';

import 'package:form/main.dart';

import 'package:form/presentation/auth/login_screen.dart';
import 'package:form/presentation/screens/reclamos/reclamos_falta_energia_screen.dart';
import 'package:form/presentation/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';





final goRouterProvider = Provider<GoRouter>((ref) {
  // Notifier simple que usaremos para "refrescar" GoRouter
  final refreshListenable = ValueNotifier<int>(0);

  // Cuando cambie el authProvider, incrementamos el ValueNotifier
  ref.listen<AsyncValue<AuthStateData>>(authProvider, (previous, next) {
    refreshListenable.value++; // notifica a GoRouter
  });

  // Liberar el ValueNotifier cuando el provider se destruya
  ref.onDispose(() => refreshListenable.dispose());

  // Observamos el estado para construir redirect/routes
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshListenable,
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/',
        builder: (context, state) {
          if (authState.isLoading) return const SplashScreen();
          if (authState.value == null) return const LoginScreen();
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: '/reclamosFaltaEnergia',
        builder: (context, state) => const ParentScreen(tipoReclamo: 'FE'),
      ),
    ],
    redirect: (context, state) {
      if (authState.isLoading) return null;
      final isLoggedIn = authState.value != null;
      final loggingIn = state.uri.path == '/login';
      if (!isLoggedIn && !loggingIn) return '/login';
      if (isLoggedIn && loggingIn) return '/';
      return null;
    },
  );
});