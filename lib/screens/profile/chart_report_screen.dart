// lib/screens/profile/chart_report_screen.dart

import 'package:flutter/material.dart';

class ChartReportScreen extends StatelessWidget {
  const ChartReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Графики и Отчеты'),
        backgroundColor: const Color(0xFFFF89AC),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Экран: Графики и Отчеты по здоровью', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}