import 'package:flutter/material.dart';

import '../core/theme/dark_theme.dart';
import '../core/theme/light_theme.dart';


class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightTheme;

  ThemeData get themeData => _themeData;

  // Método para cambiar el tema
  void toggleTheme() {
    if (_themeData == lightTheme) {
      _themeData = darkTheme;
    } else {
      _themeData = lightTheme;
    }
    notifyListeners(); // Notifica a los oyentes del cambio de estado
  }
}
