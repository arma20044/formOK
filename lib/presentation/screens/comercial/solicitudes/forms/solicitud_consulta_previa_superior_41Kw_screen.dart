import 'package:flutter/material.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/infrastructure/infrastructure.dart';
import 'package:form/model/archivo_adjunto_model.dart';
import 'package:form/model/consulta_documento_model.dart';
import 'package:form/presentation/auth/login_screen.dart';
import 'package:form/presentation/components/common/UI/custom_card.dart';
import 'package:form/presentation/components/common/UI/custom_comment.dart';
import 'package:form/presentation/components/common/UI/custom_dialog.dart';
import 'package:form/presentation/components/common/UI/custom_phone_field.dart';
import 'package:form/presentation/components/common/UI/custom_submit_button.dart';
import 'package:form/presentation/components/common/custom_text.dart';
import 'package:form/presentation/components/common/map_selector_inline.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:form/repositories/repositories.dart';
import 'package:form/utils/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SolicitudConsultaPreviaSuperior41KwScreen extends StatefulWidget {
  const SolicitudConsultaPreviaSuperior41KwScreen({super.key});

  @override
  State<SolicitudConsultaPreviaSuperior41KwScreen> createState() =>
      _SolicitudConsultaPreviaSuperior41KwScreenState();
}

class _SolicitudConsultaPreviaSuperior41KwScreenState
    extends State<SolicitudConsultaPreviaSuperior41KwScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoadingSolicitud = false;
  String label = "Enviar Solicitud";

  final List<DropdownItem> dropDownItems = [
    DropdownItem(id: 'TD001', name: 'C.I. Civil'),
    DropdownItem(id: 'TD002', name: 'RUC'),
    //DropdownItem(id: 'TD004', name: 'Pasaporte'),
  ];

  DropdownItem? selectedTipoDocumento;

  bool isLoadingConsultaDocumento = false;
  final TextEditingController nombreObtenido = TextEditingController();
  final TextEditingController apellidoObtenido = TextEditingController();

  final _numeroDocumentoFieldKey = GlobalKey<FormFieldState<String>>();

  final FocusNode _focusNode = FocusNode();

  late ConsultaDocumentoResultado consultaDocumentoResponse;

  final TextEditingController numeroDocumentoController =
      TextEditingController();

  final TextEditingController numeroTelefonoCelularController =
      TextEditingController();

  final TextEditingController correoController = TextEditingController();

  LatLng? ubicacion;
  bool showMap = false;

  dynamic solicitudAbastecimientoResult;

  // Archivos adjuntos
  List<ArchivoAdjunto> selectedFileSolicitudList = [];
  List<ArchivoAdjunto> selectedFileFotocopiaAutenticadaList = [];
  List<ArchivoAdjunto> selectedFileFotocopiaSimpleCedulaSolicitanteList = [];
  List<ArchivoAdjunto> selectedFileCopiaSimpleCarnetElectricistaList = [];
  List<ArchivoAdjunto> selectedFileOtrosDocumentosList = [];

  List<ArchivoAdjunto> selectedFileAdjuntoTituloPropiedadList = [];

  List<ArchivoAdjunto> selectedFileAdjuntoOtroList = [];

  List<ArchivoAdjunto> etiquetaFiles = [];

  final repoConsultaDocumento = ConsultaDocumentoRepositoryImpl(
    ConsultaDocumentoDatasourceImpl(MiAndeApi()),
  );

  void consultarDocumento(String documento) async {
    setState(() {
      isLoadingConsultaDocumento = true;
      nombreObtenido.text = "";
      apellidoObtenido.text = "";
    });
    try {
      consultaDocumentoResponse = await repoConsultaDocumento
          .getConsultaDocumento(
            numeroDocumentoController.text,
            selectedTipoDocumento?.id ?? "",
          );

      setState(() {
        if (consultaDocumentoResponse.razonSocial != null) {
          nombreObtenido.text = consultaDocumentoResponse.razonSocial!;
          apellidoObtenido.text = consultaDocumentoResponse.razonSocial!;
        } else {
          nombreObtenido.text = consultaDocumentoResponse.nombres!;
          apellidoObtenido.text = consultaDocumentoResponse.apellido!;
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("$e", style: TextStyle(color: Colors.white)),
          ),
        );
      }
      return;
    } finally {
      setState(() => isLoadingConsultaDocumento = false);
    }
  }

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (selectedTipoDocumento?.id == null) return;
      if (selectedTipoDocumento?.id == 'TD004') return;
      if (!_focusNode.hasFocus) {
        // 🔹 Esperar a que se estabilice el árbol de widgets
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final state = _numeroDocumentoFieldKey.currentState;
          if (state != null && state.mounted) {
            final isValid = state.validate();
            if (isValid) {
              // 🔹 Si pasa la validación, ejecutamos la lógica adicional
              //   await consultarDocumento();
              consultarDocumento(numeroDocumentoController.text);
            }
          }
        });
      }
    });
  }

  void _mostrarMapa() {
    setState(() {
      showMap = !showMap;
    });
  }

  void limpiarTodo() {
    nombreObtenido.text = '';
    apellidoObtenido.text = '';
    numeroDocumentoController.clear();
    numeroTelefonoCelularController.clear();
    correoController.clear();

    setState(() {
      showMap = false;
      ubicacion = null;
      selectedFileSolicitudList.clear();
      selectedFileFotocopiaAutenticadaList.clear();
      selectedFileFotocopiaSimpleCedulaSolicitanteList.clear();
      selectedFileCopiaSimpleCarnetElectricistaList.clear();
      selectedFileOtrosDocumentosList.clear();
      //_formKey.currentState?.reset();
    });

    FocusScope.of(context).unfocus();
  }

  void _enviarFormulario() async {
    if (_isLoadingSolicitud) return;

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese los campos obligatorios')),
      );
      return;
    }

    if (ubicacion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agregue ubicación en el Mapa.')),
      );
      return;
    }

    try {
      setState(() => _isLoadingSolicitud = true);

      final repo = SolicitudAbastecimientoRepositoryImpl(
        SolicitudAbastecimientoDatasourceImp(MiAndeApi()),
      );

      final result = await repo.getSolicitudAbastecimiento(
        nombreObtenido.text,
        apellidoObtenido.text,
        selectedTipoDocumento?.id,
        numeroDocumentoController.text,
        numeroTelefonoCelularController.text,
        correoController.text,
        '9',
        selectedFileSolicitudList,
        selectedFileFotocopiaAutenticadaList,
        selectedFileFotocopiaSimpleCedulaSolicitanteList,
        selectedFileCopiaSimpleCarnetElectricistaList,
        selectedFileAdjuntoTituloPropiedadList,
        selectedFileAdjuntoOtroList,
        ubicacion,
        "",
        "",
        "",
      );

      if (!mounted) return;

      if (result.mensaje == null ||
          !result.mensaje!.contains("Se ha creado exitosamente")) {
        limpiarTodo();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.errorValList != null && result.errorValList!.isNotEmpty
                  ? result.errorValList!.first
                  : (result.mensaje ?? "Ocurrió un error"),
            ),
          ),
        );
        return;
      }

      showCustomDialog(
        context: context,
        message: result.mensaje!,
        showCopyButton: false,
        title: "Éxito.",
        type: DialogType.success,
      ).then((_) {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al enviar la solicitud")),
      );
    } finally {
      setState(() => _isLoadingSolicitud = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Solicitud de Consulta previa\n superior a 41,58 KW."),
      ),
      endDrawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Form(key: _formKey, child: cuerpo(context, theme)),
      ),
      bottomNavigationBar: CustomSubmitButton(
        loading: _isLoadingSolicitud,
        onPressed: _enviarFormulario,
        label: label,
      ),
    );
  }

  Widget cuerpo(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CustomComment(
            text: "Solicitud de Consulta previa superior a 41,58 KW.",
          ),
          DropdownButtonFormField<DropdownItem>(
            initialValue: selectedTipoDocumento,
            hint: const Text("Seleccionar Tipo de Documento"),
            items: dropDownItems
                .map(
                  (item) =>
                      DropdownMenuItem(value: item, child: Text(item.name)),
                )
                .toList(),
            onChanged: (value) {
              setState(() => selectedTipoDocumento = value);
              nombreObtenido.text = '';
              apellidoObtenido.text = '';
            },

            /*onChanged: isLoading
                            ? null
                            : (value) {
                                setState(() => selectedTipoDocumento = value);
                                numeroController.text = "";
                              },*/
            validator: (value) =>
                value == null ? 'Seleccione un tipo de documento' : null,
          ),

          const SizedBox(height: 20),
          TextFormField(
            key: _numeroDocumentoFieldKey,
            focusNode: _focusNode,
            controller: numeroDocumentoController,
            //keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Número de CI, RUC o Pasaporte",
              border: OutlineInputBorder(),
            ),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return "Ingrese Número de CI, RUC o Pasaporte";
              }

              final tipo = selectedTipoDocumento?.id ?? '';

              // C.I. Civil → solo números, entre 6 y 10 dígitos
              if (tipo == 'TD001' && !RegExp(r'^[0-9]{6,10}$').hasMatch(val)) {
                return "Éste campo debe contener solo números.";
              }

              // RUC → números, guion y dígito verificador
              if (tipo == 'TD002' && !RegExp(r'^\d{6,12}-\d$').hasMatch(val)) {
                return "Este campo debe tener formato de RUC";
              }

              return null;
            },
          ),

          Visibility(
            visible:
                selectedTipoDocumento?.id != null &&
                nombreObtenido.text.isNotEmpty,
            child: selectedTipoDocumento?.id == "TD001"
                ? Column(
                    children: [
                      const SizedBox(height: 20),
                      CustomText("Nombre(s) del Titular", color: Colors.green),
                      Text(nombreObtenido.text),

                      const SizedBox(height: 20),
                      CustomText(
                        "Apellido(s) del Titular",
                        color: Colors.green,
                      ),
                      Text(apellidoObtenido.text),
                    ],
                  )
                : Column(
                    children: [
                      const SizedBox(height: 20),
                      CustomText("Razón Social", color: Colors.green),
                      Text(nombreObtenido.text),
                    ],
                  ),
          ),

          const SizedBox(height: 20),

          CustomPhoneField(
            //focusNode: _focusNode,
            controller: numeroTelefonoCelularController,

            validator: (val) {
              if (val == null || val.isEmpty) {
                return "Ingrese Número Teléfono Celular";
              }
              return null;
            },
          ),

          const SizedBox(height: 20),
          TextFormField(
            //focusNode: _focusNode,
            controller: correoController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "Correo del Titular",
              border: OutlineInputBorder(),
            ),
            validator: (val) {
              //if (selectedTipoReclamo?.nisObligatorio == 'S') {
              if (val == null || val.isEmpty) {
                return "Ingrese Correo";
              }
              if (!emailRegex.hasMatch(val)) {
                return "Ingrese formato de correo válido.";
              }
              return null;
              //}
            },
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text("Agregar punto en Mapa"),
              onPressed: _mostrarMapa,
            ),
          ),

          const SizedBox(height: 24),
          Visibility(
            visible: showMap,
            child: Column(
              children: [
                MapSelectorInline(
                  initialLocation: ubicacion,
                  onLocationSelected: (loc) {
                    setState(() => ubicacion = loc);
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  "Formulario de Solicitud de Consulta previa superior a 41,58 KW.",
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.clip,
                ),
                const CustomText(
                  '1) Descargar formulario y completar.',
                  fontWeight: FontWeight.bold,
                ),
                TextButton(
                  onPressed: () => lanzarUrl('URL_SOLICITUD_CONSULTA_PREVIA'),
                  child: const Text(
                    "Descargar Formulario de Solicitud de Consulta previa superior a 41,58 KW.",
                  ),
                ),
                const CustomText('2) Adjuntar como documento de respaldo.'),
              ],
            ),
          ),

          buildMediaCard(
            title: "a) Solicitud de Consulta previa superior a 41,58 KW.",
            files: selectedFileSolicitudList,
            onChanged: (lista) =>
                setState(() => selectedFileSolicitudList = lista),
            ayuda: "Seleccionar archivo desde la Galería o la Cámara",
            theme: theme,
          ),

          buildMediaCard(
            title:
                "b) Fotocopia de cedula del solicitante o de los representantes legales.",
            files: selectedFileFotocopiaSimpleCedulaSolicitanteList,
            onChanged: (lista) => setState(
              () => selectedFileFotocopiaSimpleCedulaSolicitanteList = lista,
            ),
            ayuda: "Seleccionar archivo desde la Galería o la Cámara",
            theme: theme,
          ),

          buildMediaCard(
            title: "c) Fotocopia del carnet del electricista responsable.",
            files: selectedFileFotocopiaSimpleCedulaSolicitanteList,
            onChanged: (lista) => setState(
              () => selectedFileFotocopiaSimpleCedulaSolicitanteList = lista,
            ),
            ayuda: "Seleccionar archivo desde la Galería o la Cámara",
            theme: theme,
          ),

          buildGroupedMediaCard(
            theme: theme,
            groups: [
              MediaGroup(
                key: 'interno',
                title:
                    'd) Presentar el plano de ubicación o proyecto ejecutivo con los siguientes datos:',
                ayuda:
                    'Transformador exclusivo : lugar para el puesto de entrega o proyecto ejecutivo.',
                onChanged: (files) {
                  setState(() {
                    selectedFileAdjuntoTituloPropiedadList = files;
                  });
                },
              ),
              MediaGroup(
                key: 'frente',
                ayuda:
                    'Transformador tipo Ande: lugar para el puesto de distribución , detalle de la carga.',
                onChanged: (files) {
                  setState(() {
                    selectedFileAdjuntoOtroList = files;
                  });
                },
              ),
            ],
            mediaFiles: {
              'interno': selectedFileAdjuntoTituloPropiedadList,
              'frente': selectedFileAdjuntoOtroList,
            },
          ),
        ],
      ),
    );
  }
}
