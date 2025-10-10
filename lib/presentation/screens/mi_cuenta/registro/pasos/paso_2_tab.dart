import 'package:flutter/material.dart';

class Paso2Tab extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const Paso2Tab({super.key, required this.formKey});

  @override
  State<Paso2Tab> createState() => _Paso2TabState();
}

class _Paso2TabState extends State<Paso2Tab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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
