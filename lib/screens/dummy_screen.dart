import 'package:flutter/material.dart';

class DummyScreen extends StatelessWidget {
  final String title;
  final Color bgColor;

  const DummyScreen({
    super.key,
    required this.title,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.black)),
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          "Это заглушка для экрана\n$title",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
      ),
    );
  }
}
