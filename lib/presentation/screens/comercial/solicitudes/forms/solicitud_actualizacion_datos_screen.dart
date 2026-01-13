import 'package:flutter/material.dart';
import 'package:form/config/constantes.dart';
import 'package:form/config/tipo_tramite_model.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/infrastructure/infrastructure.dart';
import 'package:form/model/archivo_adjunto_model.dart';
import 'package:form/model/consulta_documento_model.dart';
import 'package:form/model/model.dart';
import 'package:form/presentation/auth/login_screen.dart';
import 'package:form/presentation/components/common.dart';
import 'package:form/presentation/components/common/UI/custom_card.dart';
import 'package:form/presentation/components/common/UI/custom_comment.dart';
import 'package:form/presentation/components/common/UI/custom_phone_field.dart';
import 'package:form/presentation/components/common/custom_show_dialog.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:form/repositories/repositories.dart';
import 'package:form/utils/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SolicitudActualizacionDatosScreen extends StatefulWidget {
  const SolicitudActualizacionDatosScreen({super.key});

  @override
  State<SolicitudActualizacionDatosScreen> createState() =>
      _SolicitudActualizacionDatosScreenState();
}

final formKey = GlobalKey<FormState>();
bool _isLoadingSolicitud = false;

class _SolicitudActualizacionDatosScreenState
    extends State<SolicitudActualizacionDatosScreen> {
  final List<DropdownItem> dropDownItems = [
    DropdownItem(id: 'TD001', name: 'C.I. Civil'),
    DropdownItem(id: 'TD002', name: 'RUC'),
    //DropdownItem(id: 'TD004', name: 'Pasaporte'),
  ];

  bool isLoadingConsultaDocumento = false;
  final TextEditingController nombreObtenido = TextEditingController();
  final TextEditingController apellidoObtenido = TextEditingController();

  DropdownItem? selectedTipoDocumento;
  final _numeroDocumentoFieldKey = GlobalKey<FormFieldState<String>>();

  final FocusNode _focusNode = FocusNode();

  late ConsultaDocumentoResultado consultaDocumentoResponse;

  final TextEditingController numeroDocumentoController =
      TextEditingController();

  final TextEditingController numeroTelefonoCelularController =
      TextEditingController();

  final TextEditingController correoController = TextEditingController();

  LatLng? ubicacion;

  dynamic solicitudAbastecimientoResult;

  // Archivos adjuntos
  List<ArchivoAdjunto> selectedFileSolicitudList = [];
  List<ArchivoAdjunto> selectedFileFotocopiaAutenticadaList = [];
  List<ArchivoAdjunto> selectedFileFotocopiaSimpleCedulaSolicitanteList = [];
  List<ArchivoAdjunto> selectedFileCopiaSimpleCarnetElectricistaList = [];
  List<ArchivoAdjunto> selectedFileOtrosDocumentosList = [];

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
      print("Error al consultar Documento: $e");
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

  
  void limpiarTodo() {
    numeroTelefonoCelularController.clear();
    numeroDocumentoController.clear();
    nombreObtenido.text = '';
    apellidoObtenido.text = '';
    correoController.clear();

    setState(() {    
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

  Future<SolicitudAbastecimientoResponse>
  _fecthSolicitudActualizacionDatos() async {
    final repo = SolicitudAbastecimientoRepositoryImpl(
      SolicitudAbastecimientoDatasourceImp(MiAndeApi()),
    );

    return await repo.getSolicitudAbastecimiento(
      nombreObtenido.text,
      apellidoObtenido.text,
      selectedTipoDocumento?.id,
      numeroDocumentoController.text,
      numeroTelefonoCelularController.text,
      correoController.text,
      "10",
      selectedFileSolicitudList,
      selectedFileFotocopiaAutenticadaList,
      selectedFileFotocopiaSimpleCedulaSolicitanteList,
      selectedFileCopiaSimpleCarnetElectricistaList,
      selectedFileOtrosDocumentosList,
      ubicacion,
      "",
      "",
      "",
    );
  }

  void _enviarFormulario() async {
    if (_isLoadingSolicitud) return;

    if (!formKey.currentState!.validate()) {
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

    setState(() => _isLoadingSolicitud = true);

    try {
      final result = await _fecthSolicitudActualizacionDatos();

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text("Solicitud de Actualización \nde Datos.")),
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
    return Column(
      children: [
        CustomComment(
          text: "Actualización de datos de la factura de Energía Eléctrica.",
        ),
        DropdownButtonFormField<DropdownItem>(
          initialValue: selectedTipoDocumento,
          hint: const Text("Seleccionar Tipo de Documento"),
          items: dropDownItems
              .map(
                (item) => DropdownMenuItem(value: item, child: Text(item.name)),
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
                    CustomText("Apellido(s) del Titular", color: Colors.green),
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
          title:
              "a) Adjuntar fotografía del documento (Cédula de Identidad, Registro Único del Contribuyente (RUC)).",
          files: selectedFileSolicitudList,
          onChanged: (lista) =>
              setState(() => selectedFileSolicitudList = lista),
          ayuda: "Seleccionar archivo desde la Galería o la Cámara",
          theme: theme,
        ),

        buildMediaCard(
          title:
              "b) Adjuntar fotografía de la factura de energía eléctrica. (En caso de poseer varios NIS será suficiente adjuntar la fotografía de al menos una).",
          files: selectedFileFotocopiaSimpleCedulaSolicitanteList,
          onChanged: (lista) => setState(
            () => selectedFileFotocopiaSimpleCedulaSolicitanteList = lista,
          ),
          ayuda: "Seleccionar archivo desde la Galería o la Cámara",
          theme: theme,
        ),
      ],
    );
  }
}
