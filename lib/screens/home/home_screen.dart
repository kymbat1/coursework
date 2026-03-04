// lib/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../ai_assistant/ai_assistant_widget.dart';
import '../articles/article_screen.dart';
import '../notifications/notification_screen.dart';
import '../calendar/cycle_calendar_screen.dart';
import '../doctors/all_doctors_screen.dart';
import '../profile/profile_screen.dart';
import '../../services/auth_service.dart';
import '../../models/article.dart';

class HomeScreen extends StatelessWidget {
  final AuthService authService;

  const HomeScreen({super.key, required this.authService});

  static const Color primaryPink = Color(0xFFFF89AC);
  static const Color darkTextColor = Color(0xFF4A4A6A);
  static const Color lightBackgroundColor = Color(0xFFFDEEF2);

  // ================= Articles =================

  List<Article> get _dummyArticles => const [
    Article(
      title: "Питание во время цикла",
      subtitle: "Что есть для энергии и настроения",
      bgColor: Color(0xFFE6E6FA),
      accentColor: Color(0xFF9370DB),
      icon: Icons.local_dining_outlined,
      content: "Полный текст статьи о питании и гормонах.",
      author: 'Steff Yotka',
      date: 'Oct 2025',
    ),
    Article(
      title: "Сон и гормоны",
      subtitle: "Как улучшить качество сна",
      bgColor: Color(0xFFF0FFF0),
      accentColor: Color(0xFF3CB371),
      icon: Icons.nights_stay_outlined,
      content: "Полный текст статьи о сне.",
      author: 'Madeline Fass',
      date: 'Sep 2025',
    ),
  ];

  // ================= Firebase =================

  Future<Map<String, dynamic>?> fetchUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return {'name': 'Александра'};

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    return userDoc.data();
  }

  // ================= Build =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchUserData(),
        builder: (context, snapshot) {
          final name = snapshot.data?['name'] ?? 'Александра';

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: lightBackgroundColor,
                floating: true,
                pinned: true,
                elevation: 0,
                toolbarHeight: 80,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildGreeting(name),
                    _buildNotificationButton(context),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      _buildCycleCard(),
                      const SizedBox(height: 30),
                      const Text(
                        'Анонимный Ассистент',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: darkTextColor),
                      ),
                      const SizedBox(height: 15),
                      const AiAssistantWidget(),
                      const SizedBox(height: 30),
                      const Text(
                        'Рекомендованные статьи',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: darkTextColor),
                      ),
                      const SizedBox(height: 15),
                      _buildArticleList(context),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  // ================= UI =================

  Widget _buildGreeting(String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Привет, $name 👋',
          style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: darkTextColor),
        ),
        const SizedBox(height: 4),
        const Text(
          'Начнем заботиться о себе!',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildNotificationButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const NotificationScreen()));
      },
      icon: const Icon(Icons.notifications_none_rounded,
          color: primaryPink),
    );
  }

  Widget _buildCycleCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: primaryPink,
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Text(
        "Текущий статус цикла: Овуляция",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  Widget _buildArticleList(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _dummyArticles.length,
        itemBuilder: (context, index) {
          final article = _dummyArticles[index];
          return InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      ArticleScreen(article: article)),
            ),
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
                  Icon(article.icon,
                      color: article.accentColor),
                  const SizedBox(height: 10),
                  Text(article.title,
                      style: TextStyle(
                          color: article.accentColor,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= Bottom Navigation =================

  Widget _buildBottomNavigation(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navIcon(Icons.home, true, () {}),
            _navIcon(Icons.calendar_month, false, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                      const CycleCalendarScreen()));
            }),
            const SizedBox(width: 40),
            _navIcon(Icons.medical_services, false, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                      const AllDoctorsScreen()));
            }),
            _navIcon(Icons.person, false, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          ProfileScreen(
                              authService: authService)));
            }),
          ],
        ),
      ),
    );
  }

  Widget _navIcon(
      IconData icon, bool active, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon,
          color: active ? primaryPink : Colors.grey),
    );
  }
}