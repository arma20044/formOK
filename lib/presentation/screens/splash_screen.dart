import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/auth/model/auth_state.dart';
import 'package:form/core/auth/model/auth_state_data.dart';
import 'package:form/core/enviromens/Enrivoment.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Escucha cambios en AuthStateData de forma segura
    ref.listen<AsyncValue<AuthStateData>>(authProvider, (previous, next) {
      next.whenData((authData) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final router = GoRouter.maybeOf(context);
          if (router == null) return; // evita crash si no hay GoRouter

          if (authData.state == AuthState.authenticated) {
            GoRouter.of(context).go('/');
          } else if (authData.state == AuthState.unauthenticated) {
            GoRouter.of(context).go('/login');
          }
        });
      });
    });

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logoande.png', height: 50),
              const SizedBox(height: 20),
              Platform.isAndroid
                  ? Text(Environment.appVersion.android.version)
                  : Text(Environment.appVersion.ios.version),
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
