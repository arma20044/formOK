import 'package:flutter/material.dart';
import 'package:form/model/archivo_adjunto_model.dart';
import 'package:form/presentation/components/common/adjuntos.dart';

class Paso3Tab extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const Paso3Tab({super.key, required this.formKey});

  @override
  State<Paso3Tab> createState() => _Paso3TabState();
}

class _Paso3TabState extends State<Paso3Tab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);

    ArchivoAdjunto? _archivoSeleccionado;

    return Scaffold(
      body: Form(
        key: widget.formKey,
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
                    _archivoSeleccionado = archivo,
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
                  if (widget.formKey.currentState!.validate()) {
                    widget.formKey.currentState!.save();
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
