import 'package:flutter/material.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/infrastructure/mi_cuenta/mi_cuenta_ultimas_facturas_datasource_impl.dart';
import 'package:form/model/consulta_facturas.dart';
import 'package:form/model/mi_cuenta/mi_cuenta_ultimas_facturas_model.dart';
import 'package:form/presentation/components/common/card_item_second.dart';
import 'package:form/presentation/components/common/horizontal_cards.dart';
import 'package:form/repositories/repositories.dart';
import '../../../../../model/login_model.dart';

class FacturasTab extends StatefulWidget {
  const FacturasTab({super.key, this.selectedNIS, this.token});

  final SuministrosList? selectedNIS;
  final String? token;

  @override
  State<FacturasTab> createState() => _FacturasTabState();
}

class _FacturasTabState extends State<FacturasTab> {
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
    final horizontalTitles = ['Deuda Total', 'Deuda Anterior'];

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),
          HorizontalCards(titles: horizontalTitles),
          const SizedBox(height: 16),

          // ✅ Contenido dinámico
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                ? Center(child: Text(_errorMessage!))
                : _facturas.isEmpty
                ? const Center(child: Text("No hay facturas disponibles"))
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _facturas.length,
                    itemBuilder: (context, index) {
                      final factura = _facturas[index];
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
                  ),
          ),
        ],
      ),
    );
  }
}
