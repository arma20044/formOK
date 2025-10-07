import 'package:flutter/material.dart';
import 'package:form/model/consulta_facturas.dart';

class DatosCard extends StatelessWidget {
  final DatosCliente? datosCliente;
  final String nis;

  const DatosCard({super.key, required this.datosCliente, required this.nis});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          Text('NIS: $nis', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            'NIS: ${datosCliente?.nombre}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'RUC/CI: ${datosCliente?.ruc}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
