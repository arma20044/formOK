import 'package:flutter/material.dart';
import 'package:form/config/constantes.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/infrastructure/comercial/solicitudes/registro_numero_celular_datasource_impl.dart';
import 'package:form/model/comercial/solicitudes/registro_numero_celular_model.dart';
import 'package:form/presentation/components/common/UI/custom_comment.dart';
import 'package:form/presentation/components/common/UI/custom_phone_field.dart';
import 'package:form/presentation/components/common/custom_show_dialog.dart';
import 'package:form/presentation/components/common/otp_verification_widget.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:form/repositories/comercial/solicitudes/registro_numero_celular_repository_impl.dart';
import 'package:form/utils/utils.dart';

class RegistroNumeroCelularScreen extends StatefulWidget {
  const RegistroNumeroCelularScreen({super.key});

  @override
  State<RegistroNumeroCelularScreen> createState() =>
      _RegistroNumeroCelularScreenState();
}

class _RegistroNumeroCelularScreenState
    extends State<RegistroNumeroCelularScreen> {
  final _formKey = GlobalKey<FormState>();
  final nisController = TextEditingController();
  final numeroCelularController = TextEditingController();

  bool _isLoadingSolicitud = false;
  String? codigoOTPObtenido;
  String solicitarOTP = 'S';

  @override
  void dispose() {
    nisController.dispose();
    numeroCelularController.dispose();
    super.dispose();
  }

  Future<void> _enviarFormulario(String solicitarOTP) async {
    if (_isLoadingSolicitud) return;

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese los campos obligatorios')),
      );
      return;
    }

    setState(() => _isLoadingSolicitud = true);

    try {
      final result = await _fetchRegistroNumeroCelular(solicitarOTP);

      if (result.error) {
        DialogHelper.showMessage(
          context,
          MessageType.error,
          'Error',
          result.errorValList?.first ?? 'Error desconocido',
        );
        return;
      }

      // Si se solicita OTP
      if (solicitarOTP == 'S') {
        _mostrarOtpBottomSheet();
      } else {
        // Si fue verificación final exitosa
        if (mounted) Navigator.of(context).pop(); // Cierra el BottomSheet
        DialogHelper.showMessage(
          context,
          MessageType.success,
          'Éxito',
          'Número de celular registrado correctamente.',
        );
      }
    } catch (e) {
      /*DialogHelper.showMessage(
        context,
        MessageType.error,
        'Error',
        'Ocurrió un problema al procesar la solicitud.',
      );*/
    } finally {
      if (mounted) setState(() => _isLoadingSolicitud = false);
    }
  }

  Future<RegistroNumeroCelularResponse> _fetchRegistroNumeroCelular(
    String solicitarOTP,
  ) async {
    final repo = RegistroNumeroCelularRepositoryImpl(
      RegistroNumeroCelularDatasourceImp(MiAndeApi()),
    );

    return await repo.getRegistroNumeroCelular(
      nisController.text.trim(),
      numeroCelularController.text.trim(),
      obtenerFechaActual(),
      solicitarOTP,
      codigoOTPObtenido ?? '',
    );
  }

  void _mostrarOtpBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 16,
          ),
          child: SizedBox(
            height: 420,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OtpInputWidget(
                  isLoading: _isLoadingSolicitud,
                  tipoVerificacion: 'CEL',
                  phoneNumber: numeroCelularController.text,
                  onSubmit: (otp) {
                    if (!mounted) return;
                    setState(() {
                      codigoOTPObtenido = otp;
                      solicitarOTP = 'N';
                    });
                    _enviarFormulario('N');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro Número Celular")),
      endDrawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 16),
              const CustomComment(
                text:
                    'Registre su número de teléfono celular y NIS para recibir notificaciones por SMS.',
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: nisController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.number,
                maxLength: 7,
                decoration: const InputDecoration(labelText: 'NIS'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingrese NIS';
                  }
                  if (value.trim().length != 7) {
                    return 'El NIS debe tener 7 dígitos';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              CustomPhoneField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: numeroCelularController,
                label: 'Número de Celular del Titular',
                onChanged: (value) => debugPrint("Número completo: $value"),
                required: true,
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      _isLoadingSolicitud ? null : () => _enviarFormulario('S'),
                  child: _isLoadingSolicitud
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Registrar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
