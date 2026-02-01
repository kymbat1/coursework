// lib/models/article.dart

import 'package:flutter/material.dart';

// ЕДИНСТВЕННОЕ ОПРЕДЕЛЕНИЕ КЛАССА ARTICLE
class Article {
  final String title;
  final String subtitle;
  final Color bgColor;
  final Color accentColor;
  final IconData icon;
  final String content;
  final String author;
  final String date;
  final String imageName;

  const Article({
    required this.title,
    required this.subtitle,
    required this.bgColor,
    required this.accentColor,
    required this.icon,
    required this.content,
    this.author = 'Steff Yotka',
    this.date = 'Madeline Fass',
    this.imageName = 'article_header_default.png',
  });
}

// РАСШИРЕНИЕ ДЛЯ ЦВЕТА
extension ColorExtension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    // Используем 'ColorExtension' как имя расширения, чтобы быть более явными,
    // хотя это не обязательно, но иногда помогает Dart
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}