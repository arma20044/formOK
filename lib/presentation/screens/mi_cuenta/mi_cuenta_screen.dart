import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/config/constantes.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/auth/model/auth_state.dart';
import 'package:form/presentation/components/common/custom_snackbar.dart';
import 'package:form/presentation/components/common/lista_botones.dart';
import 'package:form/presentation/components/common/logout_dialog.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:go_router/go_router.dart';

class MiCuentaScreen extends ConsumerWidget {
  const MiCuentaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    final authNotifier = ref.read(authProvider.notifier);

    if (authState.value?.state == AuthState.unauthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/login'); // o context.push('/login');
      });
    }

    final botones = [
      if (authState.value?.user?.tipoCliente == '1')
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
      /*BotonNavegacion(
        icon: Icons.logout,
        texto: 'Cerrar sesión',
        ruta: '/logout',
      ),*/
    ];

    return Scaffold(
      endDrawer: CustomDrawer(),
      appBar: AppBar(title: Text("Mi Cuenta")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListaBotones(botones: botones),
            SizedBox(
              height: 55,
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(Icons.logout, size: 24, color: Colors.redAccent),
                label: Text(
                  'Cerrar sesión',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent,
                  ),
                ),
                onPressed: () {
                  //Navigator.pushNamed(context, boton.ruta);
                  // context.push(boton.ruta);
                  showDialog(
                    context: context,
                    builder: (context) => LogoutDialog(
                      onConfirm: () async {
                        if (context.mounted) {
                          CustomSnackbar.show(
                            context,
                            message: "Se cerró la sesión.",
                            type: MessageType.info,
                          );
                        }
                        if (context.mounted) {
                          context.pop();
                        }
                        // Cierra sesión
                        await authNotifier.logout();

                        // Redirige luego de cerrar sesión
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
