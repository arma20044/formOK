import 'package:flutter/material.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/infrastructure/infrastructure.dart';
import 'package:form/model/model.dart';
import 'package:form/presentation/components/common.dart';
import 'package:form/presentation/components/common/UI/custom_card.dart';
import 'package:form/presentation/components/common/UI/custom_comment.dart';
import 'package:form/presentation/components/common/UI/custom_dialog.dart';
import 'package:form/presentation/components/common/UI/custom_phone_field.dart';
import 'package:form/presentation/components/common/custom_map_modal.dart';
import 'package:form/presentation/components/common/map_selector_inline.dart';
import 'package:form/presentation/components/common/media_selector.list.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:form/repositories/repositories.dart';
import 'package:form/utils/utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SolicitudAbastecimientoScreen extends StatefulWidget {
  const SolicitudAbastecimientoScreen({super.key});

  @override
  State<SolicitudAbastecimientoScreen> createState() =>
      _SolicitudAbastecimientoScreenState();
}

class _SolicitudAbastecimientoScreenState
    extends State<SolicitudAbastecimientoScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoadingSolicitud = false;

  // Controllers
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final numeroDocumentoController = TextEditingController();
  final numeroCelularController = TextEditingController();
  final correoController = TextEditingController();

  // Ubicación
  LatLng? ubicacion;
  bool showMap = false;

  // Archivos adjuntos
  List<ArchivoAdjunto> selectedFileSolicitudList = [];
  List<ArchivoAdjunto> selectedFileFotocopiaAutenticadaList = [];
  List<ArchivoAdjunto> selectedFileFotocopiaSimpleCedulaSolicitanteList = [];
  List<ArchivoAdjunto> selectedFileCopiaSimpleCarnetElectricistaList = [];
  List<ArchivoAdjunto> selectedFileOtrosDocumentosList = [];

  // ------------------------- FUNCIONES -------------------------

  Future<Position?> determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  void _openMapModalWithPermission() async {
    Position? position = await determinePosition();
    LatLng initialPosition = position != null
        ? LatLng(position.latitude, position.longitude)
        : const LatLng(-25.2637, -57.5759);

    LatLng? selectedLocation = await showDialog<LatLng>(
      context: context,
      builder: (context) => CustomMapModal(initialPosition: initialPosition),
    );

    if (selectedLocation != null) {
      setState(() => ubicacion = selectedLocation);
    }
  }

  void limpiarTodo() {
    nombreController.clear();
    apellidoController.clear();
    numeroDocumentoController.clear();
    numeroCelularController.clear();
    correoController.clear();

    setState(() {
      ubicacion = null;
      selectedFileSolicitudList.clear();
      selectedFileFotocopiaAutenticadaList.clear();
      selectedFileFotocopiaSimpleCedulaSolicitanteList.clear();
      selectedFileCopiaSimpleCarnetElectricistaList.clear();
      selectedFileOtrosDocumentosList.clear();
      _formKey.currentState?.reset();
    });

    FocusScope.of(context).unfocus();
  }

  void _enviarFormulario() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese los campos obligatorios')),
      );
      return;
    }

    if (selectedFileSolicitudList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe adjuntar archivo en el punto a).')),
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
        nombreController.text,
        apellidoController.text,
        numeroDocumentoController.text,
        numeroCelularController.text,
        correoController.text,
        '1',
        selectedFileSolicitudList,
        selectedFileFotocopiaAutenticadaList,
        selectedFileFotocopiaSimpleCedulaSolicitanteList,
        selectedFileCopiaSimpleCarnetElectricistaList,
        selectedFileOtrosDocumentosList,
        null
      );

      if (!mounted) return;

      if (result.mensaje == null ||
          !result.mensaje!.contains("Se ha creado exitosamente")) {
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
        Navigator.of(context).pop();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al enviar la solicitud")),
      );
    } finally {
      setState(() => _isLoadingSolicitud = false);
    }
  }

  void _mostrarMapa() {
    setState(() {
      showMap = true;
    });
  }
  // ------------------------- BUILD -------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text("Solicitud de \nAbastecimiento de Energía",textAlign: TextAlign.center,),
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
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // ------------------------- INTRO -------------------------
                const CustomComment(
                  text:
                      "Solicitud para nueva conexión en Baja Tensión (hasta 40 kW). Solicitud de abastecimiento de Energía Eléctrica, División de Instalación, Cambio de Sitio de Medidor, Reposición / Reconexión, Aumento de Carga, Reducción de Carga, Cambio de Nombre, Cambio de categoría Tarifaria.",
                ),
                const SizedBox(height: 24),

                // ------------------------- CAMPOS -------------------------
                TextFormField(
                  controller: nombreController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: 'Nombre(s) del Titular',
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Ingrese Nombre(s)' : null,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: apellidoController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: 'Apellido(s) del Titular',
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Ingrese Apellido(s)' : null,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: numeroDocumentoController,
                  decoration: const InputDecoration(
                    labelText: 'Número de Documento del Titular',
                  ),
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Ingrese Número de Documento'
                      : null,
                ),
                const SizedBox(height: 24),
                CustomPhoneField(
                  controller: numeroCelularController,
                  label: 'Número de Celular del Titular',
                  onChanged: (v) {},
                  required: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: correoController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Correo del Titular',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Ingrese Correo';
                    if (!emailRegex.hasMatch(v))
                      return 'Ingrese un correo válido';
                    return null;
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

                // ------------------------- FORMULARIO DESCARGA -------------------------
                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        "Formulario de Solicitud de Abastecimiento",
                        fontWeight: FontWeight.bold,
                      ),
                      const CustomText(
                        '1) Descargar formulario y completar.',
                        fontWeight: FontWeight.bold,
                      ),
                      TextButton(
                        onPressed: () =>
                            lanzarUrl('URL_SOLICITUD_ABASTECIMIENTO'),
                        child: const Text(
                          "Descargar Formulario de Solicitud de Abastecimiento.",
                        ),
                      ),
                      const CustomText(
                        'Solicitud de abastecimiento de Energía Eléctrica, División de Instalación, Cambio de Sitio de Medidor, Reposición / Reconexión, Aumento de Carga, Reducción de Carga, Cambio de Nombre, Cambio de categoría Tarifaria.',
                        overflow: TextOverflow.clip,
                      ),
                      const CustomText(
                        '2) Adjuntar como documento de respaldo.',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ------------------------- PASO 2 -------------------------
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
                      CustomText(
                        '2) El tamaño máximo de cada archivo es de 10 MB.',
                      ),
                      CustomText('3) Los documentos deben estar legibles.'),
                      CustomText(
                        '4) Mientras el tamaño de archivo sea más grande, la transacción tardará más y podría cortarse por condiciones de internet fluctuantes.',
                        overflow: TextOverflow.clip,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ------------------------- ADJUNTOS a) a e) -------------------------
                buildMediaCard(
                  title:
                      "a) Solicitud de Abastecimiento de Energía Eléctrica (SAEE)",
                  files: selectedFileSolicitudList,
                  onChanged: (lista) =>
                      setState(() => selectedFileSolicitudList = lista),
                  ayuda: "Seleccionar archivo desde la Galería o la Cámara",
                  theme: theme,
                ),
                const SizedBox(height: 24),
                buildMediaCard(
                  title:
                      "b) Fotocopia Autenticada por Escribanía del título de Propiedad o equivalente",
                  files: selectedFileFotocopiaAutenticadaList,
                  onChanged: (lista) => setState(
                    () => selectedFileFotocopiaAutenticadaList = lista,
                  ),
                  ayuda:
                      "(Contrato Privado de Compra /Venta con certificación de firma, Sentencia Declaratoria de adjudicación del inmueble) o Constancia de la Inmobiliaria (original) o Constancia Municipal (original).",
                  theme: theme,
                ),
                const SizedBox(height: 24),
                buildMediaCard(
                  title: "c) Copia simple de Cédula Identidad del Solicitante",
                  files: selectedFileFotocopiaSimpleCedulaSolicitanteList,
                  onChanged: (lista) => setState(
                    () => selectedFileFotocopiaSimpleCedulaSolicitanteList =
                        lista,
                  ),
                  ayuda: "Seleccionar archivo desde la Galería o la Cámara.",
                  theme: theme,
                ),
                const SizedBox(height: 24),
                buildMediaCard(
                  title:
                      "d) Copia simple de Carnet del Electricista Matriculado en ANDE",
                  files: selectedFileCopiaSimpleCarnetElectricistaList,
                  onChanged: (lista) => setState(
                    () => selectedFileCopiaSimpleCarnetElectricistaList = lista,
                  ),
                  ayuda: "Seleccionar archivo desde la Galería o la Cámara.",
                  theme: theme,
                ),
                const SizedBox(height: 24),
                buildMediaCard(
                  title: "e) Otros documentos",
                  files: selectedFileOtrosDocumentosList,
                  onChanged: (lista) =>
                      setState(() => selectedFileOtrosDocumentosList = lista),
                  ayuda: "Seleccionar archivo desde la Galería o la Cámara.",
                  theme: theme,
                ),
                const SizedBox(height: 24),

                // ------------------------- ATENCIÓN -------------------------
                CustomCard(
                  child: Column(
                    children: const [
                      CustomText("ATENCIÓN", fontWeight: FontWeight.bold),
                      CustomText(
                        'Los documentos remitidos via web deberán ser entregados al técnico al momento de realizarse la conexión.',
                        overflow: TextOverflow.clip,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ------------------------- INSTRUCCIONES FINALES -------------------------
                CustomCard(
                  child: Column(
                    children: const [
                      CustomText(
                        '- Para conexiones nuevas en baja tensión adjuntar documentos indicados en los ítems a, b, c, d.- Para división de instalación adjuntar documentos indicados en los ítems a, c, d.- Para actualización de nombre adjuntar documentos indicados en los ítems a, b, c.- Para aumento o reducción de carga adjuntar documentos indicados en los ítems a, c, d.- Para cambio de sitio de medidor adjuntar documentos indicados en los ítems a, c, d.- Para reposición de medidor adjuntar documentos indicados en los ítems a, c, d.',
                        overflow: TextOverflow.clip,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ------------------------- BOTÓN -------------------------
              ],
            ),
          ),
        ),
      ),
    );
  }


}
