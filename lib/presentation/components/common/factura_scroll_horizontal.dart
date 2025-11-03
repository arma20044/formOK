import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/enviromens/enrivoment.dart';
import 'package:form/model/consulta_facturas.dart';
import 'package:form/provider/theme_provider.dart';
import 'package:form/utils/utils.dart';
import 'package:intl/intl.dart';



class FacturaScrollHorizontal extends ConsumerWidget {
  final List<Lista?>? facturas;
  final TextEditingController nis;

  const FacturaScrollHorizontal({
    super.key,
    required this.facturas,
    required this.nis,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatoMoneda = NumberFormat.currency(locale: 'es_PY', symbol: '₲');
    final formatoFecha = DateFormat('dd/MM/yyyy');
        final themeState = ref.watch(themeNotifierProvider);


    return SizedBox(
      height: 180, // altura del scroll
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: facturas!.length,
        itemBuilder: (context, index) {
          final factura = facturas![index];

          num nisParcial = int.parse(nis.text.toString().substring(0, 3));
          List<String> fechaObtenida = factura!.fechaVencimiento.split('-');
          num dia = int.parse(fechaObtenida[2]);
          num mes = int.parse(fechaObtenida[1]);
          num anho = int.parse(fechaObtenida[0]);
          num mejunje = (anho - (dia * mes));
          num oper =
              (((int.parse(nis.text) * nisParcial) + int.parse(nis.text)));
          num res = oper * mejunje;
          String cifra = res.toString();

          String urlFinal =
              "${Environment.hostCtxOpen}/v5/suministro/facturaElectronicaPdfMobile?" +
              "nro_nis=" +
              nis.text +
              "&sec_nis=" +
              factura!.secNis.toString() +
              "&sec_rec=" +
              factura.secRec.toString() +
              "&f_fact=" +
              formatoFecha.format(DateTime.parse(factura.fechaFacturacion!)) +
              "&clientKey=" +
              Environment.clientKey +
              "&value=" +
              cifra +
              "&fecha=" +
              factura.fechaVencimiento;

          return Container(
            width: 300,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: themeState.value!.isDarkMode ? Colors.white : Colors.black,
                  width: 0.5, // Set your desired border width here
                ),
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
                      onPressed: () async {
                        try {
                          final File archivoDescargado =
                              await descargarPdfConPipe(
                                urlFinal, // URL del PDF
                                'factura_${factura.nirSecuencial}.pdf',
                              );

                          mostrarCustomModal(context, archivoDescargado);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al abrir PDF: $e')),
                          );
                        }
                      },

                      // onPressed: () => mostrarCustomModal(context),
                      child: Text(
                        "Ver Factura",
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


