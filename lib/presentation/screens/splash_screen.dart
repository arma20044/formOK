import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/enviromens/enrivoment.dart';
import 'package:form/provider/splash_init_provider.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animación del logo
   _controller = AnimationController(
      duration: const Duration(milliseconds: 3000), // Duración de la animación
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.5,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut, // Curva suave sin rebote
      ),
    );

     // 3. INICIAR LA ANIMACIÓN
    _controller.forward(); 
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Escucha el provider de inicialización
    ref.listen(splashInitProvider, (prev, next) {
      next.whenData((_) {
        context.go('/'); // Ruta final luego del splash
      });
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Image.asset(
                'assets/images/logoande.png',
                height: 80, // un poco más grande para apreciar el efecto
              ),
            ),
            const SizedBox(height: 20),
         
                  const SizedBox(height: 20),
              
                  Platform.isAndroid
                      ? Text('Ver. ${Environment.appVersion.android.version}')
                      : Text('Ver. ${Environment.appVersion.ios.version}'),
             
            
          ],
        ),
      ),
    );
  }
}
