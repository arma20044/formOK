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

  @override
  void initState() {
    super.initState();
    _cargarID();
  }

  Future<void> _cargarID() async {
    final authState = ref.read(authProvider);
    final token = authState.value?.user?.token ?? "";

    final nis = ref.read(selectedNISProvider);

    if (nis == null) {
      // manejar error
      return;
    }

    final repo = HistoricoConsumoMontoRepositoryImpl(
      HistoricoConsumoMontoDatasourceImpl(MiAndeApi()),
    );

    final response = await repo.getHistoricoConsumoMonto(
      nis.nisRad!.toString(),
      "N",
      token,
    );

    if (response.error) {
      // manejar error
      return;
    }

    setState(() {
      idHistorico = response.resultado.id; // guardar ID
    });
  }

  @override
  Widget build(BuildContext context) {
    if (idHistorico == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final asyncHistorico = ref.watch(recuperarHistoricoProvider(idHistorico!));

    return asyncHistorico.when(
      //data: (data) => Text('Datos cargados: ${data.resultado.lista[0]}'),
      data: (data) =>  SingleChildScrollView(
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
      ),
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text('Error: $e'),
    );
  }
}
