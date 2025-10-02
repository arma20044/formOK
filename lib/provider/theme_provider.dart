import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/theme/dark_theme.dart';
import '../core/theme/light_theme.dart';

class ThemeNotifier extends AsyncNotifier<ThemeData> {
  static const _themeKey = 'selectedTheme';
  final _storage = const FlutterSecureStorage();

  @override
  Future<ThemeData> build() async {
    final themeValue = await _storage.read(key: _themeKey);
    if (themeValue == 'dark') {
      return darkTheme;
    } else {
      return lightTheme;
    }
  }

  Future<void> toggleTheme() async {
    final current = state.value ?? lightTheme;
    if (current == lightTheme) {
      state = AsyncData(darkTheme);
      await _storage.write(key: _themeKey, value: 'dark');
    } else {
      state = AsyncData(lightTheme);
      await _storage.write(key: _themeKey, value: 'light');
    }
  }
}

final themeProvider =
    AsyncNotifierProvider<ThemeNotifier, ThemeData>(ThemeNotifier.new);