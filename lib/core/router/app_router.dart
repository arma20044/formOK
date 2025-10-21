import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/presentation/screens/expedientes/expedientes_screen.dart';
import 'package:form/presentation/screens/mi_cuenta/mis_datos.dart';
import 'package:form/presentation/screens/mi_cuenta/registro/registro_mi_cuenta_screen.dart';
import 'package:form/presentation/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/auth/model/auth_state.dart';
import 'package:form/core/auth/model/auth_state_data.dart';

import 'package:form/main.dart';
import 'package:form/presentation/auth/login_screen.dart';
import 'package:form/presentation/screens/mi_cuenta/mi_cuenta_screen.dart';
import 'package:form/presentation/screens/reclamos/reclamos_falta_energia_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  // Notificador para forzar rebuild cuando cambie authProvider
  final refreshListenable = ValueNotifier<int>(0);

  ref.listen<AsyncValue<AuthStateData>>(authProvider, (previous, next) {
    refreshListenable.value++;
  });

  ref.onDispose(refreshListenable.dispose);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refreshListenable,
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/misDatos', builder: (context, state) => const MisDatos()),
      GoRoute(path: '/expediente', builder: (context, state) => const ExpedienteScreen()),
      GoRoute(path: '/registroMiCuenta', builder: (context, state) => const RegistroMiCuentaScreen()),
      GoRoute(path: '/miCuenta', builder: (context, state) => const MiCuentaScreen()),
      GoRoute(path: '/reclamosFaltaEnergia', builder: (context, state) => const ReclamosScreen(tipoReclamo: 'FE')),
      GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    ],
    redirect: (context, state) {
      final authState = ref.read(authProvider);

      // 🔹 Mientras cargamos, no redirigir
      if (authState.isLoading) return null;

      final isLoggedIn = authState.value?.state == AuthState.authenticated;
      final loggingIn = state.uri.path == '/login';

      // 🔹 Usuario no logueado y no está en login → ir a login
      if (!isLoggedIn && !loggingIn) return '/login';

      // 🔹 Usuario logueado e intenta ir a login → redirigir a home
      if (isLoggedIn && loggingIn) return '/';

      // 🔹 No cambiar ruta
      return null;
    },
  );
});
