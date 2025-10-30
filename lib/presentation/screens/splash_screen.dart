import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/enviromens/Enrivoment.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 🔹 Solo mostramos UI, la redirección la maneja GoRouter
    // 🔹 Si quieres, puedes disparar el login automático aquí
    ref.read(authProvider.notifier).build();

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logoande.png', height: 50),
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
              const SizedBox(height: 8),
              Platform.isAndroid
                  ? Text(Environment.appVersion.android.version)
                  : Text(Environment.appVersion.ios.version),
            ],
          ),
        ),
      ),
    );
  }
}
