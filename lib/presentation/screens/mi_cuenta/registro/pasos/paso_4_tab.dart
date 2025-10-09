import 'package:flutter/material.dart';

class Paso4Tab extends StatefulWidget {
  const Paso4Tab({super.key});

  @override
  State<Paso4Tab> createState() => _Paso4TabState();
}

class _Paso4TabState extends State<Paso4Tab> {
  final Map<String, bool> opciones = {
    'Acepto los términos y condiciones': false,
    'Deseo recibir notificaciones por correo': false,
    'Autorizo el uso de mis datos personales': false,
  };

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Text(
          'Confirmaciones y Consentimientos',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...opciones.keys.map((texto) {
          return CheckboxListTile(
            title: Text(texto),
            value: opciones[texto],
            onChanged: (bool? value) {
              setState(() {
                opciones[texto] = value ?? false;
              });
            },
          );
        }),
        const SizedBox(height: 20),
        Builder(
          builder: (context) {
            final bool algunSeleccionado = opciones.containsValue(true);
            if (!algunSeleccionado) {
              return const Text(
                '⚠️ Debe seleccionar al menos una opción para continuar',
                style: TextStyle(color: Colors.red),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
