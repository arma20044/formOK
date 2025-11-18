import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/enviromens/enrivoment.dart';
import 'package:form/model/consulta_facturas.dart';
import 'package:form/provider/theme_provider.dart';
import 'package:form/utils/utils.dart';
import 'package:intl/intl.dart';

class FacturaScrollHorizontal extends ConsumerStatefulWidget {
  final List<Lista?>? facturas;
  final TextEditingController nis;

  const FacturaScrollHorizontal({
    super.key,
    required this.facturas,
    required this.nis,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FacturaScrollHorizontalState();
}

class _FacturaScrollHorizontalState
    extends ConsumerState<FacturaScrollHorizontal> {
  
  bool _isDownloading = false;

  // Función helper para calcular la "cifra"
  num calcularCifra(String nis, String fechaVencimiento) {
    if (nis.length < 3) return 0;
    final nisParcial = int.tryParse(nis.substring(0, 3)) ?? 0;
    final parts = fechaVencimiento.split('-');
    if (parts.length != 3) return 0;
    final dia = int.tryParse(parts[2]) ?? 0;
    final mes = int.tryParse(parts[1]) ?? 0;
    final anho = int.tryParse(parts[0]) ?? 0;
    final mejunje = anho - (dia * mes);
    final oper = (int.tryParse(nis) ?? 0) * nisParcial + (int.tryParse(nis) ?? 0);
    return oper * mejunje;
  }

  @override
  Widget build(BuildContext context) {
    final formatoMoneda = NumberFormat.currency(locale: 'es_PY', symbol: '₲');
    final formatoFecha = DateFormat('dd/MM/yyyy');
    final themeState = ref.watch(themeNotifierProvider);

    if (widget.facturas == null || widget.facturas!.isEmpty) {
      return SizedBox(
        height: 180,
        child: Center(child: Text('No hay facturas disponibles')),
      );
    }

    return SizedBox(
      height: 200, // un poquito más alto para que el botón no se corte
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.facturas!.length,
        itemBuilder: (context, index) {
          final factura = widget.facturas![index];
          if (factura == null) return const SizedBox();

          final cifra = calcularCifra(widget.nis.text, factura.fechaVencimiento);

          final fechaFacturacion = DateTime.tryParse(factura.fechaFacturacion ?? '');
          final fechaEmision = DateTime.tryParse(factura.fechaEmision ?? '');
          final fechaVencimiento = DateTime.tryParse(factura.fechaVencimiento ?? '');

          final urlFinal = "${Environment.hostCtxOpen}/v5/suministro/facturaElectronicaPdfMobile"
              "?nro_nis=${widget.nis.text}"
              "&sec_nis=${factura.secNis}"
              "&sec_rec=${factura.secRec}"
              "&f_fact=${fechaFacturacion != null ? formatoFecha.format(fechaFacturacion) : ''}"
              "&clientKey=${Environment.clientKey}"
              "&value=$cifra"
              "&fecha=${factura.fechaVencimiento}";

          return Container(
            width: 300,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: themeState.value!.isDarkMode ? Colors.white : Colors.black,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            formatoMoneda.format(factura.importe),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Chip(
                          label: Text(
                            factura.esPagado! ? 'Pagado' : 'Pendiente de Pago',
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          backgroundColor:
                              factura.esPagado! ? Colors.green : Colors.orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Emisión: ${fechaEmision != null ? formatoFecha.format(fechaEmision) : '-'}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Vencimiento: ${fechaVencimiento != null ? formatoFecha.format(fechaVencimiento) : '-'}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: _isDownloading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _isDownloading = true;
                                });
                                try {
                                  final File archivoDescargado =
                                      await descargarPdfConPipe(
                                    urlFinal,
                                    'factura_${factura.nirSecuencial}.pdf',
                                  );
                                  mostrarCustomModal(context, archivoDescargado);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error al abrir PDF: $e')),
                                  );
                                } finally {
                                  setState(() {
                                    _isDownloading = false;
                                  });
                                }
                              },
                              child: const Text("Ver Factura", style: TextStyle(fontSize: 14)),
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
