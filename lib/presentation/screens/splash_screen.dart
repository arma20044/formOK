import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/auth/auth_repository.dart';
import 'package:form/core/auth/model/auth_state.dart';
import 'package:form/core/auth/model/auth_state_data.dart';
import 'package:go_router/go_router.dart';

import '../../core/enviromens/enrivoment.dart';

class SplashScreen extends ConsumerWidget  {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {

 final authState = ref.watch(authProvider);

  ref.listen<AsyncValue<AuthStateData>>(authProvider, (previous, next) {
      if (next.value!.state == AuthState.authenticated) {
        GoRouter.of(context).go('/');
      } else if (next.value!.state == AuthState.unauthenticated) {
        GoRouter.of(context).go('/login');
      }
    });


    return  Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logoande.png', height: 50),
              SizedBox(height: 20),
              Platform.isAndroid 
              ? Text(Environment.appVersion.android.version)
              : Text(Environment.appVersion.ios.version),
              
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
