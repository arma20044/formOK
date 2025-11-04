import 'package:flutter/material.dart';
import 'package:form/model/comercial/factura_grafico.dart';
import 'package:form/presentation/components/comercial/grafico_consumo_horizontal.dart';





void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Ejemplo de datos
    final facturas =       [
        ListaFacturaGrafico(
          consumoFacturado: 327,
          fechaFacturacion: "2025-08-25T00:00:00.000Z",
          fechaFacturacionMask: "08/2025",
          importeFacturado: 161000,
          nisRad: 1408187,
        ),
        ListaFacturaGrafico(
          consumoFacturado: 527,
          fechaFacturacion: "2024-08-25T00:00:00.000Z",
          fechaFacturacionMask: "08/2024",
          importeFacturado: 561000,
          nisRad: 1408187,
        ),
        ListaFacturaGrafico(
          fechaFacturacion: "2025-07-26T00:00:00.000Z",
          fechaFacturacionMask: "07/2025",
          consumoFacturado: 369,
          importeFacturado: 35000,
          nisRad: 1408187,
        ),
        ListaFacturaGrafico(
          fechaFacturacion: "2025-06-25T00:00:00.000Z",
          fechaFacturacionMask: "06/2025",
          consumoFacturado: 362,
          importeFacturado: 177000,
          nisRad: 1408187,
        ),
        ListaFacturaGrafico(
          fechaFacturacion: "2025-05-26T00:00:00.000Z",
          fechaFacturacionMask: "05/2025",
          consumoFacturado: 355,
          importeFacturado: 163000,
          nisRad: 1408187,
        ),
        ListaFacturaGrafico(
          consumoFacturado: 327,
          fechaFacturacion: "2025-08-25T00:00:00.000Z",
          fechaFacturacionMask: "08/2025",
          importeFacturado: 161000,
          nisRad: 1408187,
        ),
        ListaFacturaGrafico(
          consumoFacturado: 327,
          fechaFacturacion: "2025-08-25T00:00:00.000Z",
          fechaFacturacionMask: "08/2025",
          importeFacturado: 161000,
          nisRad: 1408187,
        ),
      ];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Gráfico 3D")),
        //body: Barra3DGrafico(facturas: facturas), // ✅ Usando el componente
        body: SingleChildScrollView(
          child: Column(children: [
            //BarraComparativaPorAnho(facturas: facturas, anioActual: 2025),
            //BarraComparativaPorAnho(facturas: facturas, anioActual: 2025, mostrarConsumo: false,)
          
    HorizontalComparativaChart(
      facturas: facturas,
      mostrarConsumo: true,
      anioActual: DateTime.now().year,
    ),
    HorizontalComparativaChart(
      facturas: facturas,
      mostrarConsumo: false,
      anioActual: DateTime.now().year,
   
)

          ],),
        ),
      ),
    );
  }
}
