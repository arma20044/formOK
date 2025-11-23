import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/auth/model/auth_state.dart';
import 'package:form/core/auth/model/auth_state_data.dart';
import 'package:form/main.dart';
import 'package:form/presentation/screens/comercial/solicitudes/forms/registro_numero_celular_screen.dart';
import 'package:form/presentation/screens/comercial/solicitudes/forms/solicitudAbastecimientoScreen.dart';
import 'package:form/presentation/screens/comercial/solicitudes/forms/solicitud_factura_fija_screen.dart';
import 'package:form/presentation/screens/comercial/solicitudes/forms/solicitud_fraccionamiento_deuda_screen.dart';
import 'package:form/presentation/screens/comercial/solicitudes/forms/solicitud_yo_facturo_mi_luz_screen.dart';
import 'package:form/presentation/screens/comercial/solicitudes/solicitudes_screen.dart';
import 'package:form/presentation/screens/favoritos/favoritos_screen.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/screens.dart';

final publicRoutes = [
  '/login',
  '/register',
  '/splash',
  '/',
  '/solicitudes',
  '/solicitudAbastecimiento',
  '/reclamosFaltaEnergia',
  '/solicitudesPublico',
  '/solicitudFacturaFija',
  '/favoritos',
];
final privateRoutes = [
  '/miCuenta',
  '/misDatos',
  '/settings',
  '/consultaFacturas',
  '/cambioContrasenha',
  '/suministros',
  '/solicitudYoFacturoMiLuz'
];

final goRouterProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ValueNotifier<int>(0);

  // 🔹 Forzar rebuild cuando cambia authProvider
  ref.listen<AsyncValue<AuthStateData>>(authProvider, (prev, next) {
    refreshListenable.value++;
  });
  ref.onDispose(refreshListenable.dispose);

  final router = GoRouter(
    debugLogDiagnostics: true,
    observers: [MyNavigatorObserver()],
    initialLocation: '/splash',
    refreshListenable: refreshListenable,
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) {
          // Recupera la ruta destino si existe
          final from = state.uri.queryParameters['from'] ?? '/';
          return LoginScreen(from: from);
        },
      ),
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
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
        routes: [
          GoRoute(
            path: ':telefono',
            builder: (context, state) {
              final nis = state.pathParameters['telefono'];
              return ReclamosScreen(telefono: nis, tipoReclamo: 'FE',);
            },
          ),
        ]
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/consultaFacturas',
        builder: (context, state) => const ConsultaFacturasScreen(),
        routes: [
          GoRoute(
            path: ':nis',
            builder: (context, state) {
              final nis = state.pathParameters['nis'];
              return ConsultaFacturasScreen(nis: nis);
            },
          ),
        ],
      ),

      GoRoute(
        path: '/olvidoContrasenha',
        builder: (context, state) => const OlvidoContrasenhaScreen(),
      ),
      GoRoute(
        path: '/cambioContrasenha',
        builder: (context, state) => const CambioContrasenhaScreen(),
      ),
      GoRoute(
        path: '/suministros',
        builder: (context, state) => const SuministrosScreen(),
      ),
      GoRoute(
        path: '/solicitudesPublico',
        builder: (context, state) => const SolicitudesScreen(true),
      ),
      GoRoute(
        path: '/solicitudes',
        builder: (context, state) => const SolicitudesScreen(false),
      ),
      GoRoute(
        path: '/solicitudAbastecimiento',
        builder: (context, state) => const SolicitudAbastecimientoScreen(),
      ),
      GoRoute(
        path: '/registroNumeroCelular',
        builder: (context, state) => const RegistroNumeroCelularScreen(),
      ),
      GoRoute(
        path: '/solicitudFacturaFija',
        builder: (context, state) => const SolicitudFacturaFijaScreen(),
      ),
      GoRoute(
        path: '/favoritos',
        builder: (context, state) => const FavoritosScreen(),
      ),
      GoRoute(
        path: '/solicitudYoFacturoMiLuz',
        builder: (context, state) => const SolicitudYoFacturoMiLuz(),
      ),
      GoRoute(
        path: '/solicitudFraccionamientoDeuda',
        builder: (context, state) => const SolicitudFraccionamientoDeudaScreen(),
      ),
    ],

    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isLoggedIn = authState.value?.state == AuthState.authenticated;
      final loggingIn = state.uri.path == '/login';
      //final currentPath = state.matchedLocation;

      final currentPath = state.uri.path;

      // Si no está logueado e intenta ir a una privada:
      if (!isLoggedIn && !publicRoutes.contains(currentPath)) {
        // Redirige a login con query param 'from'
        return '/login?from=${Uri.encodeComponent(currentPath)}';
      }

      // Si está logueado e intenta ir a login, lo mandamos al home
      if (isLoggedIn && currentPath == '/login') {
        return '/';
      }

      // Forzar cambio de contraseña
      final forzarCambioContrasenha = authState.value?.user?.modificarPassword;
      if (forzarCambioContrasenha != null &&
          forzarCambioContrasenha.contains('S')) {
        return '/cambioContrasenha';
      }

      if (isLoggedIn && loggingIn) {
        final from = state.uri.queryParameters['from'];
        if (from != null && from.isNotEmpty) {
          return from;
        }
        return '/'; // si no hay 'from', ir al home
      }

      // 🔹 Usuario no logueado intenta acceder a ruta privada
      if (!isLoggedIn && privateRoutes.contains(currentPath)) {
        // Redirige a login y pasa la ruta destino en el query parameter 'from'
        return '/login?from=$currentPath';
      }

      // 🔹 Usuario logueado entra a login → ir al historial o home
      if (isLoggedIn && loggingIn) {
        final from = state.uri.queryParameters['from'];
        return from != null ? from : '/';
      }

      // 🔹 Usuario logueado y splash → home
      if (isLoggedIn && state.uri.path == '/splash') return '/';

      // Splash solo redirige a home si el usuario ya está logueado
      //if (state.uri.path == '/splash') return '/';

      return null; // no redirigir
    },
  );

  // 🔹 Listener para capturar la última ruta válida antes del login
  router.routerDelegate.addListener(() {
    final configuration = router.routerDelegate.currentConfiguration;
    if (configuration.isNotEmpty) {
      final currentUri = Uri.parse(configuration.last.matchedLocation);

      // No guardar login ni splash como previous
      if (currentUri.path != '/login' && currentUri.path != '/splash') {
        // routeHistory.update(currentUri);
        debugPrint('➡️ Ruta actual guardada: ${currentUri.path}');
      }
    }
  });

  return router;
});

class MyNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log(previousRoute.toString());
    log(route.toString());
    log('did push route');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log('did pop route');
  }
}
