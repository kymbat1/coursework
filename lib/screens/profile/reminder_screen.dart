// lib/screens/profile/reminder_screen.dart

import 'package:flutter/material.dart';

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Напоминания'),
        backgroundColor: const Color(0xFFFF89AC),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Экран: Управление напоминаниями', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}