import 'package:flutter/material.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/model/olvido_contrasenha.dart';
import 'package:form/presentation/auth/login_screen.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
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

  final documentoIdentificacionController = TextEditingController();

  final repoOlvidoContrasenha = OlvidoContrasenhaRepositoryImpl(
    OlvidoContrasenhaDatasourceImpl(MiAndeApi()),
  );

  void _enviarFormulario() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedRadio == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Seleccione medio de notificación',)),
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
          SnackBar(
            content: Text(
              olvidoContrasenhaResponse.mensaje,
            ),
          ),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese Número de CI, RUC o Pasaporte';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Radio Buttons
              const Text('Seleccione medio de notificación:', style: TextStyle(fontSize: 16)),
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
                  onPressed: _enviarFormulario,
                  child: const Text('Recuperar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
