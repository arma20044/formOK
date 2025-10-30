import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/presentation/screens/comercial/mis_suministros/suministros_screen.dart';
import 'package:form/presentation/screens/expedientes/expedientes_screen.dart';
import 'package:form/presentation/screens/mi_cuenta/cambio_contrasenha/cambio_constrasenha_screen.dart';
import 'package:form/presentation/screens/mi_cuenta/mis_datos_screen.dart';
import 'package:form/presentation/screens/mi_cuenta/olvido_contrasenha/olvido_contrasenha_screen.dart';
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

import '../../presentation/screens/comercial/consulta_facturas_screen.dart' show ConsultaFacturasScreen;

final publicRoutes = ['/login', '/register', '/splash','/'];
final privateRoutes = ['/miCuenta', '/misDatos','/settings','/consultaFacturas','cambioContrasenha'];

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
      GoRoute(path: '/consultaFacturas', builder: (context, state) => const ConsultaFacturasScreen()),
      GoRoute(path: '/olvidoContrasenha', builder: (context, state) => const OlvidoContrasenhaScreen()),
      GoRoute(path: '/cambioContrasenha', builder: (context, state) => const CambioContrasenhaScreen()),
      GoRoute(path: '/suministros', builder: (context, state) => const SuministrosScreen()),
    ],
    redirect: (context, state) {
      final authState = ref.read(authProvider);

      // 🔹 Mientras cargamos, no redirigir
      if (authState.isLoading) return null;

      final isLoggedIn = authState.value?.state == AuthState.authenticated;
      final loggingIn = state.uri.path == '/login';
      final currentPath = state.matchedLocation;
      final forzarCambioContrasenha = authState.value?.user?.modificarPassword;

      if(forzarCambioContrasenha != null && forzarCambioContrasenha.contains('S')) return '/cambioContrasenha';

      // 🔹 Usuario no logueado y no está en login → ir a login
      if (!isLoggedIn && !loggingIn && privateRoutes.contains(currentPath)) return '/login';
      
      if (!isLoggedIn && !loggingIn && publicRoutes.contains(currentPath)) return '/';

      // 🔹 Usuario logueado e intenta ir a login → redirigir a home
      if (isLoggedIn && loggingIn) return '/';

      if(isLoggedIn && state.uri.path == '/splash') return '/';

      // 🔹 No cambiar ruta
      return null;
    },
  );
});
