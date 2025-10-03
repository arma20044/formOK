import 'package:flutter/material.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';

class ConsultaFacturasScreen extends StatefulWidget {
  const ConsultaFacturasScreen({super.key});

  @override
  State<ConsultaFacturasScreen> createState() => _ConsultaFacturasScreenState();
}

class _ConsultaFacturasScreenState extends State<ConsultaFacturasScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nisController = TextEditingController();

  @override
  void dispose() {
    _nisController.dispose();
    super.dispose();
  }

  void _consultar() {
    if (_formKey.currentState!.validate()) {
      final nis = _nisController.text;
      // Aquí puedes llamar tu API o lógica con el NIS
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Consultando NIS: $nis')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: CustomDrawer(),
      appBar: AppBar(title: const Text('Consulta NIS')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nisController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'NIS',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un NIS';
                  }
                  if (!RegExp(r'^\d+$').hasMatch(value)) {
                    return 'Solo números permitidos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _consultar,
                  child: const Text('Consultar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
