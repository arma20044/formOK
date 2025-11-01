// Componente vertical scroll
import 'package:flutter/material.dart';
import 'package:form/presentation/components/common/card_item_second.dart';

import 'package:form/presentation/screens/comercial/mis_suministros/tabs/facturas_tab.dart';

class VerticalScrollCards extends StatelessWidget {
  const VerticalScrollCards({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Factura>>(
      future: fetchFacturas(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay facturas'));
        }

        final facturas = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          itemCount: facturas.length,
          itemBuilder: (context, index) {
            final factura = facturas[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CardItemSecond(
                monto: '120.000',
                estadoPago: 'Pendiente',
                estadoColor: Colors.orange,
                fechaEmision: '01/11/2025',
                fechaVencimiento: '15/11/2025',
                onVerFacturaPressed: () {
                  print('Ver factura presionado');
                },
              ),
            );
          },
        );
      },
    );
  }
}
