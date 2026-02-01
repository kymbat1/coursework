import 'package:flutter/material.dart';
import 'package:womens_health/screens/auth/login_screen.dart';
import 'package:womens_health/screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';


/// 📍 Все маршруты приложения
final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const LoginScreen(),
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/home': (context) => const HomeScreen(),
};
