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
      GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),

      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/misDatos', builder: (context, state) => const MisDatos()),
      GoRoute(
        path: '/expediente',
        builder: (context, state) => const ExpedienteScreen(),
      ),
      GoRoute(
        path: '/registroMiCuenta',
        builder: (context, state) => const RegistroMiCuentaScreen(),
      ),
      GoRoute(
        path: '/miCuenta',
        builder: (context, state) => const MiCuentaScreen(),
      ),
      GoRoute(
        path: '/reclamosFaltaEnergia',
        builder: (context, state) => const ReclamosScreen(tipoReclamo: 'FE'),
      ),
    ],
    redirect: (context, state) {
      // Mientras carga el estado (por ejemplo, verificando token)
      if (authState.isLoading) {
        // 👇 Si ya está en login, no se mueve
        if (state.uri.path == '/login') return null;
        // 👇 Si está en otra pantalla, lo mandamos al login temporalmente
        //return '/login';
      }

      final isLoggedIn = authState.value?.state == AuthState.authenticated;
      final loggingIn = state.uri.path == '/login';

      // 🔹 No logueado → se queda o va al login
      //if (!isLoggedIn && !loggingIn) return '/login';

      // 🔹 Logueado e intenta entrar al login → redirigir a home
      if (isLoggedIn && loggingIn) return '/';

      final location = state.uri.path;
      final current = state.fullPath; // ruta actual

      if (current == location) return null;

      return null;
    },
  );
});
