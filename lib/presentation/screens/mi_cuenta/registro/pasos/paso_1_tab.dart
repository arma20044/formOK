import 'package:flutter/material.dart';

class Paso1Tab extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const Paso1Tab({super.key, required this.formKey});

  @override
  State<Paso1Tab> createState() => _Paso1TabState();
}

class _Paso1TabState extends State<Paso1Tab>
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
              decoration: const InputDecoration(labelText: 'Nombre'),
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
