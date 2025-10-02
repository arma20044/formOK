final Map<String, String? Function(String?)> validators = {
  'telefono': (val) {
    if (val == null || val.isEmpty) return "Ingrese un teléfono";
    if (!RegExp(r'^\d+$').hasMatch(val)) return "Solo números";
    return null;
  },
  'nis': (val) {
    if (val == null || val.isEmpty) return "Ingrese NIS";
    if (!RegExp(r'^\d+$').hasMatch(val)) return "Solo números";
    return null;
  },
  'nombre': (val) {
    if (val == null || val.isEmpty) return "Ingrese Nombre y Apellido";
    return null;
  },
  'direccion': (val) {
    if (val == null || val.isEmpty) return "Ingrese Dirección";
    return null;
  },
  'correo': (val) {
    if (val == null || val.isEmpty) return "Ingrese Correo";
    return null;
  },
  // 'referencia': (val) {
  //   // ejemplo condicional
  //   if (direccionController.text.isNotEmpty && (val == null || val.isEmpty)) {
  //     return "Ingrese Referencia porque Dirección está completa";
  //   }
  //   return null;
  // },
};
