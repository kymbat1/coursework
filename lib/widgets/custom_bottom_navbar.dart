// lib/widgets/custom_bottom_navbar.dart
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTabTapped;

  const CustomBottomNavigationBar({
    super.key,
    this.currentIndex = 0,
    this.onTabTapped,
  });

  static const Color primaryPink = Color(0xFFFF89AC);
  static const Color darkTextColor = Color(0xFF4A4A6A);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            _buildNavItem(context, Icons.home_filled, 'Home', 0),
            _buildNavItem(context, Icons.calendar_month_outlined, 'Calendar', 1),
            _buildNavItem(context, Icons.add_circle_outlined, '', -1).withFloatingAction(),
            _buildNavItem(context, Icons.medical_services_outlined, 'Health', 3),
            _buildNavItem(context, Icons.person_outline, 'Profile', 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index) {
    final bool isActive = index == currentIndex;
    return GestureDetector(
      onTap: () {
        if (index >= 0 && onTabTapped != null) {
          onTabTapped!(index);
        }
      },
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
            child: Icon(
              icon,
              color: isActive ? primaryPink : darkTextColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? primaryPink : darkTextColor,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Extension для центральной кнопки "+"
extension FloatingActionExtension on Widget {
  Widget withFloatingAction() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(margin: const EdgeInsets.only(top: 8), child: this),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const CircleAvatar(
            radius: 24,
            backgroundColor: primaryPink,
            child: Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ],
    );
  }
}