import 'package:flutter/material.dart';
import 'package:form/model/comercial/factura_grafico.dart';
import 'package:form/model/model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class HorizontalComparativaChart extends StatelessWidget {
  final List<ListaRecuperarHistorico> facturas;
  final bool mostrarConsumo; // true = consumo, false = importe
  final int anioActual;

  const HorizontalComparativaChart({
    super.key,
    required this.facturas,
    this.mostrarConsumo = true,
    required this.anioActual,
  });

  @override
  Widget build(BuildContext context) {
    if (facturas.isEmpty) return const Center(child: Text("No hay datos"));

    // Lista de meses fijos
    final meses = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];

    // Mapear datos a meses y años
    Map<String, num> consumoActual = {for (var m in meses) m: 0};
    Map<String, num> consumoAnterior = {for (var m in meses) m: 0};

    for (var f in facturas) {
      if (f.fechaFacturacionMask != null) {
        final parts = f.fechaFacturacionMask!.split('/');
        if (parts.length == 2) {
          final mesIndex = int.tryParse(parts[0]) ?? 1;
          final anio = int.tryParse(parts[1]) ?? anioActual;
          final mesNombre = meses[mesIndex - 1];

          final valor = mostrarConsumo ? (f.consumoFacturado ?? 0) : (f.importeFacturado ?? 0)/1000;

          if (anio == anioActual) {
            consumoActual[mesNombre] = valor;
          } else if (anio == anioActual - 1) {
            consumoAnterior[mesNombre] = valor;
          }
        }
      }
    }

    // Convertir a listas para chart
    final listaActual = meses
        .map((m) => ListaFacturaGrafico(fechaFacturacionMask: m, consumoFacturado: consumoActual[m], importeFacturado: consumoActual[m]))
        .toList();

    final listaAnterior = meses
        .map((m) => ListaFacturaGrafico(fechaFacturacionMask: m, consumoFacturado: consumoAnterior[m], importeFacturado: consumoAnterior[m]))
        .toList();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              mostrarConsumo
                  ? "Consumo facturado"
                  : "Importe facturado (en miles)",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 400,
              child: SfCartesianChart(
                legend: Legend(isVisible: true),
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(
                      text: mostrarConsumo ? 'Consumo (kW/h)' : 'Importe (Guaraníes)'),
                ),
                series: <CartesianSeries<ListaFacturaGrafico, String>>[
                  // Año actual
                  BarSeries<ListaFacturaGrafico, String>(
                    name: 'Año $anioActual',
                    dataSource: listaActual,
                    xValueMapper: (ListaFacturaGrafico f, _) => f.fechaFacturacionMask ?? '',
                    yValueMapper: (ListaFacturaGrafico f, _) => f.importeFacturado ?? 0,
                    gradient: const LinearGradient(
                        colors: [Colors.blueAccent, Colors.blue]),
                    spacing: 0.2,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  // Año anterior
                  BarSeries<ListaFacturaGrafico, String>(
                    name: 'Año ${anioActual - 1}',
                    dataSource: listaAnterior,
                    xValueMapper: (ListaFacturaGrafico f, _) => f.fechaFacturacionMask ?? '',
                    yValueMapper: (ListaFacturaGrafico f, _) => f.importeFacturado ?? 0,
                    gradient: const LinearGradient(
                        colors: [Colors.red, Colors.redAccent]),
                    spacing: 0.2,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  
                ],
                isTransposed: false, // horizontal
              ),
            ),
          ],
        ),
      ),
    );
  }
}
