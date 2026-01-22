import 'package:flutter/material.dart';

class FormWrapper extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Widget child;

  const FormWrapper({super.key, required this.formKey, required this.child});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: child,
    );
  }
}
