import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/config/constantes.dart';
import 'package:form/config/tipo_tramite_model.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/infrastructure/comercial/solicitudes/calculo_consumo_datasource_imp.dart';
import 'package:form/infrastructure/infrastructure.dart';
import 'package:form/model/model.dart';
import 'package:form/presentation/components/common.dart';
import 'package:form/presentation/components/common/UI/custom_card.dart';
import 'package:form/presentation/components/common/UI/custom_comment.dart';
import 'package:form/presentation/components/common/UI/custom_phone_field.dart';
import 'package:form/presentation/components/common/adjuntos.dart';
import 'package:form/presentation/components/common/custom_bottom_sheet_image.dart';
import 'package:form/presentation/components/common/custom_show_dialog.dart';
import 'package:form/presentation/components/common/custom_snackbar.dart';
import 'package:form/presentation/components/common/custom_snackbarNEW.dart';
import 'package:form/presentation/components/common/otp_verification_widget.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:form/presentation/components/youtube_webview.dart';
import 'package:form/repositories/repositories.dart';
import 'package:form/utils/utils.dart';

class SolicitudYoFacturoMiLuzScreen extends ConsumerStatefulWidget {
  const SolicitudYoFacturoMiLuzScreen({super.key});

  @override
  ConsumerState<SolicitudYoFacturoMiLuzScreen> createState() =>
      _SolicitudYoFacturoMiLuzState();
}

class _SolicitudYoFacturoMiLuzState
    extends ConsumerState<SolicitudYoFacturoMiLuzScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyCalculoConsumoBT = GlobalKey<FormState>();
  final _formKeyCalculoConsumoMT = GlobalKey<FormState>();
  final _formKeyConfirmarLectura = GlobalKey<FormState>();

  final TextEditingController _nisController = TextEditingController();

  //BT
  final TextEditingController _lecturaActualController =
      TextEditingController();

  //MT
  final TextEditingController _lecturaEnergiaActivaController =
      TextEditingController();
  final TextEditingController _lecturaEnergiaReactivaController =
      TextEditingController();
  final TextEditingController _lecturaPotencioaController =
      TextEditingController();

  final TextEditingController telefonoController = TextEditingController();

  bool isLoading = false;
  bool isLoadingCalcularConsumo = false;
  bool isLoadingConfirmarLectura = false;

  SituacionActualResultado? situacionActualResultado;
  ResultadoCalculoConsumo? calculoConsumoResultado;
  DatosCliente? datosCliente;

  final bool _isLoadingSolicitud = false;
  ModalModel? selectedTipoVerificacion;
  String? codigoOTPObtenido;
  String? solicitarOTP = 'S';

  bool mostrarCargarCodigoOTP = false;

  ArchivoAdjunto? _archivoSeleccionado1;
  List<ArchivoAdjunto> selectedFileSolicitudList = [];

  void limpiarTodo() {
    _nisController.text = '';
    telefonoController.text = '';

    _nisController.clear();
    telefonoController.clear();

    setState(() {
      selectedFileSolicitudList.clear();
    });

    FocusScope.of(context).unfocus();
  }

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
        if (mounted) {
          CustomSnackbar.show(
            context,
            message: "Ocurrió un error, Favor intente nuevamente la consulta",
            type: MessageType.error,
          );
        }

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

      if (consultaSituacionActualResponse
              .resultado
              ?.habilitarAporteLectura
              ?.habilitado ==
          'S') {
        if (mounted) {
          showModalBottomSheet(
            isDismissible: false,
            context: context, // Contexto de la pantalla actual
            isScrollControlled: true, // Permite que ocupe más espacio (ej. 80%)
            backgroundColor: Colors
                .transparent, // Fondo transparente para bordes redondeados
            builder: (_) => const ImageBottomSheet(
              assetPath: 'assets/images/yofacturo.png',
            ),
          );
        }
      }

      /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Consultando NIS: $nis')),
      );*/
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> confirmacionLectura(bool solicitarOTP) async {
    if (isLoadingConfirmarLectura) return;

    if (
    !_formKey.currentState!.validate()
    ||
    solicitarOTP && !_formKeyConfirmarLectura.currentState!.validate()
    //|| !_formKeyCalculoConsumo.currentState!.validate()
    ) {
      /*ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese los campos obligatorios')),
      );*/
      CustomSnackbar.show(
        context,
        message: 'Ingrese los campos obligatorios',
        type: MessageType.error,
      );
      return;
    }

    if (selectedFileSolicitudList.isEmpty &&
        calculoConsumoResultado?.lecturaAnomala != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Es necesario anexar foto o video.")),
      );
      return;
    }

    setState(() {
      isLoadingConfirmarLectura = true;
    });

    try {
      final result = await _fetchSolicitudYoFacturoMiLuz(solicitarOTP);

      if (result.error!) {
        if (mounted) {
          DialogHelper.showMessage(
            context,
            MessageType.error,
            'Error',
            result.errorValList?[0] ?? "Error.",
          );
        }

        setState(() {
          codigoOTPObtenido = "";
          this.solicitarOTP = "N";
         
        });

        return;
      } else if (solicitarOTP) {
        if (mounted) {
          showModalBottomSheet<void>(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: SingleChildScrollView(
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 500),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          OtpInputWidget(
                            isLoading: _isLoadingSolicitud,
                            tipoVerificacion: 'CEL',
                            phoneNumber: telefonoController.text,
                            correo: "",
                            onSubmit: (otp) {
                              setState(() {
                                codigoOTPObtenido = otp;
                                this.solicitarOTP = 'N';
                              });

                              confirmacionLectura(false);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }

        setState(() {
          this.solicitarOTP = 'S';
        });
        mostrarCargarCodigoOTP = true;
        if (mounted) {
          DialogHelper.showMessage(
            context,
            MessageType.success,
            'Éxito',
            "Te enviamos un código a tu celular, favor ingresa para confirmar el registro.",

            //duration: const Duration(seconds: 3),
          );
        }
      } else {
        if (!mounted) return;

        Navigator.of(context).pop(); // cerrar BottomSheet

       /* WidgetsBinding.instance.addPostFrameCallback((_) {
          DialogHelper.showMessage(
            context,
            MessageType.success,
            'Éxito',
            result.mensaje!,
          );

          limpiarTodo();
          Navigator.of(context).pop();
        });*/
        CustomSnackbar.show(context, message: result.mensaje!);
        Navigator.of(context).pop();
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      setState(() {
        //calculoConsumoResultado = null;
      });

      if (mounted) {
        String mensaje;
        if (e is DioException) {
          final data = e.response?.data;

          if (data is Map && data['errorValList'] != null) {
            mensaje = extraerMensajeError(data);
          } else {
            mensaje = data.toString();
          }
          
          DialogHelper.showMessage(
            context,
            MessageType.error,
            'Error',
            mensaje,
          );

          /*if(mensaje.contains("Ya se aportó")){

          }

           telefonoController.text = '';
          telefonoController.clear();*/
        }
      }
    } finally {
      setState(() {
        isLoadingConfirmarLectura = false;
      });
    }
  }

  Future<SolicitudYoFacturoMiLuzResponse> _fetchSolicitudYoFacturoMiLuz(
    bool solicitarOTP,
  ) async {
    final repoConfirmacionLectura = SolicitudYoFacturoMiLuzRepositoryImpl(
      SolicitudYoFacturoMiLuzDatasourceImp(MiAndeApi()),
    );

    return await repoConfirmacionLectura.getSolicitudYoFacturoMiLuz(
      situacionActualResultado?.tipoTension ?? 'BT',
      _nisController.text,
      _lecturaActualController.text,
      telefonoController.text,
      selectedFileSolicitudList.isEmpty ? [] : selectedFileSolicitudList,
      [],
      [],
      [],
      [],
      [],
      solicitarOTP ? 'S' : 'N',
      codigoOTPObtenido,


      _lecturaEnergiaActivaController.text,
      _lecturaEnergiaReactivaController.text,
      _lecturaPotencioaController.text
    );
  }

  Future<void> _calcularConsumo() async {
    final String tipoTension = situacionActualResultado?.tipoTension ?? 'BT';

    if (tipoTension.contains('BT')) {
      if (!_formKey.currentState!.validate() ||
          !_formKeyCalculoConsumoBT.currentState!.validate()) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //const SnackBar(content: Text('Ingrese los campos obligatorios')),
        CustomSnackbar.show(
          context,
          message: 'Ingrese los campos obligatorios',
          type: MessageType.error,
        );
        //  );
        return;
      }
    } else {
      if (!_formKey.currentState!.validate() ||
          !_formKeyCalculoConsumoMT.currentState!.validate()) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //const SnackBar(content: Text('Ingrese los campos obligatorios')),
        CustomSnackbar.show(
          context,
          message: 'Ingrese los campos obligatorios',
          type: MessageType.error,
        );
        //  );
        return;
      }
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
            tipoTension,
            _lecturaEnergiaActivaController.text,
            _lecturaEnergiaReactivaController.text,
            _lecturaPotencioaController.text,
          );

      if (consultaCalculoConsumoResponse.error == true) {
        /*ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Favor intente nuevamente la consulta"),
          ),
        );*/
        if (mounted) {
          CustomSnackbar.show(
            context,
            message: "Ocurrió un error, Favor intente nuevamente la consulta",
            type: MessageType.error,
          );
        }

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
      if (mounted) {
        CustomSnackbar.show(
          context,
          message: "Error: $e",
          type: MessageType.error,
          //duration: Durations.long4,
        );
      }
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

  Widget mostrarResultadoConsultaBT(BuildContext context) {
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
          key: _formKeyCalculoConsumoBT,
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

  Widget mostrarResultadoConsultaMT() {
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
              CustomText(
                fontWeight: FontWeight.bold,
                "Última lectura activa: ${situacionActualResultado!.calculoConsumo?.lecturaAnteriorActiva}",
              ),
              CustomText(
                fontWeight: FontWeight.bold,
                "Última lectura reactiva: ${situacionActualResultado!.calculoConsumo?.lecturaAnteriorReactiva}",
              ),
              CustomText(
                fontWeight: FontWeight.bold,
                "Última lectura potencia: ${situacionActualResultado!.calculoConsumo?.lecturaAnteriorPotencia}",
              ),
              CustomText(
                fontWeight: FontWeight.bold,
                "Consumo Mínimo: ${situacionActualResultado!.calculoConsumo?.consumoMinimo} kWh",
              ),
              if (situacionActualResultado!.tipoTension!.contains("BT"))
                CustomText(
                  "Última lectura: ${situacionActualResultado!.calculoConsumo?.leturaAnterior}",
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

        /*const SizedBox(height: 10),
        CustomComment(
          text:
              "Antes de ingresar su lectura, por favor vea el video demostrativo de cómo leer su medidor",
          bold: true,
        ),*/
        const SizedBox(height: 10),
        Form(
          key: _formKeyCalculoConsumoMT,
          child: Column(
            children: [
              TextFormField(
                controller: _lecturaEnergiaActivaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Lectura Energía Activa',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa Lectura Energía Activa';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _lecturaEnergiaReactivaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Lectura Energía Reactiva',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa Lectura Energía Reactiva';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _lecturaPotencioaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Lectura Potencia',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa Lectura Potencia';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
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

  Widget mostrarResultadoCalularConsumo() {
    final theme = Theme.of(context);
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
                /*   Adjuntos(
                  label: 'Adjuntar imagen o video',
                  validator: (value) => 'Debes adjuntar un archivo',
                  onChanged: (archivo) =>
                      //print('Seleccionado: ${archivo?.file.path}'),
                      _archivoSeleccionado1 = archivo,
                ),*/
                CustomCard(
                  borderColor: Colors.red,
                  child: buildMediaCard(
                    title:
                        "La lectura ingresada está fuera de rango. Favor adjuntar Fotografía o Video para confirmar su lectura.",
                    files: selectedFileSolicitudList,
                    onChanged: (lista) =>
                        setState(() => selectedFileSolicitudList = lista),
                    ayuda: "Seleccionar archivo desde la Galería o la Cámara",
                    theme: theme,
                  ),
                ),

              CustomCard(
                child: CustomText(
                  "El importe calculado no incluye IVA, Alumbrado público ni otros cargos. Se facturará obligatoriamente un mínimo de kWh mensuales, según la carga contratada",
                  overflow: TextOverflow.clip,
                ),
              ),

              if (situacionActualResultado!.tipoTension!.contains('BT'))
                _resultadoBoxBT(),

              if (situacionActualResultado!.tipoTension!.contains('MT'))
                _resultadoBoxMT(),

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
                child:
                    /*TextFormField(
                  // focusNode: _focusNode,
                  controller: telefonoController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Número Teléfono Celular",
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "Debe ingresar Número Teléfono Celular";
                    }

                    return null;
                  },
                ),*/
                    CustomPhoneField(
                      label: "Número Teléfono Celular",
                      controller: telefonoController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      required: true,
                    ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoadingConfirmarLectura
                      ? null
                      : () => confirmacionLectura(true),
                  child: isLoadingConfirmarLectura
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Confirmar Lectura'),
                ),
              ),
              const SizedBox(height: 10),
            ],
          )
        : Text("");

    //Text("${calculoConsumoResultado!.cantidadDias}");
  }

  Widget _resultadoBoxBT() {
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
                        //(calculoConsumoResultado?.consumo?.toInt() ?? 0) *
                        //     (calculoConsumoResultado?.tarifa?.toInt() ?? 0),
                        calculoConsumoResultado?.monto ?? 0,
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

  Widget _resultadoBoxMT() {
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

              Row(children: [
        
         
        

        ],
      ),
              Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: CustomText(
                      formatNumero("Activa"),
                      textAlign: TextAlign.right,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: CustomText(
                      formatNumero("Reactiva"),
                      textAlign: TextAlign.right,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: CustomText(
                      formatNumero(_lecturaEnergiaActivaController.text),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: CustomText(
                      formatNumero(_lecturaEnergiaReactivaController.text),
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
                        calculoConsumoResultado!.lecturaAnteriorActiva,
                      ),
                      textAlign: TextAlign.right,
                      underline: true,
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: CustomText(
                      formatNumero(
                        calculoConsumoResultado!.lecturaAnteriorReactiva,
                      ),
                      textAlign: TextAlign.right,
                      underline: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomText(
                      'Lectura Anterior.',
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
                        int.parse(_lecturaEnergiaActivaController.text) -
                            calculoConsumoResultado!.lecturaAnteriorActiva!
                                .toInt(),
                      ),

                      textAlign: TextAlign.right,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: CustomText(
                      formatNumero(
                        int.parse(_lecturaEnergiaReactivaController.text) -
                            calculoConsumoResultado!.lecturaAnteriorReactiva!
                                .toInt(),
                      ),

                      textAlign: TextAlign.right,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomText(
                      'Lectura Actual menos \n Lectura Anterior.',
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
                      "${formatNumero(int.parse(_lecturaEnergiaActivaController.text) - calculoConsumoResultado!.lecturaAnteriorActiva!.toInt())}*",

                      textAlign: TextAlign.right,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: CustomText(
                      formatNumero(
                        int.parse(_lecturaEnergiaReactivaController.text) -
                            calculoConsumoResultado!.lecturaAnteriorReactiva!
                                .toInt(),
                      ),

                      textAlign: TextAlign.right,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomText(
                      'Consumo Resultante.',
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),

              Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[600] : Colors.grey[300],
                ),
                width: double.infinity,
                child: CustomText("Importe del Consumo en Gs."),
              ),

              Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: CustomText(
                      formatNumero("Activa"),
                      textAlign: TextAlign.right,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: CustomText(
                      formatNumero("Reactiva"),
                      textAlign: TextAlign.right,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: CustomText(
                      formatNumero("(kWh)"),
                      textAlign: TextAlign.right,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: CustomText(
                      formatNumero("(kVARh)	"),
                      textAlign: TextAlign.right,
                      fontWeight: FontWeight.bold,
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
                        int.parse(_lecturaEnergiaActivaController.text) -
                            calculoConsumoResultado!.lecturaAnteriorActiva!
                                .toInt(),
                      ),

                      textAlign: TextAlign.right,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: CustomText(
                      formatNumero(
                        int.parse(_lecturaEnergiaReactivaController.text) -
                            calculoConsumoResultado!.lecturaAnteriorReactiva!
                                .toInt(),
                      ),

                      textAlign: TextAlign.right,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomText(
                      'Consumo Resultante',
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
                        calculoConsumoResultado!.tarifaActiva!.toInt(),
                      ),

                      textAlign: TextAlign.right,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: CustomText(
                      "**",

                      textAlign: TextAlign.right,
                      fontWeight: FontWeight.bold,
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
                      formatNumero(calculoConsumoResultado!.montoActiva),
                      textAlign: TextAlign.right,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: CustomText(
                      formatNumero(calculoConsumoResultado!.montoReactiva),
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
                        TextSpan(
                          text: '\n (Consumo multiplicado\n por Tarifa)',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: CustomText(
                      formatNumero(calculoConsumoResultado!.montoTotal),
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
                          text: 'Importe Parcial Gs.',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' (Monto Activa más\n Monto Reactiva))'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        CustomCard(
          child: Text(
            "* Resultado de diferencia de lectura multiplicado por la constante y el coeficiente de pérdida \n** 4% del costo de la energía activa por cada centésimo por debajo del factor de potencia 0,92",
          ),
        ),
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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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

                situacionActualResultado?.tipoTension == 'BT'
                    ? mostrarResultadoConsultaBT(context)
                    : mostrarResultadoConsultaMT(),
                mostrarResultadoCalularConsumo(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
