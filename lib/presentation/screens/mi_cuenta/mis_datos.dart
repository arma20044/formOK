

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/auth/model/auth_state.dart';
import 'package:form/core/auth/model/user_model.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';

class MisDatos extends ConsumerWidget {
  const MisDatos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    UserModel? datosJson;

    if (authState.value?.state == AuthState.authenticated) {
      datosJson = authState.value?.user;
      print(datosJson!.apellido);
    }

    return Scaffold(
      endDrawer: CustomDrawer(),
      appBar: AppBar(title: Text("Mis Datos")),
      body: Center(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ), 
                borderRadius: BorderRadius.circular(10), // Bordes redondeados
              ),
              child: Column(
                children: [
                  Text(
                    datosJson?.nombre ?? 'No disponible',
                    style: TextStyle(fontSize: 40),
                  ),
                  Text(
                    datosJson?.apellido ?? 'No disponible',
                    style: TextStyle(fontSize: 40),
                  ),
                ],
              ),
            ),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ), 
                borderRadius: BorderRadius.circular(10), // Bordes redondeados
              ),
              child: Column(
                children: [
                  Text("Nombre: ${datosJson?.nombre ?? 'No disponible'}"),
                  Text("Apellido: ${datosJson?.apellido ?? 'No disponible'}"),
                  //Text("Correo: ${datosJson?. ?? 'No disponible'}"),
                  //Text("Teléfono Celular: ${datosJson?. ?? 'No disponible'}"),
                  Text(
                    "Tipo Solicitante: ${datosJson?.tipoSolicitante ?? 'No disponible'}",
                  ),

                  //Text("Dirección: ${datosJson?.dire ?? 'No disponible'}"),
                  //Text("País: ${datosJson?.pais ?? 'No disponible'}"),
                  //Text("Departamento: ${datosJson?.departamento ?? 'No disponible'}"),

                  //Text("Ciudad: ${datosJson?.ciudad ?? 'No disponible'}"),

                  // Text("Tipo Cliente: ${datosJson?.tipocliente ?? 'No disponible'}"),
                  Text(
                    "Documento: ${datosJson?.numeroDocumento ?? 'No disponible'}",
                  ),
                ],
              ),
            ),

            TextButton(onPressed: () {}, child: Text("Cambiar Contraseña")),
          ],
        ),
      ),
    );
  }
}
