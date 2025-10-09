import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:form/config/theme/app_theme.dart';


/// Estado del tema (color + modo oscuro)
class ThemeState {
  final bool isDarkMode;
  final int selectedColor;

  const ThemeState({
    this.isDarkMode = false,
    this.selectedColor = 0,
  });

  ThemeState copyWith({bool? isDarkMode, int? selectedColor}) => ThemeState(
        isDarkMode: isDarkMode ?? this.isDarkMode,
        selectedColor: selectedColor ?? this.selectedColor,
      );
}

/// Notifier para manejar el tema global
class ThemeNotifier extends Notifier<ThemeState> {
  @override
  ThemeState build() => const ThemeState();

  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  void changeColor(int index) {
    state = state.copyWith(selectedColor: index);
  }

  ThemeData get theme => AppTheme(
        selectedColor: state.selectedColor,
        isDarkMode: state.isDarkMode,
      ).getTheme();
}

/// Provider global
final themeNotifierProvider =
    NotifierProvider<ThemeNotifier, ThemeState>(ThemeNotifier.new);
