import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/infrastructure/infrastructure.dart';
import 'package:form/model/mi_cuenta/mi_cuenta_situacion_actual_model.dart';
import 'package:form/presentation/components/common/UI/custom_card.dart';
import 'package:form/presentation/components/common/UI/custom_comment.dart';
import 'package:form/provider/situacion_actual_provider.dart';
import 'package:form/provider/suministro_provider.dart';
import 'package:form/repositories/repositories.dart';

class LecturaTab extends ConsumerStatefulWidget {
  const LecturaTab({super.key});

  @override
  ConsumerState<LecturaTab> createState() => _LecturaTabState();
}

class _LecturaTabState extends ConsumerState<LecturaTab> {
  String? errorMessage;
  SituacionActualResultado? _situacionActualResultado;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _consultar() async {}

  @override
  Widget build(BuildContext context) {
    final situacionAsync = ref.watch(situacionActualProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: situacionAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
        
          error: (error, stack) => CustomComment(text: error.toString()),
        
          data: (situacion) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomComment(
                text: "Ingrese los datos del NIS y lectura de medidor",
              ),
        
              CustomCard(
                child: Text(situacion.habilitarAporteLectura?.mensaje)),
        
              const SizedBox(height: 16),
        
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _consultar,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Consultar'),
                ),
              ),
            ],
          ),
        
          /* Column(
          children: [
            CustomComment(text: "Ingrese los datos del NIS y lectuta de medidor"),
            CustomComment(
              text: _situacionActualResultado?.habilitarAporteLectura?.mensaje,
            ),
            OutlinedButton(onPressed: () {}, child: Text("Consultar")),
          ],
        ),*/
        ),
      ),
    );
  }
}
