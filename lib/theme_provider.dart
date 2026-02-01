import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // Светлая тема
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFFFF89AC),
    hintColor: const Color(0xFF3B3B5C),
    scaffoldBackgroundColor: const Color(0xFFFDEEF2),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF4A4A6A)),
      bodyMedium: TextStyle(color: Color(0xFF4A4A6A)),
    ),
  );

  // Темная тема (добавьте по необходимости)
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFFFF89AC),
    scaffoldBackgroundColor: const Color(0xFF121212),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
  );
}