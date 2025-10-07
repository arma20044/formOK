import 'package:flutter/material.dart';
import 'package:form/model/consulta_facturas.dart';
import 'package:intl/intl.dart';

class FacturaScrollHorizontal extends StatelessWidget {
  final   List<Lista?>? facturas;

  const FacturaScrollHorizontal({super.key, required this.facturas});

  @override
  Widget build(BuildContext context) {
    final formatoMoneda = NumberFormat.currency(locale: 'es_PY', symbol: '₲');
    final formatoFecha = DateFormat('dd/MM/yyyy');

    return SizedBox(
      height: 180, // altura del scroll
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: facturas!.length,
        itemBuilder: (context, index) {
          final factura = facturas![index];
          return Container(
            width: 250,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Fecha: ${formatoFecha.format(DateTime.parse(factura!.fechaFacturacion!))}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text('Estado: ${factura.estadoFactura}'),
                    Text('Importe: ${formatoMoneda.format(factura.importe)}'),
                    Text('Vencimiento: ${formatoFecha.format(DateTime.parse(factura.fechaVencimiento!))}'),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Chip(
                        label: Text(
                          factura.esPagado! ? 'Pagado' : 'Pendiente',
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: factura.esPagado!
                            ? Colors.green
                            : Colors.orange,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
