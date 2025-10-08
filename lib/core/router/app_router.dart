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

  // Notificar GoRouter cuando cambie authProvider
  ref.listen<AsyncValue<AuthStateData>>(authProvider, (previous, next) {
    refreshListenable.value++;
  });

  ref.onDispose(() => refreshListenable.dispose());

  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshListenable,
    routes: [
      // Ruta login
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

      // Home pública
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),

      // Ruta privada opcional
      GoRoute(
        path: '/reclamosFaltaEnergia',
        builder: (context, state) {
          final isLoggedIn = authState.value != null;
          if (isLoggedIn) {
            return const ParentScreen(tipoReclamo: 'FE'); // versión completa
          } else {
            //return const GuestScreen(); // versión limitada si no está logueado
            return Text("data");
          }
        },
      ),
    ],

    // Redireccionamiento general
    redirect: (context, state) {
      if (authState.isLoading) return null;

      final isLoggedIn = authState.value != null;
      final loggingIn = state.uri.path == '/login';

      // ⚡ Aquí quitamos el "forzar login" para rutas públicas
      // Solo redirigir si el usuario intenta acceder a rutas privadas (ej: /admin)
      // En este ejemplo, permitimos que '/reclamosFaltaEnergia' sea opcional

      if (isLoggedIn && loggingIn) return '/'; // si ya logueado, ir al home
      return null; // null = no hay redirección
    },
  );
});
