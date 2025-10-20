import 'package:flutter/material.dart';
import 'package:form/model/model.dart';
import 'package:form/presentation/components/common/custom_message_dialog.dart';
import 'package:form/presentation/components/common/custom_show_dialog.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import '../../../../core/api/mi_ande_api.dart';
import '../../../../infrastructure/infrastructure.dart';
import '../../../../repositories/repositories.dart';
import '../../../components/common/otp_verification_widget.dart';
import 'registro.dart';

class RegistroMiCuentaScreen extends StatefulWidget {
  const RegistroMiCuentaScreen({super.key});

  @override
  State<RegistroMiCuentaScreen> createState() => _RegistroMiCuentaScreenState();
}

class _RegistroMiCuentaScreenState extends State<RegistroMiCuentaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoadingRegistroMiCuenta = false;
  String? tipoClienteId;

  late final Paso1Tab paso1Widget;

  /// Un formKey por cada paso
  final List<GlobalKey<FormState>> _formKeys = List.generate(
    4,
    (_) => GlobalKey<FormState>(),
  );
  final GlobalKey<Paso1TabState> paso1Key = GlobalKey<Paso1TabState>();
  final GlobalKey<Paso2TabState> paso2Key = GlobalKey<Paso2TabState>();
  final GlobalKey<Paso3TabState> paso3Key = GlobalKey<Paso3TabState>();
  final GlobalKey<FormState> paso4Key = GlobalKey<FormState>();

  String? codigoOTPObtenido;
  String? solicitarOTP = 'S';
  bool mostrarCargarCodigoOTP = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _formKeys.length, vsync: this);
    paso1Widget = Paso1Tab(formKey: _formKeys[0]);

    // Listener para actualizar la UI cuando cambia el tab
    _tabController.addListener(() {
      // Solo cuando terminó la animación y no está en el medio de un swipe
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Validar el formulario del paso actual
  bool _validateCurrentStep() {
    final currentForm = _formKeys[_tabController.index].currentState;
    return currentForm?.validate() ?? false;
  }

  /// Ir al siguiente paso
  void _nextTab() {
    if (!_validateCurrentStep()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Complete los campos obligatorios")),
      );
      return;
    }

    if (_tabController.index < _tabController.length - 1) {
      setState(() {
        _tabController.index += 1;
      });
    }
  }

  /// Volver al paso anterior
  void _previousTab() {
    if (_tabController.index > 0) {
      setState(() {
        _tabController.index -= 1;
      });
    }
  }

  Future<MiCuentaRegistroResponse> _fetchMiCuentaRegistro() async {
    //Future<bool> _fetchMiCuentaRegistro() async {
    final repoMicuentaRegistro = MiCuentaRegistroRepositoryImpl(
      MiCuentaRegistroDatasourceImpl(MiAndeApi()),
    );

    // ✅ Obtener los valores del formulario del Paso 1
    final datosPaso1 = paso1Key.currentState?.getFormData();
    final datosPaso2 = paso2Key.currentState?.getFormData();
    final datosPaso3 = paso3Key.currentState?.getFormData();

    print("Datos a enviar: $datosPaso1");
    print("Datos a enviar: $datosPaso2");
    print("Datos a enviar: $datosPaso3");

    final miCuentaRegistroResponse = await repoMicuentaRegistro
        .getMiCuentaRegistro(
          actualizarDatos: 'S',
          tipoCliente: num.parse(datosPaso1!['tipoCliente']),
          tipoSolicitante: datosPaso1['tipoSolicitante'],
          tipoDocumento: datosPaso1['tipoDocumento'],
          cedulaRepresentante: datosPaso1['cedulaRepresentante'] ?? 'lteor',
          numeroDocumento: datosPaso1['numeroDocumento'] ?? '',
          nombre: datosPaso1['nombre'] ?? '',
          apellido: datosPaso1['apellido'] ?? '',
          pais: datosPaso1['pais'] ?? '',
          departamento: datosPaso1['departamento'] ?? 'NINGUNO',
          ciudad: datosPaso1['ciudad'] ?? 'NINGUNO',
          direccion: datosPaso1['direccion'] ?? '',
          correo: datosPaso1['correo'] ?? '',
          telefonoFijo: datosPaso1['telefonoFijo'] ?? '',
          numeroTelefonoCelular: datosPaso1['telefonoCelular'] ?? '',
          password: datosPaso2!['password'] ?? '',
          confirmacionPassword: datosPaso2['confirmarPassword'] ?? '',
          passwordAnterior: datosPaso2['passwordAnterior'] ?? '',
          tipoVerificacion: datosPaso2['tipoVerificacion'] ?? '',
          solicitudOTP: solicitarOTP ?? 'S',
          codigoOTP: codigoOTPObtenido.toString(),
        );
    return miCuentaRegistroResponse;
  }

  /// Enviar formulario completo
  Future<void> _enviarFormulario() async {
    if (_isLoadingRegistroMiCuenta) return;

    // Validar todos los pasos
    for (int i = 0; i < _formKeys.length; i++) {
      final isValid = _formKeys[i].currentState?.validate() ?? false;
      if (!isValid) {
        if (i == _formKeys.length - 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Debe aceptar todos los Terminos y Condiciones"),
            ),
          );
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Complete todos los campos obligatorios del paso ${i + 1}",
            ),
          ),
        );
        return;
      }

      // 🔹 Último tab
    }

    /*if (!paso4Key.currentState!.validateCheckboxes()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Debe aceptar todos los términos requeridos"),
        ),
      );
      return;
    }*/

    setState(() => _isLoadingRegistroMiCuenta = true);

    try {
      MiCuentaRegistroResponse result = await _fetchMiCuentaRegistro();
      //bool result = await _fetchMiCuentaRegistro();
      if (result.error) {
        /* ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result.errorValList![0]))); */
        DialogHelper.showMessage(
          context,
          MessageType.error,
          'Error',
          result.errorValList[0],
        );

        return;
      } else {
        /* ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Formulario enviado correctamente")),
        ); */
        setState(() {
          solicitarOTP = 'S';
        });
        mostrarCargarCodigoOTP = true;
        DialogHelper.showMessage(
          context,
          MessageType.success,
          'Éxito',
          result.mensaje!,
          //duration: const Duration(seconds: 3),
        );
      }
    } finally {
      setState(() => _isLoadingRegistroMiCuenta = false);
    }
  }

  Future<bool> _validarTabActual() async {
    // 🔹 ejemplo simple
    // si querés validar un Form: if (_formKey.currentState!.validate()) return true;
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastTab = _tabController.index == _tabController.length - 1;

    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: RegistroAppBar(
        controller: _tabController,
        onNextTab: _nextTab,
        onPreviousTab: _previousTab,
      ),

      body: SafeArea(
        child: Column(
          children: [
            /// Indicador de progreso
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: LinearProgressIndicator(
                value: (_tabController.index + 1) / _tabController.length,
                backgroundColor: Colors.grey[300],
                color: Theme.of(context).colorScheme.primary,
                minHeight: 6,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            /// Contenido de cada paso (cada uno con su propio Form)
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  //Paso1Tab(formKey: _formKeys[0]),
                  Paso1Tab(
                    key: paso1Key,
                    formKey: _formKeys[0],
                    onTipoClienteChanged: (id) {
                      setState(() {
                        tipoClienteId = id;
                      });
                    },
                  ),
                  Paso2Tab(key: paso2Key, formKey: _formKeys[1]),
                  Paso3Tab(
                    key: paso3Key,
                    formKey: _formKeys[2],
                    tipoTramite: tipoClienteId == null
                        ? 2
                        : int.parse(tipoClienteId!),
                  ),

                  Tab4(
                    key: paso4Key,
                    formKey: _formKeys[3],
                    //tipoTramite:
                    //   paso1Key.currentState?.selectedTipoTramite?.id ?? "",
                  ),
                ],
              ),
            ),
            mostrarCargarCodigoOTP
                ? OtpInputWidget(
                    phoneNumber: "+595 981 123 456",
                    onSubmit: (otp) {
                      setState(() {
                        codigoOTPObtenido = otp;
                        solicitarOTP = 'N';
                      });

                      _enviarFormulario();
                      print("Código ingresado: $otp");
                    },
                  )
                : Text(""),
          ],
        ),
      ),

      /// Botones inferiores
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              if (_tabController.index > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoadingRegistroMiCuenta ? null : _previousTab,
                    child: _isLoadingRegistroMiCuenta
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Anterior'),
                  ),
                ),
              if (_tabController.index > 0) const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoadingRegistroMiCuenta
                      ? null
                      : isLastTab
                      ? _enviarFormulario
                      : _nextTab,
                  child: _isLoadingRegistroMiCuenta
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(isLastTab ? 'Enviar' : 'Siguiente'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
