import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:form/main.dart';

import 'package:form/presentation/auth/login_screen.dart';
import 'package:form/presentation/screens/reclamos/reclamos_falta_energia_screen.dart';
import 'package:form/presentation/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';


final goRouterProvider = Provider<GoRouter>((ref) {
  

  final goRouterRefreshNotifier = ValueNotifier(false);


  return GoRouter(
    initialLocation: '/login',
    refreshListenable: goRouterRefreshNotifier, // escucha cambios
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) {
//          final authState = ref.watch(authProvider);

  ////        if (authState.isLoading) return const SplashScreen();
     //     if (authState.value == null) return const LoginScreen();
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: '/reclamosFaltaEnergia',
        builder: (context, state) =>
            const ParentScreen(tipoReclamo: 'FE'),
      ),
    ],
    redirect: (context, state) {
     // final authState = ref.read(authProvider);

      //if (authState.isLoading) return null;
      //if (authState.value == null && state.location != '/login') return '/login';
      //if (authState.value != null && state.path == '/login') return '/';
      return null;
    },
  );
});