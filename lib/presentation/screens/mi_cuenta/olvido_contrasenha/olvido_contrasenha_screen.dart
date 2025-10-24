import 'package:flutter/material.dart';
import 'package:form/config/constantes.dart';
import 'package:form/config/tipo_tramite_model.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/presentation/auth/login_screen.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:form/presentation/components/widgets/dropdown_custom.dart';
import 'package:go_router/go_router.dart';

import '../../../../infrastructure/infrastructure.dart';
import '../../../../repositories/repositories.dart';

enum SingingCharacter { lafayette, jefferson }

class OlvidoContrasenhaScreen extends StatefulWidget {
  const OlvidoContrasenhaScreen({super.key});

  @override
  State<OlvidoContrasenhaScreen> createState() =>
      _OlvidoContrasenhaScreenState();
}

class _OlvidoContrasenhaScreenState extends State<OlvidoContrasenhaScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedOpcion; // Dropdown
  String? _selectedRadio; // RadioButton

  bool _isLoadingOlvidoContrasenha = false;

  DropdownItem? selectedTipoDocumento;
  final List<ModalModel> listaTipoSolicitante = dataTipoSolicitanteArray;
  ModalModel? selectedTipoSolicitante;

  final documentoIdentificacionController = TextEditingController();
  final documentoIdentificacionRepresentanteController =
      TextEditingController();

  final repoOlvidoContrasenha = OlvidoContrasenhaRepositoryImpl(
    OlvidoContrasenhaDatasourceImpl(MiAndeApi()),
  );

  void _enviarFormulario() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedRadio == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Seleccione medio de notificación')),
        );
        return;
      }

      setState(() {
        _isLoadingOlvidoContrasenha = true;
      });
      final olvidoContrasenhaResponse = await repoOlvidoContrasenha
          .getOlvidoContrasenha(
            selectedTipoDocumento!.id,
            documentoIdentificacionController.text,
            _selectedRadio!,
            //cedulaRepresenante ?? 'lteor',
            'lteor',
            //tipoSolicitante
            'Sin registros',
          );

      if (!mounted) return;
      if (olvidoContrasenhaResponse.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(olvidoContrasenhaResponse.errorValList[0])),
        );
        return;
      } else {
        // Si todo está correcto:

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(olvidoContrasenhaResponse.mensaje)),
        );
        GoRouter.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: CustomDrawer(),
      appBar: AppBar(title: const Text('Recuperar Contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown
              DropdownButtonFormField<DropdownItem>(
                initialValue: selectedTipoDocumento,
                hint: const Text("Seleccionar Tipo de Documento"),
                items: dropDownItems
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text(item.name)),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => selectedTipoDocumento = value),
                validator: (value) =>
                    value == null ? 'Seleccione un tipo de documento' : null,
              ),

              const SizedBox(height: 24),
              TextFormField(
                controller: documentoIdentificacionController,
                decoration: const InputDecoration(
                  labelText: 'Número de CI, RUC o Pasaporte',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return "Ingrese Número de CI, RUC o Pasaporte";
                  }

                  final tipo = selectedTipoDocumento!.id;

                  // C.I. Civil → solo números, entre 6 y 10 dígitos
                  if (tipo == 'TD001' &&
                      !RegExp(r'^[0-9]{6,10}$').hasMatch(val)) {
                    return "Éste campo debe contener solo números.";
                  }

                  // RUC → números, guion y dígito verificador
                  if (tipo == 'TD002' &&
                      !RegExp(r'^\d{6,12}-\d$').hasMatch(val)) {
                    return "Este campo debe tener formato de RUC";
                  }
                  return null;
                },
              ),

              Visibility(
                visible: selectedTipoDocumento?.id.compareTo('TD002') == 0,
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    DropdownCustom<ModalModel>(
                      label: "Tipo Solicitante",
                      items: listaTipoSolicitante,
                      value: selectedTipoSolicitante,
                      displayBuilder: (b) => b.descripcion!,
                      validator: (val) =>
                          val == null ? "Seleccione un Tipo Solicitante" : null,
                      onChanged: (val) => setState(() {
                        selectedTipoSolicitante = val;
                        documentoIdentificacionRepresentanteController.text= "";
                      }),
                    ),
                  ],
                ),
              ),

              Visibility(
                visible:
                    selectedTipoSolicitante != null &&
                    selectedTipoSolicitante?.id?.compareTo("Particular") != 0,
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    TextFormField(
                      controller:
                          documentoIdentificacionRepresentanteController,
                      decoration: const InputDecoration(
                        labelText:
                            'Número de CI, RUC o Pasaporte del Representante',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese Número de CI, RUC o Pasaporte del Representante';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // Radio Buttons
              const Text(
                'Seleccione medio de notificación:',
                style: TextStyle(fontSize: 16),
              ),
              RadioListTile<String>(
                title: const Text('Mensaje de Texto (SMS)'),
                value: 'S',
                groupValue: _selectedRadio,
                onChanged: (valor) => setState(() => _selectedRadio = valor),
              ),
              RadioListTile<String>(
                title: const Text('Correo Electrónico (Email)'),
                value: 'E',
                groupValue: _selectedRadio,
                onChanged: (valor) => setState(() => _selectedRadio = valor),
              ),
              const SizedBox(height: 24),

              // Botón
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoadingOlvidoContrasenha
                      ? null
                      : _enviarFormulario,
                  child: _isLoadingOlvidoContrasenha
                      ? const SizedBox(child: CircularProgressIndicator())
                      : Text('Recuperar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
