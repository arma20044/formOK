import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/infrastructure/infrastructure.dart';
import 'package:form/model/model.dart';
import 'package:form/presentation/components/common.dart';
import 'package:form/presentation/components/common/UI/custom_card.dart';
import 'package:form/presentation/components/common/UI/custom_comment.dart';
import 'package:form/presentation/components/common/UI/custom_dialog.dart';
import 'package:form/presentation/components/common/custom_map_modal.dart';
import 'package:form/presentation/components/common/media_selector.dart';
import 'package:form/presentation/components/common/media_selector.list.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:form/repositories/repositories.dart';
import 'package:form/utils/utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class SolicitudAbastecimientoScreen extends StatefulWidget {
  const SolicitudAbastecimientoScreen({super.key});

  @override
  State<SolicitudAbastecimientoScreen> createState() =>
      _SolicitudAbastecimientoScreenState();
}

void _openMapModal(BuildContext context) async {
  LatLng initialPosition = LatLng(-25.2637, -57.5759); // Ejemplo: Asunción
  LatLng? selectedLocation = await showDialog<LatLng>(
    context: context,
    builder: (context) => CustomMapModal(initialPosition: initialPosition),
  );

  if (selectedLocation != null) {
    print(
      'Ubicación seleccionada: ${selectedLocation.latitude}, ${selectedLocation.longitude}',
    );
  }

  if (selectedLocation != null) {
    // Aquí ya tenés latitud y longitud
    double lat = selectedLocation.latitude;
    double lon = selectedLocation.longitude;
    print('Latitud: $lat, Longitud: $lon');
  }
}

class _SolicitudAbastecimientoScreenState
    extends State<SolicitudAbastecimientoScreen> {
  late final ValueChanged<ArchivoAdjunto?> onChanged;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final numeroDocumentoController = TextEditingController();
  final numeroCelularController = TextEditingController();
  final correoController = TextEditingController();

  LatLng? ubicacion;

  final ImagePicker _picker = ImagePicker();
  Uint8List? _videoThumbnail;

  Future<Position?> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si el GPS está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Podés mostrar un diálogo o notificación para que lo habilite
      return null;
    }

    // Verificar permisos
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permiso denegado
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permiso denegado permanentemente
      return null;
    }

    // Obtener la ubicación actual
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  void _openMapModalWithPermission(BuildContext context) async {
    Position? position = await determinePosition();

    LatLng initialPosition;
    if (position != null) {
      initialPosition = LatLng(position.latitude, position.longitude);
    } else {
      // Posición por defecto si el GPS no está disponible
      initialPosition = LatLng(-25.2637, -57.5759); // Asunción
    }

    LatLng? selectedLocation = await showDialog<LatLng>(
      context: context,
      builder: (context) => CustomMapModal(initialPosition: initialPosition),
    );

    if (selectedLocation != null) {
      print(
        'Latitud: ${selectedLocation.latitude}, Longitud: ${selectedLocation.longitude}',
      );
      setState(() => ubicacion = selectedLocation);
    }
  }

  ArchivoAdjunto? selectedFileSolicitud;
  ArchivoAdjunto? selectedFileFotocopiaAutenticada;
  ArchivoAdjunto? selectedFileFotocopiaSimpleCedulaSolicitante;
  ArchivoAdjunto? selectedFileCopiaSimpleCarnetElectricista;
  ArchivoAdjunto? selectedFileOtrosDocumentos;

  List<ArchivoAdjunto>? selectedFileSolicitudList;
  List<ArchivoAdjunto>? selectedFileFotocopiaAutenticadaList;

  String fileCaption = 'asdas';

  bool _isLoadingSolicitud = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      endDrawer: CustomDrawer(),
      appBar: AppBar(title: Text("Solicitud de Abastecimiento de Energía")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomComment(
                  text:
                      "Solicitud para nueva conexión en Baja Tensión (hasta 40 kW). Solicitud de abastecimiento de Energía Eléctrica, División de Instalación, Cambio de Sitio de Medidor, Reposición / Reconexión, Aumento de Carga, Reducción de Carga, Cambio de Nombre, Cambio de categoría Tarifaria.",
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: nombreController,
                  decoration: InputDecoration(
                    labelText: 'Nombre(s) del Titular',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese Nombre(s) del Titular';
                    }
                    return null;
                  },
                  //enabled: !isLoading,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: apellidoController,
                  decoration: InputDecoration(
                    labelText: 'Apellido(s) del Titular',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese Apellido(s) del Titular';
                    }
                    return null;
                  },
                  //enabled: !isLoading,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: numeroDocumentoController,
                  decoration: InputDecoration(
                    labelText: 'Número de Documento del Titular',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese Número de Documento del Titular';
                    }
                    return null;
                  },
                  //enabled: !isLoading,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: numeroCelularController,
                  decoration: InputDecoration(
                    labelText: 'Número de Celular del Titular',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese Número de Celular del Titular';
                    }
                    return null;
                  },
                  //enabled: !isLoading,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: correoController,
                  decoration: InputDecoration(labelText: 'Correo del Titular'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese Correo del Titular';
                    }
                    return null;
                  },
                  //enabled: !isLoading,
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ), // 👈 mejora el alto
                    ),
                    onPressed: () {
                      _openMapModalWithPermission(context);
                    },
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // 👈 centra ícono + texto
                      mainAxisSize: MainAxisSize
                          .min, // 👈 evita que Row se expanda innecesariamente
                      children: const [
                        Icon(Icons.location_on, size: 25),
                        SizedBox(width: 8),
                        CustomText("Agregar punto en Mapa"),
                      ],
                    ),
                  ),
                ),

                Text(ubicacion?.toString() ?? ""),

                const SizedBox(height: 8),

                CustomCard(
                  child: Column(
                    children: [
                      CustomText(
                        "Formulario de Solicitud de Abastecimiento",
                        fontWeight: FontWeight.bold,
                      ),
                      CustomText(
                        '1) Descargar formulario y completar.',
                        fontWeight: FontWeight.bold,
                      ),
                      TextButton(
                        onPressed: () {
                          lanzarUrl('URL_SOLICITUD_ABASTECIMIENTO');
                        },
                        child: Text(
                          "Descargar Formulario de Solicitud de Abastecimiento.",
                        ),
                      ),
                      CustomText(
                        'Solicitud de abastecimiento de Energía Eléctrica, División de Instalación, Cambio de Sitio de Medidor, Reposición / Reconexión, Aumento de Carga, Reducción de Carga, Cambio de Nombre, Cambio de categoría Tarifaria.',
                        overflow: TextOverflow.clip,
                      ),
                      CustomText('2) Adjuntar como documento de respaldo.'),
                    ],
                  ),
                ),
                CustomCard(
                  child: Column(
                    children: [
                      CustomText(
                        'PASO 2: Adjuntar Documentos requeridos para poder tratar la solicitud, leer las condiciones a continuación:',
                        overflow: TextOverflow.clip,
                        fontWeight: FontWeight.bold,
                      ),
                      CustomText(
                        '1) Se puede adjuntar documentos en formato PDF o imágenes JPG, JPEG, PNG.',
                        overflow: TextOverflow.clip,
                      ),
                      CustomText(
                        '2) El tamaño máximo de cada archivo es de 10 MB.',
                        overflow: TextOverflow.clip,
                      ),
                      CustomText(
                        '3) Los documentos deben estar legibles.',
                        overflow: TextOverflow.clip,
                      ),
                      CustomText(
                        '4) Mientras el tamaño de archivo sea más grande, la transacción tardará más y podría cortarse por condiciones de internet fluctuantes.',
                        overflow: TextOverflow.clip,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        "a) Solicitud de Abastecimiento de Energía Eléctrica (SAEE)",
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.clip,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 8),

                      MediaSelectorList(
                        maxAdjuntos: 2,
                        ayuda:
                            "Seleccionar archivo desde la Galería o la Cámara",
                        type: MediaType.foto,
                       files: selectedFileSolicitudList ?? [],
                        onChanged: (archivo) {
                          setState(() {
                            selectedFileSolicitudList = archivo;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        "b) Fotocopia Autenticada por Escribanía del título de Propiedad o equivalente",
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.clip,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 8),
                      MediaSelectorList(
                        maxAdjuntos: 2,
                        files: selectedFileFotocopiaAutenticadaList ?? [],
                        ayuda:
                            "(Contrato Privado de Compra /Venta con certificación de firma, Sentencia Declaratoria de adjudicación del inmueble) o Constancia de la Inmobiliaria (original) o Constancia Municipal (original).",
                        type: MediaType.foto,

                        onChanged: (archivo) {
                          setState(() {
                            selectedFileFotocopiaAutenticadaList = archivo;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        "c) Copia simple de Cédula Identidad del Solicitante",
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.clip,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 8),
                      MediaSelector(
                        ayuda:
                            "Seleccionar archivo desde la Galería o la Cámara.",
                        type: MediaType.foto,
                        file: selectedFileSolicitud,
                        onChanged: (archivo) {
                          setState(() {
                            selectedFileFotocopiaSimpleCedulaSolicitante =
                                archivo;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        "d) Copia simple de Carnet del Electricista Matriculado en ANDE",
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.clip,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 8),
                      MediaSelector(
                        ayuda:
                            "Seleccionar archivo desde la Galería o la Cámara.",
                        type: MediaType.foto,
                        file: selectedFileSolicitud,
                        onChanged: (archivo) {
                          setState(() {
                            selectedFileCopiaSimpleCarnetElectricista = archivo;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        "e) Otros documentose",
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.clip,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 8),
                      MediaSelector(
                        ayuda:
                            "Seleccionar archivo desde la Galería o la Cámara.",
                        type: MediaType.foto,
                        file: selectedFileSolicitud,
                        onChanged: (archivo) {
                          setState(() {
                            selectedFileOtrosDocumentos = archivo;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),
                CustomCard(
                  child: Column(
                    children: [
                      CustomText("ATENCIÓN", fontWeight: FontWeight.bold),
                      CustomText(
                        'Los documentos remitidos via web deberán ser entregados al técnico al momento de realizarse la conexión.',
                        overflow: TextOverflow.clip,
                      ),
                    ],
                  ),
                ),

                /*                 SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : () => _enviarFormulario(),
                    child: Text("Enviar Solicitud"),
                  ),
                ), */
                const SizedBox(height: 8),
                CustomCard(
                  child: Column(
                    children: [
                      CustomText(
                        '- Para conexiones nuevas en baja tensión adjuntar documentos indicados en los ítems a, b, c, d.- Para división de instalación adjuntar documentos indicados en los ítems a, c, d.- Para actualización de nombre adjuntar documentos indicados en los ítems a, b, c.- Para aumento o reducción de carga adjuntar documentos indicados en los ítems a, c, d.- Para cambio de sitio de medidor adjuntar documentos indicados en los ítems a, c, d.- Para reposición de medidor adjuntar documentos indicados en los ítems a, c, d.',
                        overflow: TextOverflow.clip,
                      ),
                    ],
                  ),
                ),
                //const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _isLoadingSolicitud ? null : _enviarFormulario,
          child: _isLoadingSolicitud
              ? const SizedBox(child: CircularProgressIndicator())
              : Text("Enviar Solicitud"),
        ),
      ),
    );
  }

  void _enviarFormulario() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ingrese todos los campos')));
      return;
    }

    if (selectedFileSolicitud == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Debe adjuntar archivo.')));
      return;
    }

    SolicitudAbastecimientoResponse result =
        await _fecthSolicitudAbastecimiento();
    if (!mounted) return;
    if (!result.mensaje!.contains("Se ha creado exitosamente")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.errorValList == null
                ? result.errorValList![0]
                : result.mensaje,
          ),
        ),
      );
      return;
    }

    //limpiarTodo();

    showCustomDialog(
      context: context,
      message: result.mensaje!,
      showCopyButton: false,
      title: "Éxito.",
      type: DialogType.success,
    );
  }

  Future<SolicitudAbastecimientoResponse>
  _fecthSolicitudAbastecimiento() async {
    try {
      final repoSolicitudAbastecimiento = SolicitudAbastecimientoRepositoryImpl(
        SolicitudAbastecimientoDatasourceImp(MiAndeApi()),
      );

      setState(() {
        _isLoadingSolicitud = true;
      });

      final solicitudAbastecimientoResponse = await repoSolicitudAbastecimiento
          .getSolicitudAbastecimiento(
            nombreController.text,
            apellidoController.text,
            numeroDocumentoController.text,
            numeroCelularController.text,
            correoController.text,
            '1',
            selectedFileSolicitud,
            selectedFileFotocopiaAutenticada,
            selectedFileFotocopiaSimpleCedulaSolicitante,
            selectedFileCopiaSimpleCarnetElectricista,
            selectedFileOtrosDocumentos,
          );

      return solicitudAbastecimientoResponse;
    } catch (e) {
      throw Exception();
    } finally {
      setState(() {
        _isLoadingSolicitud = false;
      });
    }
  }
}
