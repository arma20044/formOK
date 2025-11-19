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

        Expanded(
          child: asyncSituacionActual.when(
            data: (situacionActual) {
              // Validación de nulos críticos
              final facturaDatos = situacionActual.facturaDatos;
              final factura = situacionActual.facturaDatos;
              final tieneDeuda = situacionActual.tieneDeuda ?? false;

              if (facturaDatos == null ||
                  facturaDatos.recibo == null ||
                  facturaDatos.recibo!.fechaVencimiento == null ||
                  widget.selectedNIS?.nisRad == null) {
                return Center(
                  child: Text(
                    "Error de datos para el suministro NIS: ${widget.selectedNIS?.nisRad ?? 'Desconocido'}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              String fechaVencimiento = '';
              String cifra = '';
              if (situacionActual.facturaDatos != null) {
                fechaVencimiento =
                    situacionActual.facturaDatos!.recibo.fechaVencimiento!;

                num nisParcial = int.parse(
                  widget.selectedNIS!.nisRad.toString().substring(0, 3),
                );
                List<String> fechaObtenida = fechaVencimiento!.split('/');
                num dia = int.parse(fechaObtenida[0]);
                num mes = int.parse(fechaObtenida[1]);
                num anho = int.parse(fechaObtenida[2]);
                num mejunje = (anho - (dia * mes));
                num oper =
                    (((widget.selectedNIS!.nisRad! * nisParcial) +
                    widget.selectedNIS!.nisRad!));
                num res = oper * mejunje;
                cifra = res.toString();
              }
              if (situacionActual.facturaPagada != null) {
                fechaVencimiento =
                    situacionActual.facturaPagada!.fechaVencimiento!;

                num nisParcial = int.parse(
                  widget.selectedNIS!.nisRad.toString().substring(0, 3),
                );
                List<String> fechaObtenida = fechaVencimiento.split('-');
                num dia = int.parse(fechaObtenida[2]);
                num mes = int.parse(fechaObtenida[1]);
                num anho = int.parse(fechaObtenida[0]);
                num mejunje = (anho - (dia * mes));
                num oper =
                    (((widget.selectedNIS!.nisRad! * nisParcial) +
                    widget.selectedNIS!.nisRad!));
                num res = oper * mejunje;
                cifra = res.toString();
              }

              return Column(
                children: [
                  tieneDeuda
                      ? CardItemFirst(
                          isLoadingFacturaDeudaTotal:
                              _isLoadingFacturaDeudaTotal,
                          title: "Deuda Total",
                          monto:
                              facturaDatos.recibo?.importeRecibo?.toString() ??
                              "0",
                          fechaLectura: fechaVencimiento,
                          lectura:
                              facturaDatos.lectura?.first?.lecturaActual
                                  ?.toString() ??
                              "-",
                          consumo:
                              "${facturaDatos.lectura?.first?.consumo ?? 0} KWh",
                          fechaVencimiento: fechaVencimiento,
                          totalConComision:
                              facturaDatos.otrosImportes?.totalconComision
                                  ?.toString() ??
                              "0",
                          onPrimaryPressed: () => print("Ver Ultima Factura"),
                          onSecondaryPressed: () async {
                            setState(() {
                              _isLoadingFacturaDeudaTotal = true;
                            });

                            try {
                              final String urlFinal =
                                  facturaDatos.facturaElectronica == true
                                  ? "${Environment.hostCtxOpen}/v5/suministro/ultimaFacturaElectronicaPendientePdfMobile?nis=${widget.selectedNIS?.nisRad}&clientKey=${Environment.clientKey}&fecha=$fechaVencimiento&value=$cifra&fecha=$fechaVencimiento"
                                  : "${Environment.hostCtxOpen}/v4/suministro/ultimaFacturaPendientePdfMobile?nis=${widget.selectedNIS?.nisRad}&clientKey=${Environment.clientKey}&value=$cifra&fecha=$fechaVencimiento";

                              final File
                              archivoDescargado = await descargarPdfConPipe(
                                urlFinal,
                                'factura_${facturaDatos.recibo?.nirSecuencial ?? '0'}.pdf',
                              );

                              mostrarCustomModal(context, archivoDescargado);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error al abrir PDF: $e'),
                                ),
                              );
                            } finally {
                              setState(() {
                                _isLoadingFacturaDeudaTotal = false;
                              });
                            }
                          },
                        )
                      : const Text("Sin deudas"),

                  // Deuda anterior solo si hay más de una
                  (tieneDeuda && (facturaDatos.recibo?.cantidad ?? 0) > 1)
                      ? CardItemFirst(
                          isLoadingFacturaDeudaTotal:
                              _isLoadingFacturaDeudaTotal,
                          title: "Deuda Anterior",
                          monto:
                              situacionActual
                                  .facturaPenultima?['recibo']?['importeRecibo']
                                  ?.toString() ??
                              "0",
                          fechaLectura:
                              situacionActual
                                  .facturaPenultima?['recibo']?['fechaVencimiento'] ??
                              "Sin dato",
                          lectura:
                              situacionActual.calculoConsumo?['consumo']
                                  ?.toString() ??
                              "-",
                          consumo: "",
                          fechaVencimiento:
                              situacionActual
                                  .facturaPenultima?['recibo']?['fechaVencimiento'] ??
                              "Sin dato",
                          totalConComision:
                              situacionActual
                                  .facturaPenultima?['otrosImportes']?['totalconComision']
                                  ?.toString() ??
                              "0",
                          onPrimaryPressed: () async {},
                          onSecondaryPressed: () => print("Pagar"),
                        )
                      : const SizedBox(),
                ],
              );
            },
            loading: () => const CustomLoading(text: "Cargando..."),
            error: (error, _) => Center(
              child: Text(
                "Error al cargar datos para el suministro NIS: ${widget.selectedNIS?.nisRad ?? 'Desconocido'}",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

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
                  final fechaEmision = DateTime.tryParse(
                    factura.fechaEmision ?? '',
                  );
                  final fechaVencimiento = DateTime.tryParse(
                    factura.fechaVencimiento ?? '',
                  );

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
                              ? "${Environment.hostCtxOpen}/v5/suministro/facturaElectronicaPdfMobile"
                                    "?nro_nis=${widget.selectedNIS!.nisRad}"
                                    "&sec_nis=${factura.secNis}"
                                    "&sec_rec=${factura.secRec}"
                                    "&f_fact=${fechaFacturacion != null ? formatoFecha.format(fechaFacturacion) : ''}"
                                    "&clientKey=${Environment.clientKey}"
                                    "&value=$cifra"
                                    "&fecha=${factura.fechaVencimiento}"
                              : '${Environment.hostCtxOpen}/v4/suministro/facturaPdfMobile?nro_nis=${widget.selectedNIS?.nisRad}&clientKey=${Environment.clientKey}&value=$cifra&fecha=${factura.fechaVencimiento}&sec_nis=${factura.secNis}&sec_rec=${factura.secRec}"&f_fact=${fechaFacturacion != null ? formatoFecha.format(fechaFacturacion) : ''}"';

                          print(urlFinal);

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
              child: Text(
                "Error al cargar facturas para el suministro NIS: ${widget.selectedNIS?.nisRad ?? 'Desconocido'}",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
