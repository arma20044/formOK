import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/presentation/components/common/UI/custom_loading.dart';
import 'package:form/provider/historico_consumo_monto_provider.dart';

class HistoricoTab extends ConsumerStatefulWidget {
  const HistoricoTab({super.key});

  @override
  ConsumerState<HistoricoTab> createState() => _HistoricoTabState();
}

class _HistoricoTabState extends ConsumerState<HistoricoTab> {
  @override
  Widget build(BuildContext context) {
    final asyncHistoricoConsumoMontoDatos = ref.watch(historicoConsumoMontoProvider);

    return asyncHistoricoConsumoMontoDatos.when(
        data: (historico) {
          if ( historico.error ) {
            return  Center(child: Text("No hay datos disponibles"));
          }

          return Column(children: [
            Text(historico.resultado.id)
          ]);
        },
        loading: () => const CustomLoading(text: "Cargando..."),
        error: (error, _) => Center(child: Text('Error: $error')),
      
    );
    //return
    //Text("historico tab");
  }
}
