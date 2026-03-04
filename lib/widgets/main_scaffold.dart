// lib/widgets/main_scaffold.dart
import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/calendar/cycle_calendar_screen.dart';
import '../screens/home/health_screen.dart';
import '../screens/home/profile_screen.dart';

class MainScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;

  const MainScaffold({
    super.key,
    required this.body,
    this.currentIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryPink = const Color(0xFFFF89AC);

    Widget _buildNavItem(IconData icon, String label, bool isActive, VoidCallback? onTap) {
      return GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: isActive
                  ? BoxDecoration(
                color: primaryPink.withOpacity(0.1),
                shape: BoxShape.circle,
              )
                  : null,
              child: Icon(icon, color: isActive ? primaryPink : const Color(0xFF4A4A6A), size: 24),
            ),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    color: isActive ? primaryPink : const Color(0xFF4A4A6A),
                    fontSize: 10,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500)),
          ],
        ),
      );
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: Container(
        height: 80 + MediaQuery.of(context).padding.bottom,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, -3),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
            top: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_filled, 'Home', currentIndex == 0, () {
                if (currentIndex != 0) Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              }),
              _buildNavItem(Icons.calendar_month_outlined, 'Calendar', currentIndex == 1, () {
                if (currentIndex != 1) Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const CalendarScreen()),
                );
              }),
              // Центральная кнопка
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(margin: const EdgeInsets.only(top: 8)),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: primaryPink,
                      child: const Icon(Icons.add, color: Colors.white, size: 28),
                    ),
                  ),
                ],
              ),
              _buildNavItem(Icons.medical_services_outlined, 'Health', currentIndex == 2, () {
                if (currentIndex != 2) Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HealthScreen()),
                );
              }),
              _buildNavItem(Icons.person_outline, 'Profile', currentIndex == 3, () {
                if (currentIndex != 3) Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}