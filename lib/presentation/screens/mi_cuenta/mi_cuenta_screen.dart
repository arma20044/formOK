import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/config/constantes.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/auth/model/auth_state.dart';
import 'package:form/infrastructure/infrastructure.dart';
import 'package:form/presentation/components/common/custom_snackbar.dart';
import 'package:form/presentation/components/common/lista_botones.dart';
import 'package:form/presentation/components/common/logout_dialog.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:form/repositories/eliminar_cuenta_repository_impl.dart';
import 'package:go_router/go_router.dart';

class MiCuentaScreen extends ConsumerStatefulWidget {
  const MiCuentaScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EliminarCuentaScreenState();
}

class _EliminarCuentaScreenState extends ConsumerState<MiCuentaScreen> {
  Future<void> _eliminarCuenta() async {
    bool isLoading = false;
    final authState = ref.read(authProvider);
    final token = authState.value?.user?.token;

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Su sesión ha expirado, debe volver a logearse'),
        ),
      );
      return;
    }

    try {
      final repoEliminarCuenta = EliminarCuentaRepositoryImpl(
        EliminarCuentaDatasourceImpl(MiAndeApi()),
      );

      final eliminarCuentaResponse = await repoEliminarCuenta.getEliminarCuenta(
        token,
      );

      if (eliminarCuentaResponse.error == true) {
        CustomSnackbar.show(
          context,
          message: "Ocurrió un error, Favor intente nuevamente la consulta",
          type: MessageType.error,
        );

        setState(() {
          isLoading = false;
        });
        return;
      }

      // Cierra sesión
      final authNotifier = ref.read(authProvider.notifier);
      await authNotifier.logout();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La cuenta se eliminó Exitosamente.')),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
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
        accion: () => showDialog(
          context: context,
          builder: (_) =>
              //const AlertDialog(title: Text("Info"), content: Text("¡Hola!")),
              SizedBox(
                height: 100,
                child: AlertDialog(
                  actions: [
                    OutlinedButton(onPressed: dispose, child: Text("NO")),
                    OutlinedButton(
                      onPressed: () {
                        _eliminarCuenta();
                      },
                      child: Text("SI"),
                    ),
                  ],
                  content: Column(
                    children: [Text("Deseas eliminar tu Cuenta MI ANDE?")],
                  ),
                ),
              ),
        ),
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
