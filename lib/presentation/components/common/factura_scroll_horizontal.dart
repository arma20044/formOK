import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:form/core/enviromens/enrivoment.dart';
import 'package:form/model/consulta_facturas.dart';
import 'package:form/presentation/components/common/custom_ask_modal.dart';
import 'package:form/presentation/components/common/custom_pdf_modal.dart';
import 'package:form/presentation/components/common/pad_viewer.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

/*
const uriPdf = 
    facturaItem.facturaElectronica
    ?
    Environment.HOST_CTX_OPEN + "/v5/suministro/facturaElectronicaPdfMobile?"
    + "nro_nis=" + nis
        + "&sec_nis=" + sec_nis
        + "&sec_rec=" + sec_rec
        + "&f_fact=" + fechaAAAAMMDD_toDDMMAAAA( fechaFacturacion )
        + "&clientKey=" + Environment.CLIENT_KEY
        + "&value=" + cifra
        + "&fecha=" + fechaVencimiento
    :
    Environment.HOST_CTX_OPEN + "/v4/suministro/facturaPdfMobile?"
        + "nro_nis=" + nis
        + "&sec_nis=" + sec_nis
        + "&sec_rec=" + sec_rec
        + "&f_fact=" + fechaAAAAMMDD_toDDMMAAAA( fechaFacturacion )
        + "&clientKey=" + Environment.CLIENT_KEY
        + "&value=" + cifra
        + "&fecha=" + fechaVencimiento;
        */

class FacturaScrollHorizontal extends StatelessWidget {
  final List<Lista?>? facturas;
  final TextEditingController nis;

  const FacturaScrollHorizontal({
    super.key,
    required this.facturas,
    required this.nis,
  });

  Future<File> descargarPdfConPipe(String url, String nombreArchivo) async {
    Dio dio = Dio();

    Directory dir = await getTemporaryDirectory();
    String ruta = '${dir.path}/$nombreArchivo';
    File archivo = File(ruta);

    try {
      final response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            'Accept': 'application/pdf',
            'x-so': Platform.isAndroid ? 'Android' : 'IOS',
          },
        ),
      );

      final body = response.data as ResponseBody;

      final total = body.contentLength ?? -1;
      int recibido = 0;

      print('Status code: ${response.statusCode}');
      print('Headers: ${response.headers}');

      final sink = archivo.openWrite();

      // Esto descarga y escribe automáticamente el stream en el archivo
      await for (final chunk in body.stream) {
        recibido += chunk.length;
        if (total != -1) {
          print('Descargando: ${(recibido / total * 100).toStringAsFixed(0)}%');
        }
        sink.add(chunk);
      }

      await sink.close();
      print('Descarga completada: ${archivo.path}');

      print('Tamaño del archivo: ${await archivo.length()} bytes');

      final bytes = await archivo.readAsBytes();
      print('Primeros bytes: ${String.fromCharCodes(bytes.take(100))}');

      return archivo;
    } catch (e) {
      throw Exception('Error al descargar PDF: $e');
    }
  }

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
                      /*onPressed: () async {
                        try {
                          final File archivoDescargado =
                              await descargarPdfConPipe(
                                urlFinal, // URL del PDF
                                'factura_${factura.nirSecuencial}.pdf',
                              );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PdfViewerScreen(stringPdf: archivoDescargado),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al abrir PDF: $e')),
                          );
                        }
                      },*/
                      onPressed: () => mostrarCustomModal(context),

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

void mostrarCustomModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return CustomPdfModal(
        title: 'Confirmar acción',
        content: const Text(
          '¿Deseas continuar con esta acción?',
          textAlign: TextAlign.center,
        ),
        onConfirm: () {
          // acción de confirmación
          debugPrint('Confirmado ✅');
        },
        onCancel: () {
          debugPrint('Cancelado ❌');
        },
      );
    },
  );
}
