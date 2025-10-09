import 'package:flutter/material.dart';
import 'package:form/model/consulta_facturas.dart';

class DatosCard extends StatelessWidget {
  final DatosCliente? datosCliente;
  final String nis;

  const DatosCard({super.key, required this.datosCliente, required this.nis});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Container(
        alignment: Alignment.bottomLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'NIS: $nis',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              textAlign: TextAlign.left,
            ),
            Text(
              '${datosCliente?.nombre}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
            ),
            Text(
              'RUC/CI: ${datosCliente?.ruc}',
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
