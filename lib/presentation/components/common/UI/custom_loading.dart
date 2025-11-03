import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  final String text;

  const CustomLoading({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center( // Centra la columna en la pantalla
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente los elementos de la columna
        children: <Widget>[
          CircularProgressIndicator(), // El widget de carga en la parte superior
          const SizedBox(height: 16.0), // Espacio entre el indicador y el texto
          Text(text), // El widget de texto debajo
        ],
      ),
    );
  }
}
