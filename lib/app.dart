// lib/app.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'screens/main_wrapper.dart';
import 'theme_provider.dart';

// НОВЫЕ ИМПОРТЫ ДЛЯ АУТЕНТИФИКАЦИИ
import 'services/auth_service.dart';
// 🔥 Создаем экземпляр AuthService, который будет использоваться приложением
final AuthService authService = AuthService();


class WomensHealthApp extends StatelessWidget {
  const WomensHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Используем ChangeNotifierProvider, чтобы сделать ThemeProvider доступным
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Women\'s Health',

            // Настройка темы, использующая основную розовую палитру
            theme: ThemeData(
              // Розовый цвет: #FF89AC
              primaryColor: const Color(0xFFFF89AC),
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.pink, // Создает оттенки розового
              ).copyWith(
                secondary: const Color(0xFFFF89AC),
              ),
              // Светло-розовый фон из дизайна календаря
              scaffoldBackgroundColor: const Color(0xFFFDEEF2),
              fontFamily: 'Inter',
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: Color(0xFF4A4A6A)),
                elevation: 0,
              ),
              // Общие настройки для кнопок и текста
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Color(0xFF4A4A6A)),
                labelLarge: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            // --- Настройка локализации ---
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('ru', 'RU'),
            ],

            // 🎯 ИЗМЕНЕНИЕ: Передаем AuthService в MainWrapper
            home: MainWrapper(authService: authService), // УДАЛЯЕМ const
          );
        },
      ),
    );
  }
}