// lib/services/auth_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // 🔹 Адрес вашего Java-бэкенда
  // Для Android эмулятора: 10.0.2.2
  // Для веба: localhost
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080';
    } else {
      return 'http://10.0.2.2:8080';
    }
  }

  // 🔹 Сохраняем JWT
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt', token);
  }

  // 🔹 Получаем JWT
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt');
  }

  // 🔹 Удаляем JWT (выход)
  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt');
  }

  // 🔹 Проверка текущего пользователя (наличие JWT)
  Future<String> currentUser() async {
    final token = await getToken();
    return token ?? '';
  }

  // 🔹 Регистрация нового пользователя
  Future<void> register(String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/register');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (kIsWeb) 'Access-Control-Allow-Origin': '*', // Для веба (CORS)
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Registration failed: ${response.body}');
    }
  }

  // 🔹 Вход пользователя
  Future<void> signIn(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (kIsWeb) 'Access-Control-Allow-Origin': '*', // Для веба (CORS)
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'] as String?;
      if (token == null) {
        throw Exception('JWT token missing in response');
      }
      await saveToken(token);
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  // 🔹 Выход
  Future<void> signOut() async {
    await deleteToken();
  }
}
