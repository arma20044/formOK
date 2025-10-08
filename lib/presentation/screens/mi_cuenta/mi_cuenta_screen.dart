import 'package:flutter/material.dart';
import 'package:form/presentation/components/common/lista_botones.dart';

class MiCuentaScreen extends StatelessWidget {
  const MiCuentaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final botones = [
      BotonNavegacion(icon: Icons.abc, texto: 'Inicio', ruta: '/inicio'),
      BotonNavegacion(icon: Icons.person, texto: 'Perfil', ruta: '/perfil'),
      BotonNavegacion(
        icon: Icons.settings,
        texto: 'Configuración',
        ruta: '/configuracion',
      ),
      BotonNavegacion(
        icon: Icons.logout,
        texto: 'Cerrar sesión',
        ruta: '/logout',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Mi Cuenta")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListaBotones(botones: botones),
      ),
    );
  }
}
