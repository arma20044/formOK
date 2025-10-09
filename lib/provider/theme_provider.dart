import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

/// Notifier para manejar el tema global con persistencia antes de mostrar la UI
class ThemeNotifier extends AsyncNotifier<ThemeState> {
  final _storage = const FlutterSecureStorage();

  @override
  Future<ThemeState> build() async {
    // Cargar tema desde storage
    final darkModeStr = await _storage.read(key: 'isDarkMode');
    final colorStr = await _storage.read(key: 'selectedColor');

    final isDarkMode = darkModeStr == 'true';
    final selectedColor = int.tryParse(colorStr ?? '') ?? 0;

    return ThemeState(isDarkMode: isDarkMode, selectedColor: selectedColor);
  }

  Future<void> toggleDarkMode() async {
    if (state.value == null) return;
    final newState = state.value!.copyWith(isDarkMode: !state.value!.isDarkMode);
    state = AsyncData(newState);
    await _storage.write(key: 'isDarkMode', value: newState.isDarkMode.toString());
  }

  Future<void> changeColor(int index) async {
    if (state.value == null) return;
    final newState = state.value!.copyWith(selectedColor: index);
    state = AsyncData(newState);
    await _storage.write(key: 'selectedColor', value: index.toString());
  }

  ThemeData get theme {
    if (state.value == null) return AppTheme().getTheme();
    return AppTheme(
      selectedColor: state.value!.selectedColor,
      isDarkMode: state.value!.isDarkMode,
    ).getTheme();
  }
}

/// Provider global
final themeNotifierProvider =
    AsyncNotifierProvider<ThemeNotifier, ThemeState>(ThemeNotifier.new);
