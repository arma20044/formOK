import 'package:flutter/material.dart';

class Tab2 extends StatefulWidget {
  const Tab2({super.key});

  @override
  Tab2State createState() => Tab2State();
}

class Tab2State extends State<Tab2> {
  String? archivoSeleccionado;

  void limpiar() {
    setState(() {
      archivoSeleccionado = null;
    });
  }

  void seleccionarArchivo() {
    setState(() {
      archivoSeleccionado = "archivo_simulado.txt";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: seleccionarArchivo,
            child: const Text("Seleccionar archivo"),
          ),
          const SizedBox(height: 20),
          Text(archivoSeleccionado ?? "Ningún archivo seleccionado"),
        ],
      ),
    );
  }
}
