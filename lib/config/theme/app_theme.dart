import 'package:flutter/material.dart';

const colorList = <Color>[
  Colors.green,
  Colors.teal,
  Colors.lightGreen,
  Colors.lime,
  Colors.blue,
  Colors.orange,
  Colors.pink,
  Colors.purple,
];

class AppTheme {
  final int selectedColor;
  final bool isDarkMode;

  AppTheme({
    this.selectedColor = 0,
    this.isDarkMode = false,
  })  : assert(selectedColor >= 0, 'Selected color must be >= 0'),
        assert(selectedColor < colorList.length,
            'Selected color must be < ${colorList.length}');

  // 🔦 Oscurece un color (sin depender de MaterialColor)
  Color _darken(Color color, [double amount = .15]) {
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  ThemeData getTheme() {
    final seed = colorList[selectedColor];
    final appBarColor = isDarkMode ? _darken(seed, 0.20) : seed;
    final onSeed =
        seed.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return ThemeData(
      useMaterial3: true,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      colorSchemeSeed: seed,
      scaffoldBackgroundColor:
          isDarkMode ? const Color(0xFF121212) : Colors.grey.shade50,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: appBarColor,
        foregroundColor: onSeed,
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: seed,
        foregroundColor: onSeed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: seed,
          foregroundColor: onSeed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: seed, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
