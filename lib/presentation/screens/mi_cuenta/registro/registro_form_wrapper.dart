import 'package:flutter/material.dart';

class RegistroFormWrapper extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Widget child;

  const RegistroFormWrapper({
    super.key,
    required this.formKey,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}
