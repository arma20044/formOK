import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/auth/model/auth_state.dart';
import 'package:form/core/auth/model/auth_state_data.dart';

import 'package:form/main.dart';
import 'package:form/presentation/auth/login_screen.dart';
import 'package:form/presentation/screens/mi_cuenta/mi_cuenta_screen.dart';
import 'package:form/presentation/screens/reclamos/reclamos_falta_energia_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  // Notificador que fuerza a GoRouter a reconstruirse
  final refreshListenable = ValueNotifier<int>(0);

  // Cada vez que cambia el authProvider, incrementa el notifier
  ref.listen<AsyncValue<AuthStateData>>(authProvider, (previous, next) {
    refreshListenable.value++;
  });

  // Limpieza al destruir el provider
  ref.onDispose(refreshListenable.dispose);

  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshListenable,
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/miCuenta',
        builder: (context, state) => const MiCuentaScreen(),
      ),
      GoRoute(
        path: '/reclamosFaltaEnergia',
        builder: (context, state) => const ParentScreen(tipoReclamo: 'FE'),
      ),
    ],
    redirect: (context, state) {
      // Mientras carga el estado (por ejemplo, verificando token)
      if (authState.isLoading) {
        // 👇 Si ya está en login, no se mueve
        if (state.uri.path == '/login') return null;
        // 👇 Si está en otra pantalla, lo mandamos al login temporalmente
        return '/login';
      }

      final isLoggedIn = authState.value?.state == AuthState.authenticated;
      final loggingIn = state.uri.path == '/login';

      // 🔹 No logueado → se queda o va al login
      //if (!isLoggedIn && !loggingIn) return '/login';

      // 🔹 Logueado e intenta entrar al login → redirigir a home
      if (isLoggedIn && loggingIn) return '/';

      return null;
    },
  );
});
