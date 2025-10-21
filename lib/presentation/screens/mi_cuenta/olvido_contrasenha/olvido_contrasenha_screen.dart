import 'package:flutter/material.dart';
import 'package:form/presentation/auth/login_screen.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';

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

  DropdownItem? selectedTipoDocumento;
  final isLoading = false;
  final numeroController = TextEditingController();

  final List<String> _opcionesDropdown = ['Opción A', 'Opción B', 'Opción C'];

  void _enviarFormulario() {
    if (_formKey.currentState!.validate()) {
      if (_selectedRadio == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Seleccione una opción de tipo')),
        );
        return;
      }

      // Si todo está correcto:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Enviado ✅\nDropdown: $_selectedOpcion\nTipo: $_selectedRadio',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulario con Dropdown y Radios')),
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
                onChanged: isLoading
                    ? null
                    : (value) => setState(() => selectedTipoDocumento = value),
                validator: (value) =>
                    value == null ? 'Seleccione un tipo de documento' : null,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: numeroController,
                decoration: const InputDecoration(
                  labelText: 'Número de CI, RUC o Pasaporte',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese Número de CI, RUC o Pasaporte';
                  }
                  return null;
                },
                enabled: !isLoading,
              ),
              const SizedBox(height: 24),
              // Radio Buttons
              const Text('Seleccione tipo:', style: TextStyle(fontSize: 16)),
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
                  child: const Text('Enviar formulario'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
