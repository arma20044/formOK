import 'package:flutter/material.dart';
import 'package:form/presentation/components/common/card_item_first.dart';
import 'package:form/presentation/components/common/horizontal_cards.dart';
import 'package:form/presentation/components/common/vertical_scroll_cards.dart';


// Modelo de datos
class Factura {
  final String titulo;
  final String monto;
  final String fechaLectura;
  final String lectura;
  final String consumo;
  final String fechaVencimiento;
  final String totalConComision;

  Factura({
    required this.titulo,
    required this.monto,
    required this.fechaLectura,
    required this.lectura,
    required this.consumo,
    required this.fechaVencimiento,
    required this.totalConComision,
  });
}

// Simulación de fetch de datos
Future<List<Factura>> fetchFacturas() async {
  await Future.delayed(const Duration(seconds: 2));
  return [
    Factura(
      titulo: 'Factura 1',
      monto: '150.000',
      fechaLectura: '01/11/2025',
      lectura: '12345',
      consumo: '150',
      fechaVencimiento: '10/11/2025',
      totalConComision: '155.000',
    ),
    Factura(
      titulo: 'Factura 2',
      monto: '200.000',
      fechaLectura: '01/11/2025',
      lectura: '23456',
      consumo: '200',
      fechaVencimiento: '10/11/2025',
      totalConComision: '206.000',
    ),
  ];
}


// Pantalla completa combinada
class FacturasTab extends StatelessWidget {
  const FacturasTab({super.key});

  @override
  Widget build(BuildContext context) {
    final horizontalTitles = ['Dueda Total', 'Deuda Anterior'];

    return Scaffold(
      
      body:  
      // VerticalScrollCards()
      //HorizontalCards(titles: horizontalTitles),
      Column(
        children: [
          const SizedBox(height: 10),
          HorizontalCards(titles: horizontalTitles),
          const SizedBox(height: 16),
          // Vertical scroll ocupa el resto de la pantalla
          const Expanded(child: VerticalScrollCards()),
        ],
      ),
    );
  }
}
