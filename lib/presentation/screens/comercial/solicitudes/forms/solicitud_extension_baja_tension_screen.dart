import 'package:flutter/material.dart';
import 'package:form/config/constantes.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/infrastructure/infrastructure.dart';
import 'package:form/model/archivo_adjunto_model.dart';
import 'package:form/model/comercial/solicitudes/solicitud_abastecimiento_model.dart';
import 'package:form/presentation/components/common/UI/custom_card.dart';
import 'package:form/presentation/components/common/UI/custom_phone_field.dart';
import 'package:form/presentation/components/common/custom_show_dialog.dart';
import 'package:form/presentation/components/common/custom_text.dart';
import 'package:form/presentation/components/common/inputtext_custom.dart';
import 'package:form/presentation/components/common/map_selector_inline.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:form/repositories/repositories.dart';
import 'package:form/utils/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SolicitudExtencionBajaTension extends StatefulWidget {
  const SolicitudExtencionBajaTension({super.key});

  @override
  State<SolicitudExtencionBajaTension> createState() =>
      _SolicitudExtencionBajaTensionState();
}

class _SolicitudExtencionBajaTensionState
    extends State<SolicitudExtencionBajaTension> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoadingSolicitud = false;

  final titularNombresController = TextEditingController();
  final titularApellidosController = TextEditingController();
  final titularNumeroDcumentoController = TextEditingController();
  final numeroTelefonoController = TextEditingController();
  final correoController = TextEditingController();

  LatLng? ubicacion;
  bool showMap = false;

  // Archivos adjuntos
  List<ArchivoAdjunto> selectedFileSolicitudList = [];
  List<ArchivoAdjunto> selectedFileFotocopiaAutenticadaList = [];
  List<ArchivoAdjunto> selectedFileFotocopiaSimpleCedulaSolicitanteList = [];
  List<ArchivoAdjunto> selectedFileCopiaSimpleCarnetElectricistaList = [];
  List<ArchivoAdjunto> selectedFileOtrosDocumentosList = [];

  dynamic solicitudAbastecimientoResult;

  void _mostrarMapa() {
    setState(() {
      showMap = true;
    });
  }

  
  void limpiarTodo() {
    titularNombresController.clear();
    titularApellidosController.clear();
    titularNumeroDcumentoController.clear();
    numeroTelefonoController.clear();
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

    setState(() => _isLoadingSolicitud = true);

    try {
      final result = await _fecthSolicitudAlumbradoPublico();

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
        solicitudAbastecimientoResult = result.resultado;
      });

      /*CustomSnackbar.show(
        context,
        message: "Simulacion Correcta.",
        type: MessageType.success,
      );*/
      limpiarTodo();

      DialogHelper.showMessage(
        context,
        MessageType.success,
        'Éxito',
        result.mensaje!,
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

  Future<SolicitudAbastecimientoResponse>
  _fecthSolicitudAlumbradoPublico() async {
    final repo = SolicitudAbastecimientoRepositoryImpl(
      SolicitudAbastecimientoDatasourceImp(MiAndeApi()),
    );

    return await repo.getSolicitudAbastecimiento(
      titularNombresController.text,
      titularApellidosController.text,
      titularNumeroDcumentoController.text,
      numeroTelefonoController.text,
      correoController.text,
      "6",
      selectedFileSolicitudList,
      selectedFileFotocopiaAutenticadaList,
      selectedFileFotocopiaSimpleCedulaSolicitanteList,
      selectedFileCopiaSimpleCarnetElectricistaList,
      selectedFileOtrosDocumentosList,
      ubicacion,
      "",
      "",
      ""
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Solicitud de extensión de \nlínea en Baja Tensión.",
          textAlign: TextAlign.center,
        ),
      ),
      endDrawer: CustomDrawer(),
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
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 24),

                InputTextCustom(
                  labelText: "Nombre del Titular",
                  controller: titularNombresController,

                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Ingrese Nombre del Titular'
                      : null,
                ),
                const SizedBox(height: 24),

                InputTextCustom(
                  labelText: "Apellido del Titular",
                  controller: titularApellidosController,

                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Ingrese Apellido del Titular'
                      : null,
                ),
                const SizedBox(height: 24),

                InputTextCustom(
                  labelText: "Número de Documento del Titular",
                  controller: titularNumeroDcumentoController,

                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Ingrese Número de Documento del Titular'
                      : null,
                ),
                const SizedBox(height: 24),

                CustomPhoneField(
                  controller: numeroTelefonoController,
                  label: 'Número de Celular del Titular',
                  onChanged: (v) {},
                  required: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 24),

                InputTextCustom(
                  labelText: "Correo del Titular",
                  controller: correoController,

                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Ingrese Correo del Titular'
                      : null,
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
                        "Formulario de Solicitud de extensión de línea en Baja Tensión.",
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.clip,
                      ),
                      const CustomText(
                        '1) Descargar formulario y completar.',
                        fontWeight: FontWeight.bold,
                      ),
                      TextButton(
                        onPressed: () =>
                            lanzarUrl('URL_SOLICITUD_EXTENSON_BAJA_TENSION'),
                        child: const Text(
                          "Descargar Formulario de Solicitud de extensión de línea en Baja Tensión.",
                        ),
                      ),
                      const CustomText(
                        '2) Adjuntar como documento de respaldo.',
                      ),
                    ],
                  ),
                ),

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

                buildMediaCard(
                  title: "a) Solicitud de extensión de línea en Baja Tensión.",
                  files: selectedFileSolicitudList,
                  onChanged: (lista) =>
                      setState(() => selectedFileSolicitudList = lista),
                  ayuda: "Seleccionar archivo desde la Galería o la Cámara",
                  theme: theme,
                ),

                buildMediaCard(
                  title: "b) Fotocopia de cedula simple de los firmantes.",
                  files: selectedFileFotocopiaSimpleCedulaSolicitanteList,
                  onChanged: (lista) => setState(
                    () => selectedFileFotocopiaSimpleCedulaSolicitanteList =
                        lista,
                  ),
                  ayuda: "Seleccionar archivo desde la Galería o la Cámara",
                  theme: theme,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
