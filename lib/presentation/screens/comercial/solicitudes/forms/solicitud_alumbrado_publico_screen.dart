import 'package:flutter/material.dart';
import 'package:form/model/archivo_adjunto_model.dart';
import 'package:form/presentation/components/common/UI/custom_card.dart';
import 'package:form/presentation/components/common/custom_text.dart';
import 'package:form/presentation/components/common/inputtext_custom.dart';
import 'package:form/presentation/components/common/map_selector_inline.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:form/utils/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SolicitudAlumbradoPublico extends StatefulWidget {
  const SolicitudAlumbradoPublico({super.key});

  @override
  State<SolicitudAlumbradoPublico> createState() =>
      _SolicitudAlumbradoPublicoState();
}

class _SolicitudAlumbradoPublicoState extends State<SolicitudAlumbradoPublico> {
  final titularNombresController = TextEditingController();
  final titularApellidosController = TextEditingController();
  final numeroTelefonoController = TextEditingController();
  final correoController = TextEditingController();

  // Ubicación
  LatLng? ubicacion;
  bool showMap = false;

  // Archivos adjuntos
  List<ArchivoAdjunto> selectedFileSolicitudList = [];

  final _formKey = GlobalKey<FormState>();
  bool _isLoadingSolicitud = false;

  void _mostrarMapa() {
    setState(() {
      showMap = true;
    });
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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text("Solicitud Instalacion \nAlumbrado Publico")),
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
                //CustomCard(child: CustomText("Solicitud para Instalación de Alumbrado Público.")),
                const SizedBox(height: 24),

                InputTextCustom(
                  labelText: "Titular Nombres",
                  controller: titularNombresController,

                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Ingrese Nombre del Titular'
                      : null,
                ),
                const SizedBox(height: 24),

                InputTextCustom(
                  labelText: "Titular Apellidos",
                  controller: titularApellidosController,

                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Ingrese Apellido del Titular'
                      : null,
                ),
                const SizedBox(height: 24),

                InputTextCustom(
                  labelText: "Titular Número de Teléfono",
                  controller: numeroTelefonoController,

                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Ingrese Número de Teléfono del Titular'
                      : null,
                ),
                const SizedBox(height: 24),

                InputTextCustom(
                  labelText: "Titular correo",
                  controller: correoController,

                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Ingrese correo del Titular'
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
                        "Formulario para instalaccion de Solicitud de Abastecimiento",
                        fontWeight: FontWeight.bold,
                      ),
                      const CustomText(
                        '1) Descargar formulario y completar.',
                        fontWeight: FontWeight.bold,
                      ),
                      TextButton(
                        onPressed: () =>
                            lanzarUrl('URL_SOLICITUD_ALUMBRADO_PUBLICO'),
                        child: const Text(
                          "Descargar Formulario de Solicitud para Instalación de alumbrado público.",
                        ),
                      ),
                      const CustomText(
                        '2) Adjuntar como documento de respaldo.',
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
                  title:
                      "a) Solicitud para Instalación de alumbrado público.",
                  files: selectedFileSolicitudList,
                  onChanged: (lista) =>
                      setState(() => selectedFileSolicitudList = lista),
                  ayuda: "Seleccionar archivo desde la Galería o la Cámara",
                  theme: theme,
                ),

                   buildMediaCard(
                  title:
                      "a) Fotocopia de cedula simple de los firmantes.",
                  files: selectedFileSolicitudList,
                  onChanged: (lista) =>
                      setState(() => selectedFileSolicitudList = lista),
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
