import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BotonNavegacion {
  final IconData icon;
  final String texto;
  final String? ruta;
  final VoidCallback? accion; // Nueva propiedad para acciones

  const BotonNavegacion({
    required this.icon,
    required this.texto,
    this.ruta,
    this.accion,
  }) : assert(ruta != null || accion != null, 'Debes proveer ruta o accion');
}

class ListaBotones extends StatelessWidget {
  final List<BotonNavegacion> botones;

  const ListaBotones({super.key, required this.botones});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: botones.length,
      itemBuilder: (context, index) {
        final b = botones[index];
        return OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            alignment: Alignment.centerLeft,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: Icon(b.icon, size: 24),
          label: Text(b.texto),
          onPressed: () {
            if (b.accion != null) {
              b.accion!(); // Ejecuta la función (ej: showDialog)
            } else if (b.ruta != null) {
              context.push(b.ruta!); // Navega
            }
          },
        );
      },
    );
  }
}
