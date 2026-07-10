import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/enviromens/enrivoment.dart';
import 'package:form/presentation/components/common/UI/custom_loading.dart';
import 'package:form/presentation/components/common/UI/custom_title.dart';

import 'package:form/presentation/components/common/card_item_second.dart';
import 'package:form/provider/situacion_actual_provider.dart';
import 'package:form/provider/ultimas_facturas_provider.dart';
import 'package:form/utils/utils.dart';
import 'package:intl/intl.dart';
import '../../../../../model/login_model.dart';

class FacturasTab extends ConsumerStatefulWidget {
  final SuministrosList? selectedNIS;
  final String? token;

  const FacturasTab(this.selectedNIS, this.token, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FacturasTabState();
}

bool _isLoadingFactura = false;
bool _isLoadingFacturaDeudaTotal = false;

class _FacturasTabState extends ConsumerState<FacturasTab> {
  @override
  Widget build(BuildContext context) {
    final asyncFacturas = ref.watch(facturasProvider);
    final asyncSituacionActual = ref.watch(situacionActualProvider);

    return Column(
      children: [
        const SizedBox(height: 10),

        const SizedBox(height: 16),
        // Agregamos título antes del segundo scroll
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerLeft,
            child: CustomTitle(text: "Últimos Comprobantes"),
          ),
        ),

        /*Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Últimas Facturas",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),*/
        Expanded(
          child: asyncFacturas.when(
            data: (facturas) {
              if (facturas.isEmpty) {
                return const Center(child: Text("No hay facturas disponibles"));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: facturas.length,
                itemBuilder: (context, index) {
                  final formatoFecha = DateFormat('dd/MM/yyyy');

                  final factura = facturas[index];

                  final cifra = calcularCifra(
                    widget.selectedNIS!.nisRad.toString(),
                    factura.fechaVencimiento!,
                  );

                  final fechaFacturacion = DateTime.tryParse(
                    factura.fechaFacturacion ?? '',
                  );
                  /*final fechaEmision = DateTime.tryParse(
                    factura.fechaEmision ?? '',
                  );
                  final fechaVencimiento = DateTime.tryParse(
                    factura.fechaVencimiento ?? '',
                  );*/

                  // Si datos de factura nulos, mostrar mensaje de error central
                  if (factura.importe == null ||
                      factura.fechaVencimiento == null) {
                    return Center(
                      child: Text(
                        "Error de datos en facturas para el suministro NIS: ${widget.selectedNIS?.nisRad ?? 'Desconocido'}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CardItemSecond(
                      isLoadingFactura: _isLoadingFactura,
                      monto: factura.importe.toString(),
                      estadoPago: factura.estadoFactura ?? '',
                      estadoColor: factura.esPagado == true
                          ? Colors.green
                          : Colors.red,
                      fechaEmision: factura.fechaEmision ?? 'Sin dato',
                      fechaVencimiento: factura.fechaVencimiento ?? 'Sin dato',
                      onVerFacturaPressed: () async {
                        setState(() {
                          _isLoadingFactura = true;
                        });

                        try {
                          /*if (factura.facturaElectronica != true) {
                            throw "Factura electrónica no disponible";
                          }*/

                          final String urlFinal = factura.facturaElectronica!
                              ? "${environment.hostCtxOpen}/v5/suministro/facturaElectronicaPdfMobile"
                                    "?nro_nis=${widget.selectedNIS!.nisRad}"
                                    "&sec_nis=${factura.secNis}"
                                    "&sec_rec=${factura.secRec}"
                                    "&f_fact=${fechaFacturacion != null ? formatoFecha.format(fechaFacturacion) : ''}"
                                    "&clientKey=${environment.clientKey}"
                                    "&value=$cifra"
                                    "&fecha=${factura.fechaVencimiento}"
                              : '${environment.hostCtxOpen}/v4/suministro/facturaPdfMobile?nro_nis=${widget.selectedNIS?.nisRad}&clientKey=${environment.clientKey}&value=$cifra&fecha=${factura.fechaVencimiento}&sec_nis=${factura.secNis}&sec_rec=${factura.secRec}"&f_fact=${fechaFacturacion != null ? formatoFecha.format(fechaFacturacion) : ''}"';

                          debugPrint(urlFinal);

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
                            _isLoadingFactura = false;
                          });
                        }
                      },
                    ),
                  );
                },
              );
            },
            loading: () => const CustomLoading(text: "Cargando..."),
            error: (error, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  error.toString().replaceFirst('Exception: ', ''),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
