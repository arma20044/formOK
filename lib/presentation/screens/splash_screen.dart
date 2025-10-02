import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/enviromens/enrivoment.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
