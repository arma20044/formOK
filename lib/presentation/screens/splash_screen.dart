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
    ref.listen(splashInitProvider, (previous, next) {
    next.when(
      data: (_) {
        context.go('/'); // Navegar si todo salió bien
      },
      error: (error, stack) {
        // Aquí manejas el error: 
        // 1. Mostrar un diálogo de error
        // 2. O redirigir a una pantalla de login/error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo conectar con el servidor. Revisa tu conexión.'),
            backgroundColor: Colors.red,
          ),
        );
        
        // Opcional: Redirigir al Login si falló la carga inicial
        // context.go('/login'); 
      },
      loading: () {}, // No haces nada mientras carga
    );
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
                      ? Text('Ver. ${environment.appVersion.android.version}')
                      : Text('Ver. ${environment.appVersion.ios.version}'),
             
            
          ],
        ),
      ),
    );
  }
}
