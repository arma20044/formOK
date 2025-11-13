import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ListaBotones extends StatelessWidget {
  final List<BotonNavegacion> botones;

  const ListaBotones({
    super.key,
    required this.botones,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: botones.length,
      itemBuilder: (context, index) {
        final boton = botones[index];
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: Icon(boton.icon, size: 24),
            label: Text(
              boton.texto,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              //Navigator.pushNamed(context, boton.ruta);
              context.push(boton.ruta);
            },
          ),
        );
      },
    );
  }
}

class BotonNavegacion {
  final IconData icon;
  final String texto;
  final String ruta;

  BotonNavegacion({
    required this.icon,
    required this.texto,
    required this.ruta,
  });
}
