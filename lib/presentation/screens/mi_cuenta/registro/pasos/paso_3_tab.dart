import 'package:flutter/material.dart';
import 'package:form/model/archivo_adjunto_model.dart';
import 'package:form/presentation/components/common/adjuntos.dart';

class Paso3Tab extends StatelessWidget {
  const Paso3Tab({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    ArchivoAdjunto? _archivoSeleccionado;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Documentos Adjuntos"),
              Adjuntos(
                label: 'Adjuntar imagen o video',
                validator: (value) =>
                    value == null ? 'Debes adjuntar un archivo' : null,
                onChanged: (archivo) =>
                    //print('Seleccionado: ${archivo?.file.path}'),
                    _archivoSeleccionado = archivo
              ),
              Adjuntos(
                label: 'Adjuntar imagen o video',
                validator: (value) =>
                    value == null ? 'Debes adjuntar un archivo' : null,
                onChanged: (archivo) =>
                    print('Seleccionado: ${archivo?.file.path}'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
