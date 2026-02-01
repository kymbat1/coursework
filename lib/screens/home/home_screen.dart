// lib/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ИМПОРТЫ ДЛЯ ФУНКЦИОНАЛА
import '../ai_assistant/ai_assistant_widget.dart';
import '../articles/article_screen.dart';
import '../../models/article.dart'; // Модель Article и Color Extension
import '../notifications/notification_screen.dart'; // ЭКРАН УВЕДОМЛЕНИЙ

// =========================================================================
// МИНИМАЛЬНАЯ ЗАГЛУШКА ДЛЯ MOOD SELECTION (если не импортируется)
// =========================================================================
class MoodSelectionDialog extends StatelessWidget {
  const MoodSelectionDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Выбор Настроения'),
        content: const Text('Интерфейс для выбора текущего настроения.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Закрыть'))
        ]
    );
  }
}
// =========================================================================


class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Color primaryPink = const Color(0xFFFF89AC);
  final Color darkTextColor = const Color(0xFF4A4A6A);
  final Color lightBackgroundColor = const Color(0xFFFDEEF2);

  final User? currentUser = FirebaseAuth.instance.currentUser;

  // Пример списка статей (использует импортированный класс Article)
  List<Article> get _dummyArticles => const [
    Article(
      title: "Питание во время цикла",
      subtitle: "Что есть для энергии и настроения",
      bgColor: Color(0xFFE6E6FA),
      accentColor: Color(0xFF9370DB),
      icon: Icons.local_dining_outlined,
      content: "Полный текст статьи о питании и гормонах. Включает рекомендации по употреблению железа, магния и витаминов в разные фазы.",
      author: 'Steff Yotka', date: 'Oct 2025',
    ),
    Article(
      title: "Сон и гормоны",
      subtitle: "Как улучшить качество сна",
      bgColor: Color(0xFFF0FFF0),
      accentColor: Color(0xFF3CB371),
      icon: Icons.nights_stay_outlined,
      content: "Полный текст статьи о сне. Объясняет, как мелатонин и прогестерон влияют на качество отдыха и дают советы по гигиене сна.",
      author: 'Madeline Fass', date: 'Sep 2025',
    ),
    Article(
      title: "Упражнения для таза",
      subtitle: "Секреты женского здоровья",
      bgColor: Color(0xFFFFF0F5),
      accentColor: Color(0xFFDC143C),
      icon: Icons.directions_run_outlined,
      content: "Полный текст статьи об упражнениях. Описывает пользу йоги и упражнений Кегеля для поддержания здоровья малого таза.",
      author: 'John Doe', date: 'Aug 2025',
    ),
  ];


  // Метод для получения данных пользователя
  Future<Map<String, dynamic>?> fetchUserData() async {
    // ВРЕМЕННОЕ ИСПРАВЛЕНИЕ: Используем наше имя по умолчанию, если Firebase не подключен
    // В РЕАЛЬНОМ ПРОЕКТЕ ЭТОТ БЛОК БУДЕТ ИСПОЛЬЗОВАТЬ ТОЛЬКО FIREBASE/UserService
    if (currentUser == null) {
      // ИМИТАЦИЯ ПОЛЬЗОВАТЕЛЯ БЕЗ АУТЕНТИФИКАЦИИ
      return {'name': 'Александра'};
    }

    // ЛОГИКА FIREBASE:
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
    return userDoc.data();
  }

  // Кнопка уведомлений
  Widget _buildNotificationButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: IconButton(
        iconSize: 28,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationScreen()),
          );
        },
        icon: CircleAvatar(
          backgroundColor: primaryPink.withOpacity(0.1),
          child: Stack(
            children: [
              Icon(Icons.notifications_none_rounded, color: primaryPink, size: 28),
              // Красный кружок (имитация нового уведомления)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: primaryPink,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      // ИСПОЛЬЗУЕМ FutureBuilder ДЛЯ ПОЛУЧЕНИЯ ИМЕНИ
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchUserData(),
        builder: (context, snapshot) {
          // ИСПРАВЛЕНИЕ "ГОСТЬ": Используем 'Александра' или имя из Firebase
          final name = snapshot.data?['name'] ?? 'Александра';

          return CustomScrollView(
            slivers: [
              // --- ИСПРАВЛЕНИЕ ПЕРЕПОЛНЕНИЯ: Используем простой SliverAppBar ---
              SliverAppBar(
                backgroundColor: lightBackgroundColor,
                expandedHeight: 0, // Установим минимально
                floating: true,
                pinned: true,
                elevation: 0,
                // Заменяем FlexibleSpaceBar на Title с Row для приветствия
                title: Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildGreeting(name),
                      _buildNotificationButton(context),
                    ],
                  ),
                ),
                toolbarHeight: 80.0, // Фиксируем высоту AppBar
              ),
              // -----------------------------------------------------------------

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10), // Уменьшили отступ

                      // Карточка цикла
                      _buildCycleCard(context),
                      const SizedBox(height: 30),

                      // СЕКЦИЯ: ИИ-ПОМОЩНИЦА
                      Text(
                        'Анонимный Ассистент',
                        style: TextStyle(
                          color: darkTextColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const AiAssistantWidget(),
                      const SizedBox(height: 30),

                      // СЕКЦИЯ: Статьи
                      Text(
                        'Рекомендованные статьи',
                        style: TextStyle(
                          color: darkTextColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      _buildArticleList(context),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- Вспомогательные методы UI ---

  // Новый виджет приветствия
  Widget _buildGreeting(String name) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Привет, $name',
              style: TextStyle(
                color: darkTextColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(' 👋', style: TextStyle(fontSize: 22)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Начнем заботиться о себе!',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Карточка цикла (имитация данных) - ОСТАЛАСЬ БЕЗ ИЗМЕНЕНИЙ
  Widget _buildCycleCard(BuildContext context) {
    // ... (код остался прежним)
    final int currentDay = 14;
    final String status = currentDay == 14 ? "Овуляция" : "Фолликулярная фаза";
    final int daysRemaining = 14 - currentDay;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: primaryPink,
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: [primaryPink, primaryPink.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryPink.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Текущий статус цикла:',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            status,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'День цикла: $currentDay',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              Text(
                'Цикл завершится через ${daysRemaining} дн.',
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Секция статей (со скроллом) - ОСТАЛАСЬ БЕЗ ИЗМЕНЕНИЙ
  Widget _buildArticleList(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _dummyArticles.length,
        itemBuilder: (context, index) {
          return _buildArticleCard(context, _dummyArticles[index]);
        },
      ),
    );
  }

  // Карточка статьи (кликабельная) - ОСТАЛАСЬ БЕЗ ИЗМЕНЕНИЙ
  Widget _buildArticleCard(BuildContext context, Article article) {
    return InkWell(
      onTap: () {
        // Переход на экран статьи
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleScreen(article: article),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: article.bgColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(article.icon, color: article.accentColor, size: 30),
            const SizedBox(height: 10),
            Text(
              article.title,
              style: TextStyle(color: article.accentColor.darken(0.3), fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              article.subtitle,
              style: TextStyle(color: article.accentColor.darken(0.5), fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}