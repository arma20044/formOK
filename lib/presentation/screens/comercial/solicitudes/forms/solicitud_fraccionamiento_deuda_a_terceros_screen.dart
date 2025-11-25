import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/config/constantes.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/router/app_router.dart';
import 'package:form/infrastructure/infrastructure.dart';
import 'package:form/model/login_model.dart';
import 'package:form/model/model.dart';
import 'package:form/presentation/components/common.dart';
import 'package:form/presentation/components/common/UI/custom_card.dart';
import 'package:form/presentation/components/common/UI/custom_title.dart';
import 'package:form/presentation/components/common/custom_show_dialog.dart';
import 'package:form/presentation/components/common/custom_snackbar.dart';
import 'package:form/presentation/components/common/custom_text_with_children.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:form/repositories/repositories.dart';
import 'package:form/utils/utils.dart';

class SolicitudFraccionamientoDeudaATercerosScreen
    extends ConsumerStatefulWidget {
  const SolicitudFraccionamientoDeudaATercerosScreen({super.key});

  @override
  ConsumerState<SolicitudFraccionamientoDeudaATercerosScreen> createState() =>
      _SolicitudFraccionamientoDeudaATercerosScreenState();
}

class _SolicitudFraccionamientoDeudaATercerosScreenState
    extends ConsumerState<SolicitudFraccionamientoDeudaATercerosScreen> {
  final nisController = TextEditingController();
  final entregaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoadingConsultar = false;
  bool _isLoadingSimular = false;
  bool _isLoadingSolicitar = false;

  //SuministrosList? selectedNIS;
  int? selectedCuota;

  SolicitudFraccionamientoResponse? solicitudFraccionamientoResponse;

  List<int> dropDownCantidadCuotas = List.generate(12, (i) => i + 1);

  bool mostrarErrorSimular = false;
  String mensajeError = "";

  bool mostrarConsultar = false;
  bool mostrarSimular = false;

  void enviarFormulario(bool simular) async {
    if (_isLoadingConsultar) return;

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese los campos obligatorios')),
      );
      return;
    }

    setState(() => _isLoadingConsultar = true);
    try {
      final result = await _fetchSolicitudFraccionamiento(
        nisController.text,
        simular,
      );

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

        if (simular) {
          entregaController.text =
              solicitudFraccionamientoResponse?.resultado?.entrega.toString() ??
              "0";

          mostrarSimular = true;
        } else {
          entregaController.text =
              solicitudFraccionamientoResponse?.resultado?.entrega.toString() ??
              "0";
          "";

          selectedCuota = dropDownCantidadCuotas.last;
        }
        mostrarConsultar = true;
        
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

      setState(() {
        mostrarErrorSimular = false;
      });
    } catch (e) {
      String errorMsg = 'Error desconocido.';
      if (e is DioException) {
        errorMsg = e.error.toString();
        //e.response?.data?['errorValList'][0]?.toString() ??
        //e.message ??
        //errorMsg;
      } else if (e is Error) {
        errorMsg = e.toString();
      }
      // DialogHelper.showMessage(context, MessageType.error, 'Error', errorMsg);
      setState(() {

if(simular == false){
   mostrarConsultar = false;
}

        mostrarErrorSimular = true;
        mensajeError = errorMsg.contains("tokenerror")
            ? "Su sesión ha expirado."
            : errorMsg;
      });

      if (mensajeError.contains("expirad")) {
        ref.read(authProvider.notifier).logoutForzado();

        // Obtener ubicación real
        final router = ref.read(goRouterProvider);
        final currentLocation = router.routeInformationProvider.value.uri
            .toString();

        // Evitar bucle si ya estás en login
        if (!currentLocation.startsWith('/login')) {
          router.go('/login');
        }
      }
    } finally {
      setState(() => _isLoadingConsultar = false);
    }
  }

  Future<SolicitudFraccionamientoResponse> _fetchSolicitudFraccionamiento(
    nis,
    bool simular,
  ) async {
    final authState = ref.watch(authProvider);
    final token = authState.value?.user?.token;

    final repo = SolicitudFraccionamientoRepositoryImpl(
      SolicitudFraccionamientoDatasourceImp(MiAndeApi()),
    );
    return await repo.getSolicitudFraccionamiento(
      nis,
      "N",
      simular ? selectedCuota.toString() : "6",
      simular ? entregaController.text : "0",
      "0",
      "1",
      "1",
      simular ? 'S' : 'N',
      token!,
    );
  }

  Widget mostrarResultadoConsulta() {
    _formKey.currentState!.save();
    //selectedCuota= dropDownCantidadCuotas.first;

    return Column(
      children: [
        CustomCard(
          child: CustomTitle(
            size: 'large',
            text:
                "NIS: ${nisController.text ?? 'sin datos'} - ${solicitudFraccionamientoResponse?.resultado?.nombreApellido ?? "sin datos"}",
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: CustomCard(
            child: CustomText(
              "Deuda Total Gs.:${formatMiles(solicitudFraccionamientoResponse?.resultado?.deuda ?? 0)}",
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: entregaController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Monto de Entrega'),
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Ingrese NIS' : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField<int>(
            initialValue: selectedCuota,
            hint: const Text("Seleccionar Cantidad de cuotas"),
            items: (dropDownCantidadCuotas ?? [])
                .map(
                  (item) => DropdownMenuItem<int>(
                    value: item,
                    child: Text(item.toString()),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() => selectedCuota = value);
            },
            validator: (value) =>
                value == null ? 'Seleccione Cantidad de Cuotas' : null,
          ),
        ),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoadingSimular ? null : () => enviarFormulario(true),
            child: _isLoadingSimular
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text("Presionar para Simular"),
          ),
        ),

        mostrarErrorSimular
            ? CustomCard(
                title: "Atención",
                titleColor: Colors.red,
                child: CustomText(mensajeError, overflow: TextOverflow.clip),
                borderColor: Colors.red,
              )
            : Text(""),
        //CustomCard(child: CustomText(solicitudFraccionamientoResponse?.resultado?.deuda ?? "no hay datos").toString())
      ],
    );
  }

  Widget mostrarResultadoSimular() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch, // hijos ocupan todo el ancho disponible
      children: [
        // Card con la información
        CustomCard(
          child: Padding(
            padding: const EdgeInsets.all(
              16.0,
            ), // padding interno para que no toque los bordes
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextWithChildren(
                  children: [
                    TextSpan(text: "Deuda Total Gs.:  "),
                    TextSpan(
                      text: formatMiles(
                        solicitudFraccionamientoResponse?.resultado?.deuda,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CustomTextWithChildren(
                  children: [
                    TextSpan(text: "Monto Entrega Gs.:  "),
                    TextSpan(
                      text: formatMiles(
                        solicitudFraccionamientoResponse?.resultado?.entrega,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CustomTextWithChildren(
                  children: [
                    TextSpan(text: "Cantidad de Cuotas:  "),
                    TextSpan(
                      text: formatMiles(
                        solicitudFraccionamientoResponse
                            ?.resultado
                            ?.cantidadCuotas,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CustomTextWithChildren(
                  children: [
                    TextSpan(text: "Monto Cuota Gs.: "),
                    TextSpan(
                      text: formatMiles(
                        solicitudFraccionamientoResponse?.resultado?.cuotas,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CustomTextWithChildren(
                  children: [
                    TextSpan(text: "Recargo por mora Gs.: "),
                    TextSpan(
                      text: formatMiles(
                        solicitudFraccionamientoResponse?.resultado?.multas,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16), // separación entre card y botón
        // Botón alineado al ancho del card
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ), // mismo padding que el card
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoadingSimular ? null : () => solicitar(false),
              child: _isLoadingSimular
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Solicitar"),
            ),
          ),
        ),
      ],
    );
  }

  Future<SolicitarFraccionamientoResponse> _fetchSolicitarFraccionamiento(
    bool solicitarOTP,
  ) async {
    final authState = ref.read(authProvider);
    final token = authState.value?.user?.token;

    final repo = SolicitarFraccionamientoDeudaRepositoryImpl(
      SolicitarFraccionamientoDatasourceImp(MiAndeApi()),
    );
    return await repo.getSolicitarFraccionamientoDeuda(
      nisController.text,
      solicitarOTP ? 'S' : 'N',
      solicitudFraccionamientoResponse?.toJson().toString() ?? "sin datos",
      token!,
      'N',
    );
  }

  Future<void> solicitar(bool solicitarOTP) async {
    _formKey.currentState!.save();

    if (_isLoadingSolicitar) return;

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese los campos obligatorios')),
      );
      return;
    }

    setState(() => _isLoadingSolicitar = true);

    try {
      final result = await _fetchSolicitarFraccionamiento(solicitarOTP);

      if (result.error!) {
        DialogHelper.showMessage(
          context,
          MessageType.error,
          'Error',
          result.errorValList?.first ?? 'Error desconocido',
        );
        return;
      }

      setState(() {});

      CustomSnackbar.show(
        context,
        message: result.mensaje!,
        type: MessageType.success,
      );
      Navigator.of(context).pop();
    } catch (e) {
    } finally {
      setState(() => _isLoadingSolicitar = false);
    }
  }

  List<SuministrosList?>? dropDownItemsSuministro;

  late final tipoCliente;

  @override
  void initState() {
    super.initState();

    final authState = ref.read(authProvider);

    tipoCliente = authState.value?.user?.tipoCliente;

    dropDownItemsSuministro = authState.value?.user?.userDatosAnexos;

    if (dropDownItemsSuministro != null &&
        dropDownItemsSuministro!.isNotEmpty) {
      //selectedNIS = dropDownItemsSuministro![0]; // valor inicial
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fraccionamiento a Terceros")),
      endDrawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Form(
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
                  maxLength: 7,
                  decoration: const InputDecoration(labelText: 'NIS'),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Ingrese NIS' : null,
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoadingConsultar
                        ? null
                        : () => enviarFormulario(false),
                    child: _isLoadingConsultar
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text("Consultar"),
                  ),
                ),

                if (solicitudFraccionamientoResponse != null &&
                    solicitudFraccionamientoResponse?.error != true &&
                    mostrarConsultar)
                  mostrarResultadoConsulta(),

                if (mostrarSimular) mostrarResultadoSimular(),

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
      ),
    );
  }
}
