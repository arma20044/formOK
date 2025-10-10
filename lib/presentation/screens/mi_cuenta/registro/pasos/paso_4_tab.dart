import 'package:flutter/material.dart';

class Paso4Tab extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const Paso4Tab({super.key, required this.formKey});

  @override
  State<Paso4Tab> createState() => _Paso4TabState();
}

class _Paso4TabState extends State<Paso4Tab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final Map<String, bool> opciones = {
    'Acepto los términos y condiciones': false,
    'Deseo recibir notificaciones por correo': false,
    'Autorizo el uso de mis datos personales': false,
  };

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Form(
      key: widget.formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Contraseña'),
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Campo obligatorio' : null,
            ),
            // Otros campos...
          ],
        ),
      ),
    );
  }
}
