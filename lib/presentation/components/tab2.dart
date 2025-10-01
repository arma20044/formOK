import 'package:flutter/material.dart';

class Tab2 extends StatefulWidget {
  const Tab2({super.key});
  @override
  Tab2State createState() => Tab2State();
}

class Tab2State extends State<Tab2> {
  String archivoSeleccionado = '';

  void limpiar() => setState(() => archivoSeleccionado = '');

  bool validar() => archivoSeleccionado != null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FormField<String>(
        initialValue: archivoSeleccionado,
        validator: (val) => val == null ? "Seleccione un archivo" : null,
        builder: (state) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => setState(() => archivoSeleccionado = "archivo_simulado.txt"),
              child: const Text("Seleccionar archivo"),
            ),
            const SizedBox(height: 20),
            Text(archivoSeleccionado ?? "Ningún archivo seleccionado"),
            if (state.errorText != null)
              Text(state.errorText!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
