import 'package:flutter/material.dart';
import 'package:form/presentation/components/common/info_card_simple.dart';

class CambioContrasenhaScreen extends StatefulWidget {
  const CambioContrasenhaScreen({super.key});

  @override
  State<CambioContrasenhaScreen> createState() =>
      _CambioContrasenhaScreenState();
}

class _CambioContrasenhaScreenState extends State<CambioContrasenhaScreen> {
  final _formKey = GlobalKey<FormState>();

  void _enviarFormulario() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccione medio de notificación')),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final passwordAnteriorController = TextEditingController();
    final passwordController = TextEditingController();
    final passwordConfirmacionController = TextEditingController();

    bool isLoading = false;

    return Scaffold(
      appBar: AppBar(title: Text("Cambiar Contraseña")),
      body: Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Text("data"),
              InfoCardSimple(
                title: "Debe cambiar la contraseña para continuar",
                subtitle: "",
                color: Colors.red,
                size: 14,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: passwordAnteriorController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña Anterior',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese Contraseña Anterior';
                  }
                  return null;
                },
                //enabled: !isLoading,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese Contraseña';
                  }
                  return null;
                },
                //enabled: !isLoading,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: passwordConfirmacionController,
                decoration: const InputDecoration(
                  labelText: 'Confirmar Contraseña',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese Contraseña nuevamente';
                  }
                  return null;
                },
                // enabled: !isLoading,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _enviarFormulario,
                  child: Text("Cambiar Contraseña"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
