import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/auth/model/auth_state.dart';
import 'package:form/presentation/components/common/lista_botones.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:go_router/go_router.dart';

class MiCuentaScreen extends ConsumerWidget {
  const MiCuentaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState.value?.state == AuthState.unauthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/login'); // o context.push('/login');
      });
    }

    final botones = [
      BotonNavegacion(
        icon: Icons.electric_meter,
        texto: 'Suministros',
        ruta: '/suministros',
      ),
      BotonNavegacion(
        icon: Icons.article,
        texto: 'Solicitudes',
        ruta: '/solicitudes',
      ),
      BotonNavegacion(
        icon: Icons.folder,
        texto: 'Expedientes',
        ruta: '/expediente',
      ),
      BotonNavegacion(
        icon: Icons.person,
        texto: 'Mis Datos',
        ruta: '/misDatos',
      ),
      BotonNavegacion(
        icon: Icons.delete,
        texto: 'Eliminar Cuenta',
        ruta: '/configuracion',
      ),
      BotonNavegacion(
        icon: Icons.logout,
        texto: 'Cerrar sesión',
        ruta: '/logout',
      ),
    ];

    return Scaffold(
      endDrawer: CustomDrawer(),
      appBar: AppBar(title: Text("Mi Cuenta")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListaBotones(botones: botones),
      ),
    );
  }
}
