// lib/screens/profile/access_code_screen.dart

import 'package:flutter/material.dart';

class AccessCodeScreen extends StatelessWidget {
  const AccessCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Код доступа'),
        backgroundColor: const Color(0xFFFF89AC),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Экран: Управление кодом доступа (PIN)', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}