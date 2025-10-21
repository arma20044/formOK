import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/auth/model/auth_state.dart';
import 'package:form/core/auth/model/auth_state_data.dart';
import 'package:form/core/enviromens/Enrivoment.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Llamar login silencioso en segundo plano
    _attemptSilentLogin();
  }

  Future<void> _attemptSilentLogin() async {
    final authNotifier = ref.read(authProvider.notifier);

    // Este login es silencioso si hay credenciales guardadas
    await authNotifier.build();

    // ref.listen se encargará de redirigir
  }

  @override
  Widget build(BuildContext context) {
    // Escuchamos cambios del authProvider
    ref.listen<AsyncValue<AuthStateData>>(authProvider, (previous, next) {
      next.whenOrNull(
        data: (authData) {
          if (!mounted) return;

          if (authData.state == AuthState.authenticated) {
            GoRouter.of(context).go('/'); // Login correcto → Home
          } else if (authData.state == AuthState.unauthenticated ||
              authData.state == AuthState.error) {
            GoRouter.of(context).go('/login'); // Login fallido → LoginScreen
          }
        },
      );
    });

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Image(image: AssetImage('assets/images/logoande.png'), height: 50),
              SizedBox(height: 20),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
