import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/config/constantes.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/infrastructure/infrastructure.dart';
import 'package:form/model/consulta_facturas.dart';
import 'package:form/model/mi_cuenta/mi_cuenta_situacion_actual_model.dart';
import 'package:form/presentation/components/common.dart';
import 'package:form/presentation/components/common/UI/custom_card.dart';
import 'package:form/presentation/components/common/UI/custom_comment.dart';
import 'package:form/presentation/components/common/custom_bottom_sheet_image.dart';
import 'package:form/presentation/components/common/custom_snackbar.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:form/repositories/repositories.dart';

class SolicitudYoFacturoMiLuz extends ConsumerStatefulWidget {
  const SolicitudYoFacturoMiLuz({super.key});

  @override
  ConsumerState<SolicitudYoFacturoMiLuz> createState() =>
      _SolicitudYoFacturoMiLuzState();
}

class _SolicitudYoFacturoMiLuzState
    extends ConsumerState<SolicitudYoFacturoMiLuz> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nisController = TextEditingController();
  final TextEditingController _lecturaActualController =
      TextEditingController();
  bool isLoading = false;

  SituacionActualResultado?
  situacionActualResultado; // <-- aquí guardamos los resultados
  DatosCliente? datosCliente;

  Future<void> _consultar() async {
    if (!_formKey.currentState!.validate()) return;

    final nis = _nisController.text;
    final authState = ref.read(authProvider);
    final token = authState.value?.user?.token;

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Su sesión ha expirado, debe volver a logearse'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final repoConsultaSituacionActual = MiCuentaSituacionActualRepositoryImpl(
        MiCuentaSituacionActualDatasourceImpl(MiAndeApi()),
      );

      final consultaSituacionActualResponse = await repoConsultaSituacionActual
          .getMiCuentaSituacionActual(nis, token);

      if (consultaSituacionActualResponse.error == true) {
        /*ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Favor intente nuevamente la consulta"),
          ),
        );*/
        CustomSnackbar.show(
          context,
          message: "Ocurrió un error, Favor intente nuevamente la consulta",
          type: MessageType.error,
        );

        setState(() {
          //  facturas = [];
          isLoading = false;
        });
        return;
      }

      setState(() {
        situacionActualResultado = consultaSituacionActualResponse.resultado;
        //datosCliente = consultaFacturasResponse.resultado?.datosCliente;
        // print(datosCliente);
        isLoading = false;
      });

      showModalBottomSheet(
        isDismissible: false,
        context: context, // Contexto de la pantalla actual
        isScrollControlled: true, // Permite que ocupe más espacio (ej. 80%)
        backgroundColor:
            Colors.transparent, // Fondo transparente para bordes redondeados
        builder: (_) =>
            const ImageBottomSheet(assetPath: 'assets/images/yofacturo.png'),
      );

      /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Consultando NIS: $nis')),
      );*/
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Widget mostrarResultadoConsulta() {
    return situacionActualResultado != null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                "NIS: ${_nisController.text} - ${situacionActualResultado!.nombre} ${situacionActualResultado!.apellido}",
                fontWeight: FontWeight.bold,
                fontSize: 18,
                overflow: TextOverflow.clip,
              ),
              CustomText(
                "Fecha aprohimada de Próxima Lectura: ${situacionActualResultado!.lecturaTeorica}",
              ),

              CustomCard(
                child: Column(
                  children: [
                    CustomText(
                      "Marca del Medidor: ${situacionActualResultado!.marcaAparato}",
                    ),
                    CustomText(
                      "Número del Medidor: ${situacionActualResultado!.numeroAparato}",
                    ),

                    if (situacionActualResultado!.facturaDatos!.tipoTension!
                        .contains("BT"))
                      CustomText(
                        "Última lectura: ${situacionActualResultado!.calculoConsumo!.leturaAnterior}",
                      ),

                    //if(situacionActualResultado!.facturaDatos!.tipoTension!.contains("MT"))
                    //falta MT
                    CustomText(
                      "Última fecha de lectura: ${situacionActualResultado!.calculoConsumo!.ultimaFechaLectura}",
                    ),
                    CustomText(
                      "Días de consumo desde la última lectura: ${situacionActualResultado!.calculoConsumo!.cantidadDias}",
                    ),
                  ],
                ),
              ),

              CustomComment(
                text:
                    "Antes de ingresar su lectura, por favor vea el video demostrativo de como leer su medidor",
                bold: true,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _lecturaActualController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Lectura Actual del Medidor',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _consultar,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Presionar para Calcular Consumo'),
                ),
              ),
            ],
          )
        : Text("");
  }

  Widget mostrarResultadoCalularConsumo() {
    return Text("resultado Calcular Consumo");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Yo Facturo Mi Luz")),
      endDrawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomComment(
                  text: "Ingrese los datos del NIS y lectura de Medidor.",
                ),
                const SizedBox(height: 10),
                TextFormField(
                  maxLength: 7,
                  controller: _nisController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'NIS',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _consultar,
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Consultar'),
                  ),
                ),

                mostrarResultadoConsulta(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
