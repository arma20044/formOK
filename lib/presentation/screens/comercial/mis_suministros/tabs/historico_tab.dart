import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/api/mi_ande_api.dart';

import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/infrastructure/infrastructure.dart';
import 'package:form/provider/recuperar_historico_by_id_provider.dart';
import 'package:form/provider/suministro_provider.dart';
import 'package:form/repositories/repositories.dart';
import '../../../../components/comercial/grafico_consumo_horizontal.dart';

class HistoricoTab extends ConsumerStatefulWidget {
  const HistoricoTab({super.key});

  @override
  ConsumerState<HistoricoTab> createState() => _HistoricoTabState();
}

class _HistoricoTabState extends ConsumerState<HistoricoTab> {
  String? idHistorico;
  String? errorMessage;
  late Future futureHistorico;

  @override
  void initState() {
    super.initState();
    _cargarID();
  }

  Future<void> _cargarID() async {
    try {
      final authState = ref.read(authProvider);
      final token = authState.value?.user?.token ?? "";
      final nis = ref.read(selectedNISProvider);

      if (nis == null) {
        setState(() => errorMessage = "No se encontró el NIS seleccionado.");
        return;
      }

      final repo = HistoricoConsumoMontoRepositoryImpl(
        HistoricoConsumoMontoDatasourceImpl(MiAndeApi()),
      );

      final response = await repo.getHistoricoConsumoMonto(
        nis.nisRad.toString(),
        "N",
        token,
      );

      if (response.error) {
        setState(() {
          errorMessage =
              response.errorValList?.first ?? response.mensaje ?? "Error desconocido";
        });
        return;
      }

      final id = response.resultado.id;

      setState(() {
        idHistorico = id;
        futureHistorico = ref.read(recuperarHistoricoProvider(id).future);
      });

    } catch (e) {
      // Aquí capturamos cualquier error, incluido el mensaje que venga limpio del provider
      setState(() => errorMessage = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      return Center(
        child: Text(
          errorMessage!,
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    if (idHistorico == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return FutureBuilder(
      future: futureHistorico,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          // 🔹 Mostramos directamente el mensaje limpio que venga del provider/interceptor
          /*return Center(
            child: Text(
              snapshot.error.toString(),
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );*/

            return Text(
              snapshot.error.toString(),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            );
        }

        final data = snapshot.data!;

        return SingleChildScrollView(
          child: Column(
            children: [
              HorizontalComparativaChart(
                facturas: data.resultado.lista,
                mostrarConsumo: true,
                anioActual: DateTime.now().year,
              ),
              HorizontalComparativaChart(
                facturas: data.resultado.lista,
                mostrarConsumo: false,
                anioActual: DateTime.now().year,
              ),
            ],
          ),
        );
      },
    );
  }
}
