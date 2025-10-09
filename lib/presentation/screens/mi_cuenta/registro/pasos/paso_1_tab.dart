import 'package:flutter/material.dart';

class Paso1Tab extends StatelessWidget {
  const Paso1Tab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: 'Nombre'),
          validator: (value) =>
              value == null || value.isEmpty ? 'Campo obligatorio' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Correo'),
          validator: (value) =>
              value == null || value.isEmpty ? 'Campo obligatorio' : null,
        ),
      ],
    );
  }
}
