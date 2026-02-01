// lib/screens/profile/period_ovulation_screen.dart

import 'package:flutter/material.dart';

class PeriodOvulationScreen extends StatelessWidget {
  const PeriodOvulationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Цикл и Овуляция'),
        backgroundColor: const Color(0xFFFF89AC),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Экран: Настройки цикла и овуляции', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}