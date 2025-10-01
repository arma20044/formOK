import 'dart:io';
import 'package:flutter/foundation.dart';

class FormProvider extends ChangeNotifier {
  String? departamento;
  String? ciudad;
  String? tipoReclamo;
  File? archivo;

  // Setters con notifyListeners para actualizar UI
  void setDepartamento(String? value) {
    departamento = value;
    ciudad = null; // limpiar ciudad si cambia el departamento
    notifyListeners();
  }

  void setCiudad(String? value) {
    ciudad = value;
    notifyListeners();
  }

  void setTipoReclamo(String? value) {
    tipoReclamo = value;
    notifyListeners();
  }

  void setArchivo(File? file) {
    archivo = file;
    notifyListeners();
  }

  void reset() {
    departamento = null;
    ciudad = null;
    tipoReclamo = null;
    archivo = null;
    notifyListeners();
  }

  // ✅ Calcula si todos los campos tienen valor
  bool get todosValidos {
    return departamento != null &&
        ciudad != null &&
        tipoReclamo != null &&
        archivo != null;
  }
}
