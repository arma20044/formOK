import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/config/constantes.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/infrastructure/infrastructure.dart';
import 'package:form/model/model.dart';
import 'package:form/presentation/components/common.dart';
import 'package:form/presentation/components/common/UI/custom_card.dart';
import 'package:form/presentation/components/common/custom_show_dialog.dart';
import 'package:form/presentation/components/common/custom_snackbar.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:form/repositories/repositories.dart';
import 'package:form/utils/utils.dart';

class SolicitudFraccionamientoDeudaScreen extends ConsumerStatefulWidget {
  const SolicitudFraccionamientoDeudaScreen({super.key});

  @override
  ConsumerState<SolicitudFraccionamientoDeudaScreen> createState() =>
      _SolicitudFraccionamientoDeudaScreenState();
}

class _SolicitudFraccionamientoDeudaScreenState
    extends ConsumerState<SolicitudFraccionamientoDeudaScreen> {
  final nisController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoadingSolicitud = false;

SolicitudFraccionamientoResponse? solicitudFraccionamientoResponse;




  void enviarFormulario() async {
    if (_isLoadingSolicitud) return;

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese los campos obligatorios')),
      );
      return;
    }

    setState(() => _isLoadingSolicitud = true);
    try {
      final result = await _fetchSolicitudFraccionamiento(nisController.text);

      if (result.error!) {
        DialogHelper.showMessage(
          context,
          MessageType.error,
          'Error',
          result.errorValList?.first ?? 'Error desconocido',
        );
        return;
      }

      setState(() {
        solicitudFraccionamientoResponse = result;
      });

      /*DialogHelper.showMessage(
        context,
        MessageType.success,
        'Éxito',
        result.resultado!.consumoPromedio.toString(),
      );*/
      CustomSnackbar.show(
        context,
        message: "Simulacion Correcta.",
        type: MessageType.success,
      );
    } catch (e) {
      DialogHelper.showMessage(
        context,
        MessageType.error,
        'Error',
        'Ocurrió un error inesperado',
      );
    } finally {
      setState(() => _isLoadingSolicitud = false);
    }
  }

  Future<SolicitudFraccionamientoResponse> _fetchSolicitudFraccionamiento(nis) async {
 final authState = ref.watch(authProvider);
  final token = authState.value?.user?.token;


    final repo = SolicitudFraccionamientoRepositoryImpl(
      SolicitudFraccionamientoDatasourceImp(MiAndeApi()),
    );
    return await repo.getSolicitudFraccionamiento(nis,"N","6","0","0","1","1","N",token!);
  }


  Widget mostrarResultadoConsulta() {

  return Column(children: [
    CustomCard(child: CustomText("Deuda Total Gs.:${formatMiles(solicitudFraccionamientoResponse?.resultado?.deuda ?? 0)}"))
    //CustomCard(child: CustomText(solicitudFraccionamientoResponse?.resultado?.deuda ?? "no hay datos").toString())
  ],);

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fraccionamiento de Deuda")),
      endDrawer: CustomDrawer(),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 24),

              TextFormField(
                controller: nisController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'NIS'),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Ingrese NIS' : null,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoadingSolicitud
                      ? null
                      : () => enviarFormulario(),
                  child: _isLoadingSolicitud
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Simular"),
                ),
              ),

              if(solicitudFraccionamientoResponse != null)
              mostrarResultadoConsulta(),

              CustomCard(
                title: 'INFORMACIÓN PARA EL FRACCIONAMIENTO ELECTRÓNICO',
                titleSize: "medium",
                child: Column(
                  children: [
                    CustomText(
                      "• Una vez procesada la Solicitud de fraccionamiento, la misma será comunicada al cliente vía mensaje de texto o correo electrónico, y podrá descargar su factura de la primera cuota (entrega) desde la WEB Institucional.\n",
                      overflow: TextOverflow.clip,
                    ),
                    CustomText(
                      "• La solicitud de fraccionamiento se finiquitará con el pago de la entrega inicial de la deuda financiada, pago equivalente a la primera cuota.\n",
                      overflow: TextOverflow.clip,
                    ),
                    CustomText(
                      "• El pago deberá ejecutarse en un plazo de 72 horas desde la fecha de la solicitud. Fenecido el plazo sin comprobarse el pago proceso comercial de interrupción del servicio por falta de pago seguirá su curso normal.\n",
                      overflow: TextOverflow.clip,
                    ),
                    CustomText(
                      "• La falta de pago de una cuota del fraccionamiento, autoriza a la ANDE a la interrupción del servicio, sin necesidad de aviso previo.\n",
                      overflow: TextOverflow.clip,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




