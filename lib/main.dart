import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; // Предполагается, что этот файл существует
import 'app.dart';
import 'theme_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
// Импорт flutter_localizations удален, так как он нужен только в app.dart

Future<void> main() async {
  // Гарантирует, что привязки виджетов инициализированы перед запуском
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Инициализация данных форматирования даты для русской локали ('ru_RU')
  // Это критично для корректного отображения русских названий месяцев
  await initializeDateFormatting('ru_RU', null);


  // Запуск приложения с поддержкой тем через ChangeNotifierProvider
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const WomensHealthApp(),
    ),
  );
}
