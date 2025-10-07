import 'package:flutter/material.dart';
import 'package:form/model/consulta_facturas.dart';
import 'package:intl/intl.dart';

class FacturaScrollHorizontal extends StatelessWidget {
  final List<Lista?>? facturas;

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
            width: 300,
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
                    Row(
                      children: [
                        Text(
                          formatoMoneda.format(factura!.importe),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Spacer(),
                        Chip(
                          label: Text(
                            factura.esPagado! ? 'Pagado' : 'Pendiente de Pago',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          backgroundColor: factura.esPagado!
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ],
                    ),

                    Text(
                      'Emisión: ${formatoFecha.format(DateTime.parse(factura.fechaEmision!))}',
                      //style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    Text(
                      'Vencimiento: ${formatoFecha.format(DateTime.parse(factura.fechaVencimiento!))}',
                      style: const TextStyle(
                        //fontWeight: FontWeight.bold,
                        //fontSize: 12,
                      ),
                    ),
                    const Spacer(),

                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "Ver Comprobante",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
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
