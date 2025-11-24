import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/router/app_router.dart';

class AuthInterceptor extends Interceptor {
  final Ref ref;

  AuthInterceptor(this.ref);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Expirar sesión
      ref.read(authProvider.notifier).logoutForzado();

      // Obtener ubicación real
      final router = ref.read(goRouterProvider);
      final currentLocation = router.routeInformationProvider.value.uri
          .toString();

      // Evitar bucle si ya estás en login
      if (!currentLocation.startsWith('/login')) {
        router.go('/login');
      }
    }

    super.onError(err, handler);
  }
}
