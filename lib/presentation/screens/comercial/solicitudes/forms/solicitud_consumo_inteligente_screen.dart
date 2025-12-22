import 'package:flutter/material.dart';
import 'package:form/config/constantes.dart';
import 'package:form/config/tipo_tramite_model.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/infrastructure/infrastructure.dart';
import 'package:form/model/archivo_adjunto_model.dart';
import 'package:form/model/comercial/solicitudes/solicitud_abastecimiento_model.dart';
import 'package:form/presentation/components/common/UI/custom_card.dart';
import 'package:form/presentation/components/common/UI/custom_phone_field.dart';
import 'package:form/presentation/components/common/custom_show_dialog.dart';
import 'package:form/presentation/components/common/custom_text.dart';
import 'package:form/presentation/components/common/info_card.dart';
import 'package:form/presentation/components/common/info_card_simple.dart';
import 'package:form/presentation/components/common/inputtext_custom.dart';
import 'package:form/presentation/components/common/otp_verification_widget.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:form/presentation/components/widgets/dropdown_custom.dart';
import 'package:form/repositories/repositories.dart';

class SolicitudConsumoInteligenteScreen extends StatefulWidget {
  const SolicitudConsumoInteligenteScreen({super.key});

  @override
  State<SolicitudConsumoInteligenteScreen> createState() =>
      _SolicitudConsumoInteligenteScreenState();
}

class _SolicitudConsumoInteligenteScreenState
    extends State<SolicitudConsumoInteligenteScreen> {
  final List<ModalModel> listaTipoDocumento = dataTipoDocumentoArray;
  ModalModel? selectedTipoDocumento;

  final List<ModalModel> listaTipoVerificacion = dataTipoVerificacion;
  ModalModel? selectedTipoVerificacion;

  final titularNombresController = TextEditingController();
  final titularApellidosController = TextEditingController();
  final titularNumeroDcumentoController = TextEditingController();
  final numeroTelefonoController = TextEditingController();
  final correoController = TextEditingController();

  bool _isLoadingSolicitud = false;
  final _formKey = GlobalKey<FormState>();

  String? codigoOTPObtenido;
  String? solicitarOTP = 'S';

  // Archivos adjuntos
  List<ArchivoAdjunto> selectedFileSolicitudList = [];
  List<ArchivoAdjunto> selectedFileFotocopiaAutenticadaList = [];
  List<ArchivoAdjunto> selectedFileFotocopiaSimpleCedulaSolicitanteList = [];
  List<ArchivoAdjunto> selectedFileCopiaSimpleCarnetElectricistaList = [];
  List<ArchivoAdjunto> selectedFileOtrosDocumentosList = [];

  dynamic solicitudAbastecimientoResult;

  bool mostrarCargarCodigoOTP = false;

  void limpiarTodo() {
    titularNombresController.clear();
    titularApellidosController.clear();
    titularNumeroDcumentoController.clear();
    numeroTelefonoController.clear();
    correoController.clear();

    setState(() {
      selectedFileSolicitudList.clear();
      selectedFileFotocopiaAutenticadaList.clear();
      selectedFileFotocopiaSimpleCedulaSolicitanteList.clear();
      selectedFileCopiaSimpleCarnetElectricistaList.clear();
      selectedFileOtrosDocumentosList.clear();
      //_formKey.currentState?.reset();
    });

    FocusScope.of(context).unfocus();
  }

  void _enviarFormulario(bool solicitarOTP) async {
    if (_isLoadingSolicitud) return;

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese los campos obligatorios')),
      );
      return;
    }

    setState(() => _isLoadingSolicitud = true);

    try {
      final result = await _fecthSolicitudAlumbradoPublico(solicitarOTP);

       

      if (result.error!) {
        DialogHelper.showMessage(
          context,
          MessageType.error,
          'Error',
          result.errorValList![0],
        );

        setState(() {
          codigoOTPObtenido = "";
          this.solicitarOTP = "N";
        });

        return;
      } else if(solicitarOTP){
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return Container(
              // Este es el widget que se convertirá en el modal
              height: 500,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    OtpInputWidget(
                      isLoading: _isLoadingSolicitud,
                      tipoVerificacion: selectedTipoVerificacion!.id!,
                      phoneNumber: numeroTelefonoController.text!,
                      correo: correoController.text,
                      onSubmit: (otp) {
                        setState(() {
                          codigoOTPObtenido = otp;

                          this.solicitarOTP = 'N';
                        });

                        _enviarFormulario(false);
                        print("Código ingresado: $otp");
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );

        setState(() {
          this.solicitarOTP = 'S';
        });
        mostrarCargarCodigoOTP = true;
        DialogHelper.showMessage(
          context,
          MessageType.success,
          'Éxito',
          selectedTipoVerificacion!.id!.contains("CEL")
              ? "Te enviamos un código a tu celular, favor ingresa para confirmar el registro."
              : "Te enviamos un código a tu correo, favor ingresa para confirmar el registro.",
          //duration: const Duration(seconds: 3),
        );
      }

      setState(() {
        solicitudAbastecimientoResult = result.resultado;
      });

      
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

  Future<SolicitudAbastecimientoResponse> _fecthSolicitudAlumbradoPublico(
    bool solicitarOTP,
  ) async {
    final repo = SolicitudAbastecimientoRepositoryImpl(
      SolicitudAbastecimientoDatasourceImp(MiAndeApi()),
    );

    return await repo.getSolicitudAbastecimiento(
      titularNombresController.text,
      titularApellidosController.text,
      titularNumeroDcumentoController.text,
      numeroTelefonoController.text,
      correoController.text,
      "11",
      selectedFileSolicitudList,
      selectedFileFotocopiaAutenticadaList,
      selectedFileFotocopiaSimpleCedulaSolicitanteList,
      selectedFileCopiaSimpleCarnetElectricistaList,
      selectedFileOtrosDocumentosList,
      null,
      solicitarOTP ? 'S' : 'N',
      codigoOTPObtenido,
      selectedTipoVerificacion?.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text("Solicitud de Consumo \nInteligente")),
      endDrawer: CustomDrawer(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: _isLoadingSolicitud ? null : () => _enviarFormulario(true),
          child: _isLoadingSolicitud
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Enviar Solicitud"),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: CustomCard(
                    backgroundColor: isDarkMode
                        ? Colors.grey[800]
                        : Colors.grey,
                    child: CustomText(
                      "Tarifas por tramos horarios",
                      color: theme.colorScheme.inverseSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                DropdownCustom<ModalModel>(
                  label: "Tipo Documento",
                  items: listaTipoDocumento,
                  value: selectedTipoDocumento,
                  displayBuilder: (b) => b.descripcion!,
                  validator: (val) =>
                      val == null ? "Seleccione un Tipo Documento" : null,
                  onChanged: (val) => {
                    setState(() {
                      selectedTipoDocumento = val;
                    }),
                  },
                ),

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

                DropdownCustom<ModalModel>(
                  label: "Tipo de Verificación",
                  items: listaTipoVerificacion,
                  value: selectedTipoVerificacion,
                  displayBuilder: (b) => b.descripcion!,
                  validator: (val) =>
                      val == null ? "Seleccione un Tipo Verificación" : null,
                  onChanged: (val) =>
                      setState(() => selectedTipoVerificacion = val),
                ),
                const SizedBox(height: 24),

                Visibility(
                  visible: selectedTipoVerificacion != null,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      InfoCardSimple(
                        title:
                            selectedTipoVerificacion != null &&
                                selectedTipoVerificacion!.id != null &&
                                selectedTipoVerificacion!.id!.contains("CEL")
                            ? "Se utilizará para validar la cuenta vía SMS"
                            : "Se utilizará para validar la cuenta vía Correo",
                        subtitle: "",
                        icon: Icons.info,
                        color: Colors.blue,
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
                        'Información sobre "Consumo Inteligente"',
                        overflow: TextOverflow.clip,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 24),

                      CustomText(
                        '1. Para solicitar el cambio de categoría favor marcar en la solicitud dicha opción.',
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.left,
                      ),
                      CustomText(
                        '2. El cambio de categoría es opcional e implica un cambio de hábito en el consumo.',
                        overflow: TextOverflow.clip,
                      ),
                      CustomText(
                        '3. El cambio de categoría no tiene costo si la potencia declarada no tendrá variación.',
                        overflow: TextOverflow.clip,
                      ),
                      CustomText(
                        '4. Los Horarios de punta de carga son:',
                        overflow: TextOverflow.clip,
                        //textAlign: TextAlign.left,
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: CustomText(
                          "   ● Entre los meses de Octubre y Marzo, de lunes a sábado de 12 a 16 horas y de 18 a 22 horas.",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: CustomText(
                          "   ● Entre los meses de Abril y Setiembre, de lunes a sábado de 18 a 22 horas.",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                        ),
                      ),

                      CustomText(
                        '5. Los Horarios de fuera de punta de carga son:',
                        overflow: TextOverflow.clip,
                        //textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: CustomText(
                          "   ● Entre los meses de Octubre y Marzo, de lunes a sábado de 00 a 12 horas, de 16 a 18 horas y de 22 a 24 horas.",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: CustomText(
                          "   ● Entre los meses de Abril y Setiembre, de lunes a sábado de 00 a 18 horas y de 22 a 24 horas.",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: CustomText(
                          "   ● Todos los meses del año, los días domingos las 24 horas.",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
