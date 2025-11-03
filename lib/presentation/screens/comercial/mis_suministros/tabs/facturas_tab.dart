import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/enviromens/Enrivoment.dart';
import 'package:form/presentation/components/common/UI/custom_loading.dart';
import 'package:form/presentation/components/common/card_item_first.dart';

import 'package:form/presentation/components/common/card_item_second.dart';
import 'package:form/provider/situacion_actual_provider.dart';
import 'package:form/provider/ultimas_facturas_provider.dart';
import 'package:form/utils/utils.dart';
import '../../../../../model/login_model.dart';

class FacturasTab extends ConsumerStatefulWidget {
  final SuministrosList? selectedNIS;
  final String? token;

  const FacturasTab(this.selectedNIS, this.token, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FacturasTabState();
}

bool _isLoadingFactura = false;

class _FacturasTabState extends ConsumerState<FacturasTab> {
  @override
  Widget build(BuildContext context) {
    final asyncFacturas = ref.watch(facturasProvider);

    final asyncSituacionActual = ref.watch(situacionActualProvider);

    print(asyncSituacionActual);

    final horizontalTitles = ['Deuda Total', 'Deuda Anterior'];

    return Column(
      children: [
        const SizedBox(height: 10),
        //HorizontalCards(titles: horizontalTitles),
        Expanded(
          child: asyncSituacionActual.when(
            data: (situacionActual) {
              if (situacionActual.facturaDatos.length == 0) {
                return const Center(child: Text("No hay factuas sin pagar."));
              }

              //logica para mostrar cards
              return Column(
                children: [
                  situacionActual.tieneDeuda!
                      ? CardItemFirst(
                          title: "Deuda Total",
                          monto: situacionActual
                              .facturaDatos['recibo']['importeRecibo']
                              .toString(),
                          fechaLectura: situacionActual
                              .facturaDatos['recibo']['fechaVencimiento'],
                          lectura: situacionActual.calculoConsumo['consumo']
                              .toString(),
                          consumo: "",
                          fechaVencimiento:
                              situacionActual
                                  .facturaDatos['recibo']['fechaVencimiento'] ??
                              'Sin dato',
                          totalConComision: situacionActual
                              .facturaDatos['otrosImportes']['totalconComision']
                              .toString(),
                          onPrimaryPressed: () {
                            print("Ver Ultima Factura");
                          },
                          onSecondaryPressed: () {
                            print("Pagar");
                          },
                        )
                      : Text(""),

                  situacionActual.tieneDeuda! &&
                          situacionActual.facturaDatos['recibo']['cantidad'] > 1
                      ? CardItemFirst(
                          title: "Deuda Anterior",
                          monto: situacionActual
                              .facturaPenultima['recibo']['importeRecibo']
                              .toString(),
                          fechaLectura: situacionActual
                              .facturaPenultima['recibo']['fechaVencimiento'],
                          lectura: situacionActual.calculoConsumo['consumo']
                              .toString(),
                          consumo: "",
                          fechaVencimiento:
                              situacionActual
                                  .facturaPenultima['recibo']['fechaVencimiento'] ??
                              'Sin dato',
                          totalConComision: situacionActual
                              .facturaPenultima['otrosImportes']['totalconComision']
                              .toString(),
                          onPrimaryPressed: () async {},
                          onSecondaryPressed: () {
                            print("Pagar");
                          },
                        )
                      : Text(""),
                ],
              );
            },
            loading: () => const CustomLoading(text: "Cargando..."),
            error: (error, _) => Center(child: Text('Error: $error')),
          ),
        ),

        const SizedBox(height: 16),

        Expanded(
          child: asyncFacturas.when(
            data: (facturas) {
              if (facturas.isEmpty) {
                return const Center(child: Text("No hay facturas disponibles"));
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "Últimos Comprobantes",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Usar Flexible para el ListView
                  Flexible(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: facturas.length,
                      itemBuilder: (context, index) {
                        final factura = facturas[index];

                        num nisParcial = int.parse(
                          widget.selectedNIS!.nisRad.toString().substring(0, 3),
                        );
                        List<String> fechaObtenida = factura.fechaVencimiento!
                            .split('-');
                        num dia = int.parse(fechaObtenida[2]);
                        num mes = int.parse(fechaObtenida[1]);
                        num anho = int.parse(fechaObtenida[0]);
                        num mejunje = (anho - (dia * mes));
                        num oper =
                            (((widget.selectedNIS!.nisRad! * nisParcial) +
                            widget.selectedNIS!.nisRad!));
                        num res = oper * mejunje;
                        String cifra = res.toString();

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
                            fechaVencimiento:
                                factura.fechaVencimiento ?? 'Sin dato',
                            onVerFacturaPressed: () async {
                              setState(() {
                                _isLoadingFactura = true;
                              });
                              print("Ver Ultima Factura");
                              try {
                                final fecha = factura.fechaVencimiento;
                                final fecha_fac = formatearFecha(
                                  fecha: factura.fechaFacturacion!,
                                  formatoSalida: '/',
                                );
                                final String urlFinal =
                                    factura.facturaElectronica!
                                    ? '${Environment.hostCtxOpen}/v5/suministro/facturaElectronicaPdfMobile?nro_nis=${widget.selectedNIS!.nisRad}&clientKey=${Environment.clientKey}&value=$cifra&fecha=$fecha&sec_nis=${factura.secNis}&sec_rec=${factura.secRec}&f_fact=$fecha_fac'
                                    : "";

                                print(urlFinal);

                                final File archivoDescargado =
                                    await descargarPdfConPipe(
                                      urlFinal, // URL del PDF
                                      'factura_${factura.nirSecuencial}.pdf',
                                    );

                                setState(() {
                                  _isLoadingFactura = false;
                                });

                                mostrarCustomModal(context, archivoDescargado);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error al abrir PDF: $e'),
                                  ),
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
                    ),
                  ),
                ],
              );
            },
            loading: () => const CustomLoading(text: "Cargando..."),
            error: (error, _) => Center(child: Text('Error: $error')),
          ),
        ),
      ],
    );
  }
}
