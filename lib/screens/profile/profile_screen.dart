import 'package:flutter/material.dart';
// !!! НЕОБХОДИМЫЕ ИМПОРТЫ !!!
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Импорт сервиса аутентификации
import '../../services/auth_service.dart';

// Импорты для навигации по профилю (из предыдущего шага)
import 'edit_profile_screen.dart';
import 'chart_report_screen.dart';
import 'period_ovulation_screen.dart';
import 'access_code_screen.dart';
import 'reminder_screen.dart';
import 'help_screen.dart';


class ProfileScreen extends StatelessWidget {
  // 🔥 ИЗМЕНЕНИЕ 1: Добавляем AuthService в конструктор
  final AuthService authService;

  const ProfileScreen({super.key, required this.authService});

  final Color primaryPink = const Color(0xFFFF89AC);
  final Color darkTextColor = const Color(0xFF4A4A6A);
  final Color lightBackgroundColor = const Color(0xFFFDEEF2);

  // Инициализируем маршруты константами для статического виджета
  final Map<String, Widget> _routes = const {
    'Edit Profile': EditProfileScreen(),
    'Chart and Report': ChartReportScreen(),
    'Period and Ovulation': PeriodOvulationScreen(),
    'Acces Code': AccessCodeScreen(),
    'Reminder': ReminderScreen(),
    'Help': HelpScreen(),
  };

  User? get currentUser => FirebaseAuth.instance.currentUser;

  // 🔥 ИЗМЕНЕНИЕ 2: Метод всегда возвращает Map, используя заглушку при отсутствии авторизации
  Future<Map<String, dynamic>> fetchUserData() async {
    final user = currentUser;

    // Если пользователь не авторизован, возвращаем демонстрационные данные
    if (user == null) {
      return {
        'name': 'Лесли Александр (Демо)',
        'email': 'leslie@demo.com',
      };
    }

    // Если пользователь авторизован, пытаемся получить данные из Firestore
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // Возвращаем полученные данные или заглушку, если документ не найден
      return userDoc.data() ?? {
        'name': 'Новый Пользователь',
        'email': user.email ?? 'user@auth.com',
      };
    } catch (e) {
      // В случае ошибки Firebase возвращаем данные пользователя с сообщением об ошибке
      return {
        'name': 'Тестовый юзер',
        'email': user.email ?? 'error@auth.com',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🔥 ИЗМЕНЕНИЕ 3: Удалена начальная проверка if (currentUser == null)

    return Scaffold(
      backgroundColor: lightBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(
            color: darkTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      // FutureBuilder теперь ожидает Future<Map<String, dynamic>>
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 🔥 Так как fetchUserData гарантирует возврат Map, мы можем упростить обработку ошибок
          if (!snapshot.hasData || snapshot.hasError) {
            // Используем mock-данные в случае ошибки или отсутствия данных (хотя это маловероятно после изменения fetchUserData)
            final name = 'Тестовый юзер';
            final nickname = '@error';
          }

          final userData = snapshot.data!; // Данные гарантированно есть
          final name = userData['name'] ?? 'Ваше Имя';
          final email = userData['email'] ?? 'user@example.com';
          final nickname = '@${email.split('@').first}'; // Используем email для никнейма

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // 📸 Карточка с фото профиля
                  _buildProfilePhotoCard(),
                  const SizedBox(height: 25),

                  // 👤 Имя пользователя и никнейм
                  Text(
                    name,
                    style: TextStyle(
                      color: darkTextColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    nickname,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ⚙️ Список пунктов меню
                  _buildProfileOption(Icons.edit_outlined, 'Edit Profile', context),
                  _buildProfileOption(Icons.leaderboard_outlined, 'Chart and Report', context),
                  _buildProfileOption(Icons.favorite_border, 'Period and Ovulation', context),
                  _buildProfileOption(Icons.lock_outline_rounded, 'Acces Code', context),
                  _buildProfileOption(Icons.notifications_none_rounded, 'Reminder', context),
                  _buildProfileOption(Icons.help_outline, 'Help', context),
                  const SizedBox(height: 40),

                  // ➡️ Кнопка "Logout"
                  _buildLogoutButton(context),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Вспомогательные методы ---

  Widget _buildProfileOption(IconData icon, String title, BuildContext context) {
    return InkWell(
      onTap: () {
        final screenToNavigate = _routes[title];
        if (screenToNavigate != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screenToNavigate),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Маршрут для "$title" не найден.'), duration: const Duration(milliseconds: 700)),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Icon(icon, size: 28, color: primaryPink),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: TextStyle(color: darkTextColor, fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return TextButton(
      // Кнопка "Logout" теперь только для авторизованных пользователей.
      // Если пользователь не авторизован (использует демо-режим), она не будет работать.
      onPressed: currentUser != null ? () async {
        await authService.signOut();
      } : () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Вы в демо-режиме.'), duration: Duration(milliseconds: 700)),
        );
      },
      style: TextButton.styleFrom(
        foregroundColor: primaryPink,
        padding: EdgeInsets.zero,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.logout, size: 28, color: primaryPink),
          const SizedBox(width: 10),
          Text(
            'Logout',
            style: TextStyle(color: primaryPink, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePhotoCard() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: primaryPink.withOpacity(0.8),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.camera_alt_outlined, size: 50, color: Colors.white.withOpacity(0.6)),
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt_outlined, size: 24, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}