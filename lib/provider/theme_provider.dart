import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/dark_theme.dart';
import '../core/theme/light_theme.dart';

// 1. Creamos un Notifier que maneja el estado del ThemeData
class ThemeNotifier extends Notifier<ThemeData> {
  @override
  ThemeData build() {
    // Estado inicial
    return lightTheme;
  }

  // Método para alternar el tema
  void toggleTheme() {
    state = state == lightTheme ? darkTheme : lightTheme;
  }
}

// 2. Creamos el provider
final themeProvider = NotifierProvider<ThemeNotifier, ThemeData>(() {
  return ThemeNotifier();
});
