import 'package:flutter/material.dart';

class MiCuenta extends StatelessWidget {
  const MiCuenta({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Mi Cuenta"),
      ),
      body: Column(
        children: [
          TextButton(onPressed: () => print("hola"), child: Text("Suministros"))
        ],
      ),
    );
  }
}