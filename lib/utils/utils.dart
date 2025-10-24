    import 'package:flutter/material.dart';

final RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");



Widget loadingRow([String message = "Cargando datos..."]) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const CircularProgressIndicator(),
      const SizedBox(width: 10),
      Text(message),
    ],
  );
}
