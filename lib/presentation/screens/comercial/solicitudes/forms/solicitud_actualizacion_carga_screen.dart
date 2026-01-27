import 'package:flutter/material.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/infrastructure/infrastructure.dart';
import 'package:form/model/model.dart';
import 'package:form/presentation/auth/login_screen.dart';
import 'package:form/presentation/components/common.dart';
import 'package:form/presentation/components/common/UI/custom_card.dart';
import 'package:form/presentation/components/common/UI/custom_comment.dart';
import 'package:form/presentation/components/common/UI/custom_dialog.dart';
import 'package:form/presentation/components/common/UI/custom_phone_field.dart';
import 'package:form/presentation/components/common/map_selector_inline.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:form/repositories/repositories.dart';
import 'package:form/utils/utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SolicitudActualizacionCargaScreen extends StatefulWidget {
  const SolicitudActualizacionCargaScreen({super.key});

  @override
  State<SolicitudActualizacionCargaScreen> createState() =>
      _SolicitudActualizacionCargaScreenState();
}

class _SolicitudActualizacionCargaScreenState
    extends State<SolicitudActualizacionCargaScreen> {
  bool isLoadingConsultaDocumento = false;

  final formKey = GlobalKey<FormState>();
  bool _isLoadingSolicitud = false;

  final List<DropdownItem> dropDownItems = [
    DropdownItem(id: 'TD001', name: 'C.I. Civil'),
    DropdownItem(id: 'TD002', name: 'RUC'),
    //DropdownItem(id: 'TD004', name: 'Pasaporte'),
  ];

  DropdownItem? selectedTipoDocumento;

  late ConsultaDocumentoResultado consultaDocumentoResponse;

  final TextEditingController numeroDocumentoController =
      TextEditingController();

  final TextEditingController numeroTelefonoCelularController =
      TextEditingController();

  final TextEditingController correoController = TextEditingController();

  final TextEditingController nombreObtenido = TextEditingController();
  final TextEditingController apellidoObtenido = TextEditingController();

  // Ubicación
  LatLng? ubicacion;

  LatLng? _currentPosition;

  GoogleMapController? _mapController;

  // Archivos adjuntos
  List<ArchivoAdjunto> selectedFileSolicitudList = [];
  List<ArchivoAdjunto> selectedFileFotocopiaAutenticadaList = [];
  List<ArchivoAdjunto> selectedFileFotocopiaSimpleCedulaSolicitanteList = [];
  List<ArchivoAdjunto> selectedFileCopiaSimpleCarnetElectricistaList = [];
  List<ArchivoAdjunto> selectedFileOtrosDocumentosList = [];

  final _numeroDocumentoFieldKey = GlobalKey<FormFieldState<String>>();
  final FocusNode _focusNode = FocusNode();

  bool showMap = false;

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

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si el servicio de ubicación está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Servicio de ubicación deshabilitado');
      setState(() {
        _currentPosition = const LatLng(-25.2637, -57.5759); // fallback
      });
      return;
    }

    // Verificar permisos
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Permiso denegado');
        setState(() {
          _currentPosition = const LatLng(-25.2637, -57.5759); // fallback
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('Permiso denegado permanentemente');
      setState(() {
        _currentPosition = const LatLng(-25.2637, -57.5759); // fallback
      });
      return;
    }

    // Permiso otorgado, obtener posición
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      setState(() {
        _currentPosition = LatLng(pos.latitude, pos.longitude);
      });
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(_currentPosition!),
        );
      }
    } catch (e) {
      debugPrint("Error obteniendo ubicación: $e");
      setState(() {
        _currentPosition = const LatLng(-25.2882897, -57.6120394); // fallback
      });
    }
  }

  void _enviarFormulario() async {
    if (_isLoadingSolicitud) return;

    if (!formKey.currentState!.validate()) {
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

    if (selectedFileSolicitudList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe adjuntar archivo en el punto a).')),
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
        '1',
        selectedFileSolicitudList,
        selectedFileFotocopiaAutenticadaList,
        selectedFileFotocopiaSimpleCedulaSolicitanteList,
        selectedFileCopiaSimpleCarnetElectricistaList,
        null,
        selectedFileOtrosDocumentosList,
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

  final repoConsultaDocumento = ConsultaDocumentoRepositoryImpl(
    ConsultaDocumentoDatasourceImpl(MiAndeApi()),
  );

  void consultarDocumento(String documento) async {
    if (!mounted) return;

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
      debugPrint("Error al consultar Documento: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("$e", style: TextStyle(color: Colors.white)),
        ),
      );
      return;
    } finally {
      setState(() => isLoadingConsultaDocumento = false);
    }
  }

  @override
  void initState() {
    super.initState();

    _determinePosition();

    _focusNode.addListener(() {
      if (selectedTipoDocumento?.id == null) return;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Solicitud para Actualización \nde Carga Hasta 41,58 kW."),
      ),
      endDrawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Form(key: formKey, child: cuerpo(context, theme)),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: _isLoadingSolicitud ? null : _enviarFormulario,
          child: _isLoadingSolicitud
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Enviar Solicitud"),
        ),
      ),
    );
  }

  Widget cuerpo(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CustomComment(
            text: "Actualización de datos de la factura de Energía Eléctrica.",
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

              final tipo = selectedTipoDocumento!.id ?? '';

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

          // ------------------------- UBICACIÓN -------------------------
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text("Agregar punto en Mapa"),
              onPressed: _mostrarMapa,
            ),
          ),

          const SizedBox(height: 24),

          if (showMap) ...[
            MapSelectorInline(
              initialLocation: ubicacion,
              onLocationSelected: (loc) {
                setState(() => ubicacion = loc);
              },
            ),
            const SizedBox(height: 24),
          ],

          const SizedBox(height: 24),
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  "Formulario de Solicitud para Actualización de Carga Hasta 41,58 kW.",
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.clip,
                  fontSize: 20,
                ),
                const CustomText(
                  '1) Descargar formulario y completar:',
                  overflow: TextOverflow.clip,
                ),
                TextButton(
                  onPressed: () => lanzarUrl('URL_SOLICITUD_ABASTECIMIENTO'),
                  child: const Text(
                    "Descargar Formulario de Solicitud de Abastecimiento.",
                  ),
                ),
                const CustomText(
                  '2) Adjuntar como documento de respaldo.',
                  overflow: TextOverflow.clip,
                ),
                const CustomText(
                  '3) Para este trámite no es necesario la firma del profesional electricista.',
                  overflow: TextOverflow.clip,
                ),
                const CustomText(
                  '4)  El costo por la diferencia de carga a contratar será incluida en su próxima factura.',
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CustomText(
                  'PASO 2: Adjuntar Documentos requeridos para poder tratar la solicitud, leer las condiciones a continuación:',
                  overflow: TextOverflow.clip,
                  fontWeight: FontWeight.bold,
                ),
                CustomText(
                  '1) Se puede adjuntar documentos en formato PDF o imágenes JPG, JPEG, PNG.',
                ),
                CustomText('2) El tamaño máximo de cada archivo es de 10 MB.'),
                CustomText('3) Los documentos deben estar legibles.'),
                CustomText(
                  '4) Mientras el tamaño de archivo sea más grande, la transacción tardará más y podría cortarse por condiciones de internet fluctuantes.',
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          buildMediaCard(
            title: "a) Solicitud para Actualización de Carga Hasta 41,58 kW.",
            files: selectedFileSolicitudList,
            onChanged: (lista) =>
                setState(() => selectedFileSolicitudList = lista),
            ayuda: "Seleccionar archivo desde la Galería o la Cámara",
            theme: theme,
          ),

          buildMediaCard(
            title: "b) Fotocopia de cedula simple del Titular del contrato.",
            files: selectedFileFotocopiaSimpleCedulaSolicitanteList,
            onChanged: (lista) => setState(
              () => selectedFileFotocopiaSimpleCedulaSolicitanteList = lista,
            ),
            ayuda: "Seleccionar archivo desde la Galería o la Cámara",
            theme: theme,
          ),
        ],
      ),
    );
  }
}
