import 'package:flutter/material.dart';
import 'package:form/presentation/components/common/UI/custom_comment.dart';
import 'package:form/presentation/components/common/UI/custom_phone_field.dart';
import 'package:form/presentation/components/common/custom_text.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';

class RegistroNumeroCelularScreen extends StatefulWidget {
  const RegistroNumeroCelularScreen({super.key});

  @override
  State<RegistroNumeroCelularScreen> createState() =>
      _RegistroNumeroCelularScreenState();
}

 final _formKey = GlobalKey<FormState>();

class _RegistroNumeroCelularScreenState
    extends State<RegistroNumeroCelularScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoadingSolicitud = false;

  final nisController = TextEditingController();
  final numeroCelularController = TextEditingController();

  void _enviarFormulario() async {

if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese los campos obligatorios')),
      );
      return;
    }

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registro Numero Celular")),
      endDrawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 24),

              CustomComment(
                text:
                    'Registre su número de Teléfono Celular y NIS para recibir notificaciones por SMS.',
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: nisController,
                maxLength: 7,
                decoration: InputDecoration(labelText: 'NIS'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese $value';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              CustomPhoneField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: numeroCelularController,
                label: 'Número de Celular del Titular',
                onChanged: (value) {
                  print("Número completo: $value");
                },
                required: true,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoadingSolicitud ? null : _enviarFormulario,
                  child: _isLoadingSolicitud
                      ? const SizedBox(child: CircularProgressIndicator())
                      : Text("Registrar"),
                ),
              ),
            ],
          ),
        ),
      ),
     
    );
  }
}


