import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/infrastructure/mi_cuenta/mi_cuenta_ultimas_facturas_datasource_impl.dart';

import 'package:form/model/mi_cuenta/mi_cuenta_ultimas_facturas_model.dart';
import 'package:form/presentation/components/common/card_item_second.dart';
import 'package:form/presentation/components/common/horizontal_cards.dart';
import 'package:form/provider/suministro_provider.dart';
import 'package:form/repositories/repositories.dart';
import '../../../../../model/login_model.dart';

/// Provider que obtiene las facturas del NIS actual
final facturasProvider =
    FutureProvider.autoDispose<List<MiCuentaUltimasFacturasLista>>((ref) async {
      final nis = ref.watch(selectedNISProvider);
      if (nis == null) return [];

      //  final token = ref.watch(_tokenProvider); // si querés pasar token
      final authState = ref.watch(authProvider);

      final token = authState.value?.user?.token;

      final repo = MiCuentaUltimasFacturasRepositoryImpl(
        MiCuentaUltimasFacturasDatasourceImpl(MiAndeApi()),
      );

      final response = await repo.getMiCuentaUltimasFacturas(
        nis.nisRad!.toString(),
        "15",
        token ?? "",
      );

      if (response.error == true) {
        throw Exception(response.errorValList?.first ?? 'Error desconocido');
      }

      final data = response.micuentaultimasfacturasresultado?.lista ?? [];
      return data.whereType<MiCuentaUltimasFacturasLista>().toList();
    });

// (Opcional) si querés manejar token global también:
//final _tokenProvider = StateProvider<String?>((ref) => null);

class FacturasTab extends ConsumerWidget {
  final SuministrosList? selectedNIS;
  final String? token;

  const FacturasTab(this.selectedNIS, this.token, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncFacturas = ref.watch(facturasProvider);
    final horizontalTitles = ['Deuda Total', 'Deuda Anterior'];

    return Column(
      children: [
        const SizedBox(height: 10),
        HorizontalCards(titles: horizontalTitles),
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
                      "Comprobantes",
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
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: CardItemSecond(
                            monto: factura.importe.toString(),
                            estadoPago: factura.estadoFactura ?? '',
                            estadoColor: factura.esPagado == true
                                ? Colors.green
                                : Colors.red,
                            fechaEmision: factura.fechaEmision ?? 'Sin dato',
                            fechaVencimiento:
                                factura.fechaVencimiento ?? 'Sin dato',
                            onVerFacturaPressed: () {
                              print(
                                '🧾 Ver factura ${factura.fechaFacturacion}',
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Error: $error')),
          ),
        ),
      ],
    );
  }
}
