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



class FacturasTab extends ConsumerStatefulWidget  {
  const FacturasTab({super.key, this.selectedNIS, this.token});

  final SuministrosList? selectedNIS;
  final String? token;

  @override
  ConsumerState<FacturasTab> createState() => _FacturasTabState();
}



/// Provider que obtiene las facturas del NIS actual
final facturasProvider = FutureProvider.autoDispose<List<MiCuentaUltimasFacturasLista>>((ref) async {
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

class _FacturasTabState extends ConsumerState<FacturasTab> {
  final repoMiCuentaUltimasFacturas = MiCuentaUltimasFacturasRepositoryImpl(
    MiCuentaUltimasFacturasDatasourceImpl(MiAndeApi()),
  );

  List<MiCuentaUltimasFacturasLista> _facturas = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    consultarUltimasFacturas();
  }

  void consultarUltimasFacturas() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final ultimasFacturasResponse = await repoMiCuentaUltimasFacturas
          .getMiCuentaUltimasFacturas(
            widget.selectedNIS!.nisRad!.toString(),
            "15",
            widget.token!,
          );

      if (!mounted) return;

      if (ultimasFacturasResponse.error!) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ultimasFacturasResponse.errorValList![0])),
        );
        return;
      }

      final data = ultimasFacturasResponse.micuentaultimasfacturasresultado;

      // ✅ Convertimos y filtramos nulos
      final facturas = (data?.lista ?? [])
          .whereType<
            MiCuentaUltimasFacturasLista
          >() // elimina nulls automáticamente
          .toList();

      setState(() {
        _facturas = facturas;
      });
    } catch (e) {
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncFacturas = ref.watch(facturasProvider);
    final horizontalTitles = ['Deuda Total', 'Deuda Anterior'];

    return Scaffold(
      body: Column(
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
                return ListView.builder(
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
                          print('🧾 Ver factura ${factura.fechaFacturacion}');
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ),
         ],
      ),
    );
  }
}
