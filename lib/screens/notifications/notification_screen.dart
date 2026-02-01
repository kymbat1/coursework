// lib/screens/notifications/notification_screen.dart

import 'package:flutter/material.dart';

// Модель данных для уведомлений (для демонстрации)
class AppNotification {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final Color accentColor;

  const AppNotification({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.accentColor,
  });
}

// Пример данных
final List<AppNotification> dummyNotifications = [
  const AppNotification(
    title: "Ovulation Day!",
    subtitle: "High chance of getting pregnant",
    icon: Icons.favorite,
    bgColor: Color(0xFFE6E8FB),
    iconColor: Color(0xFF6373F6),
    accentColor: Color(0xFFB3B9FA),
  ),
  const AppNotification(
    title: "70% Possible Pregnancy",
    subtitle: "High chance of getting pregnant",
    icon: Icons.sick,
    bgColor: Color(0xFFFEF2E5),
    iconColor: Color(0xFFF9A64A),
    accentColor: Color(0xFFFDD4A7),
  ),
  const AppNotification(
    title: "Today is Your day",
    subtitle: "Relax and take a sleep",
    icon: Icons.favorite,
    bgColor: Color(0xFFFFECEF),
    iconColor: Color(0xFFFF89AC),
    accentColor: Color(0xFFFFC0D5),
  ),
];


class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  final Color darkTextColor = const Color(0xFF4A4A6A);

  // Каждое уведомление должно быть кликабельным
  void _onNotificationTapped(BuildContext context, AppNotification notification) {
    // Здесь может быть переход на экран детализации или просто всплывающее окно
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification.title),
        content: Text('Детализация: ${notification.subtitle}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Notification',
          style: TextStyle(color: darkTextColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF4A4A6A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: dummyNotifications.length,
        itemBuilder: (context, index) {
          final notification = dummyNotifications[index];
          return _buildNotificationCard(context, notification);
        },
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, AppNotification notification) {
    return InkWell(
      onTap: () => _onNotificationTapped(context, notification),
      child: Container(
        height: 75,
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: notification.bgColor.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Иконка
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: notification.accentColor,
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [notification.accentColor.withOpacity(0.4), notification.bgColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(notification.icon, color: notification.iconColor),
            ),
            const SizedBox(width: 15),

            // Текст
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      color: darkTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notification.subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Стрелка
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}