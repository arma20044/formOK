import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/config/constantes.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/infrastructure/comercial/solicitudes/calculo_consumo_datasource_imp.dart';
import 'package:form/infrastructure/infrastructure.dart';
import 'package:form/model/model.dart';
import 'package:form/presentation/components/common.dart';
import 'package:form/presentation/components/common/UI/custom_card.dart';
import 'package:form/presentation/components/common/UI/custom_comment.dart';
import 'package:form/presentation/components/common/adjuntos.dart';
import 'package:form/presentation/components/common/custom_bottom_sheet_image.dart';
import 'package:form/presentation/components/common/custom_snackbar.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:form/presentation/components/youtube_webview.dart';
import 'package:form/repositories/repositories.dart';
import 'package:form/utils/utils.dart';

class SolicitudYoFacturoMiLuz extends ConsumerStatefulWidget {
  const SolicitudYoFacturoMiLuz({super.key});

  @override
  ConsumerState<SolicitudYoFacturoMiLuz> createState() =>
      _SolicitudYoFacturoMiLuzState();
}

class _SolicitudYoFacturoMiLuzState
    extends ConsumerState<SolicitudYoFacturoMiLuz> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyCalculoConsumo = GlobalKey<FormState>();
  final _formKeyConfirmarLectura = GlobalKey<FormState>();

  final TextEditingController _nisController = TextEditingController();
  final TextEditingController _lecturaActualController =
      TextEditingController();

  final TextEditingController telefonoController = TextEditingController();

  bool isLoading = false;
  bool isLoadingCalcularConsumo = false;
  bool isLoadingConfirmarLectura = false;

  SituacionActualResultado?
  situacionActualResultado; // <-- aquí guardamos los resultados
  ResultadoCalculoConsumo? calculoConsumoResultado;
  DatosCliente? datosCliente;

  ArchivoAdjunto? _archivoSeleccionado1;

  Future<void> _consultar() async {
    _formKey.currentState!.save();
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

        calculoConsumoResultado = null;
        _lecturaActualController.text = "";
      });


      if(consultaSituacionActualResponse.resultado?.habilitarAporteLectura?.habilitado == 'S') {
        showModalBottomSheet(
        isDismissible: false,
        context: context, // Contexto de la pantalla actual
        isScrollControlled: true, // Permite que ocupe más espacio (ej. 80%)
        backgroundColor:
            Colors.transparent, // Fondo transparente para bordes redondeados
        builder: (_) =>
            const ImageBottomSheet(assetPath: 'assets/images/yofacturo.png'),
      );
      }

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

  Future<void> _confirmarLectura() async {
    if (!_formKeyConfirmarLectura.currentState!.validate()) {
      return;
    }

    if (_archivoSeleccionado1 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Es necesario anexar foto o video.")),
      );
      return;
    }
  }

  Future<void> _calcularConsumo() async {
    if (!_formKeyCalculoConsumo.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoadingCalcularConsumo = true;
    });
    try {
      final repoConsultaCalculoConsumo = CalculoConsumoRepositoryImpl(
        CalculoConsumoDatasourceImp(MiAndeApi()),
      );

      final consultaCalculoConsumoResponse = await repoConsultaCalculoConsumo
          .getCalculoConsumo(
            _nisController.text,
            _lecturaActualController.text,
          );

      if (consultaCalculoConsumoResponse.error == true) {
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
          calculoConsumoResultado = null;
        });
        return;
      }

      setState(() {
        calculoConsumoResultado = consultaCalculoConsumoResponse.resultado;
        //datosCliente = consultaFacturasResponse.resultado?.datosCliente;
        // print(datosCliente);
        isLoading = false;
      });

      /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Consultando NIS: $nis')),
      );*/
    } catch (e) {
      setState(() {
        calculoConsumoResultado = null;
      });

      CustomSnackbar.show(
        context,
        message: "Error: $e",
        type: MessageType.error,
        //duration: Durations.long4,
      );
    } finally {
      setState(() {
        isLoadingCalcularConsumo = false;
      });
    }
  }

  Widget mostrarLecturaNOHabilitada() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CustomText(
            "NIS: ${_nisController.text} - ${situacionActualResultado!.nombre} ${situacionActualResultado!.apellido}",
            fontWeight: FontWeight.bold,
            fontSize: 18,
            overflow: TextOverflow.clip,
          ),

          CustomText(
            "Fecha aproximada de Próxima Lectura: ${situacionActualResultado!.lecturaTeorica}",
          ),
          const SizedBox(height: 10),

          CustomCard(
            child: Text(
              situacionActualResultado?.habilitarAporteLectura?.mensaje,
            ),
          ),
        ],
      ),
    );
  }

  Widget mostrarResultadoConsulta2() {
    if (situacionActualResultado == null) return const SizedBox();

    if (situacionActualResultado?.habilitarAporteLectura?.habilitado == 'N') {
      return mostrarLecturaNOHabilitada();
    }

    return Column(
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
          "Fecha aproximada de Próxima Lectura: ${situacionActualResultado!.lecturaTeorica}",
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
              if (situacionActualResultado!.tipoTension!.contains("BT"))
                CustomText(
                  "Última lectura: ${situacionActualResultado!.calculoConsumo!.leturaAnterior}",
                ),
              CustomText(
                "Última fecha de lectura: ${situacionActualResultado!.calculoConsumo!.ultimaFechaLectura}",
              ),
              CustomText(
                "Días de consumo desde la última lectura: ${situacionActualResultado!.calculoConsumo!.cantidadDias}",
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),
        CustomComment(
          text:
              "Antes de ingresar su lectura, por favor vea el video demostrativo de cómo leer su medidor",
          bold: true,
        ),

        const SizedBox(height: 10),
        Form(
          key: _formKeyCalculoConsumo,
          child: TextFormField(
            controller: _lecturaActualController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Lectura Actual del Medidor',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa Lectura Actual del Medidor';
              }
              return null;
            },
          ),
        ),

        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoadingCalcularConsumo ? null : _calcularConsumo,
            child: isLoadingCalcularConsumo
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Presionar para Calcular Consumo'),
          ),
        ),

        const SizedBox(height: 10),
        // Botón para abrir video en ModalBottomSheet
        Visibility(
          visible: situacionActualResultado?.tieneVideo ?? false,
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.play_circle_fill),
              label: const Text("Ver video demostrativo"),
              onPressed: () {
                showModalBottomSheet(
                  isDismissible: true,
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 24,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          color: Colors.white,
                          height: MediaQuery.of(context).size.height * 0.34,
                          width:
                              MediaQuery.of(context).size.width *
                              0.9, // 90% del ancho
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: YoutubeVideoScreen(
                              videoUrl:
                                  "https://www.youtube.com/watch?v=nncePhsN7bI",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
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

              Form(
                key: _formKeyCalculoConsumo,
                child: TextFormField(
                  controller: _lecturaActualController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Lectura Actual del Medidor',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa Lectura Actual del Medidor';
                    }

                    return null;
                  },
                ),
              ),

              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoadingCalcularConsumo ? null : _calcularConsumo,
                  child: isLoadingCalcularConsumo
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Presionar para Calcular Consumo'),
                ),
              ),
              YoutubeVideoScreen(
                videoUrl: "https://www.youtube.com/watch?v=nncePhsN7bI",
                //url: situacionActualResultado!.tieneVideo!
                //? situacionActualResultado?.url ?? ""
                //  : "", // ID del video
              ),
            ],
          )
        : Text("");
  }

  Widget mostrarResultadoCalularConsumo() {
    return calculoConsumoResultado != null
        ? Column(
            children: [
              if (calculoConsumoResultado!.lecturaAnomala != null)
                CustomCard(
                  borderColor: Colors.red,
                  child: CustomText(
                    "${calculoConsumoResultado!.lecturaAnomala} Favor adjuntar Fotografía o Video para confirmar su lectura.",
                    overflow: TextOverflow.clip,
                  ),
                ),

              if (calculoConsumoResultado!.lecturaAnomala != null)
                Adjuntos(
                  label: 'Adjuntar imagen o video',
                  validator: (value) => 'Debes adjuntar un archivo',
                  onChanged: (archivo) =>
                      //print('Seleccionado: ${archivo?.file.path}'),
                      _archivoSeleccionado1 = archivo,
                ),

              CustomCard(
                child: CustomText(
                  "El importe calculado no incluye IVA, Alumbrado público ni otros cargos. Se facturará obligatoriamente un mínimo de kWh mensuales, según la carga contratada",
                  overflow: TextOverflow.clip,
                ),
              ),
              _resultadoBox(),
              CustomCard(
                title: "Atención",
                child: CustomText(
                  "La lectura ingresada es de exclusiva responsabilidad del cliente. Una vez confirmada la lectura, ésta ya no puede ser modificada por este medio.",
                  overflow: TextOverflow.clip,
                ),
              ),
              const SizedBox(height: 10),

              Form(
                key: _formKeyConfirmarLectura,
                child: TextFormField(
                  // focusNode: _focusNode,
                  controller: telefonoController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Titular Número de Teléfono",
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "Debe ingresar teléfono";
                    }

                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoadingConfirmarLectura
                      ? null
                      : _confirmarLectura,
                  child: isLoadingConfirmarLectura
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Confirmar Lectura'),
                ),
              ),
              const SizedBox(height: 10),
            ],
          )
        : Text("");

    Text("${calculoConsumoResultado!.cantidadDias}");
  }

  Widget _resultadoBox() {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            // color: theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
            border: BoxBorder.all(color: isDark ? Colors.green : Colors.black),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mostramos los datos
              Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[600] : Colors.grey[300],
                ),
                width: double.infinity,
                child: CustomText("Cálculo del Consumo en kWh"),
              ),

              Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: CustomText(
                      formatNumero(_lecturaActualController.text),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomText(
                      'Lectura Actual.',
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: CustomText(
                      formatNumero(
                        situacionActualResultado!
                            .calculoConsumo!
                            .leturaAnterior,
                      ),
                      textAlign: TextAlign.right,
                      underline: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomText(
                      'Lectura anterior.',
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: CustomText(
                      formatNumero(
                        int.parse(_lecturaActualController.text) -
                            situacionActualResultado!
                                .calculoConsumo!
                                .leturaAnterior!
                                .toInt(),
                      ),
                      textAlign: TextAlign.right,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        // color: Colors.black,
                      ), // Estilo por defecto para todo el texto
                      children: <TextSpan>[
                        // TextSpan(text: 'Este es texto normal, '),
                        TextSpan(
                          text: 'Consumo kWh',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: '(Lectura Actual menos \n Lectura Anterior)',
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[600] : Colors.grey[300],
                ),
                width: double.infinity,
                child: CustomText("Cálculo del Consumo en kWh"),
              ),

              Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: CustomText(
                      formatNumero(calculoConsumoResultado?.consumo.toString()),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomText(
                      'Consumo kWh.',
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: CustomText(
                      formatNumero(calculoConsumoResultado!.tarifa.toString()),
                      textAlign: TextAlign.right,
                      underline: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomText(
                      'Tarifa Gs.',
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: CustomText(
                      formatNumero(
                        (calculoConsumoResultado?.consumo?.toInt() ?? 0) *
                            (calculoConsumoResultado?.tarifa?.toInt() ?? 0),
                      ),
                      textAlign: TextAlign.right,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  const SizedBox(width: 16),

                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        //color: Colors.black,
                      ), // Estilo por defecto para todo el texto
                      children: <TextSpan>[
                        // TextSpan(text: 'Este es texto normal, '),
                        TextSpan(
                          text: 'Importe Gs.',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: '\n (Consumo multiplicado por Tarifa)'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un NIS';
                    }
                    if (!RegExp(r'^\d+$').hasMatch(value)) {
                      return 'Solo números permitidos';
                    }
                    if (value.length != 7) {
                      return 'NIS debe ser de 7 dígitos.';
                    }
                    return null;
                  },
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

                mostrarResultadoConsulta2(),
                mostrarResultadoCalularConsumo(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
