// lib/screens/main_wrapper.dart (ФИНАЛЬНАЯ ВЕРСИЯ ПОД JAVA-БЭКЕНД)

import 'package:flutter/material.dart';

// 🎯 ИМПОРТЫ ЭКРАНОВ КОНТЕНТА
import 'calendar/cycle_calendar_screen.dart';
import 'doctors/doctor_list_screen.dart';
import 'home/home_screen.dart';
import 'profile/profile_screen.dart';

// Импорты аутентификации
import '../services/auth_service.dart';
import 'auth/login_screen.dart';

class MainWrapper extends StatefulWidget {
  final AuthService authService;
  const MainWrapper({super.key, required this.authService});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;
  final Color primaryColor = const Color(0xFFFF89AC);

  late final List<Widget> _screens;
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();

    _screens = [
      HomeScreen(),
      CycleCalendarContent(),
      DoctorListScreen(),
      ProfileScreen(authService: widget.authService),
    ];

    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      final user = await widget.authService.currentUser();
      setState(() {
        _isLoggedIn = user.isNotEmpty;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoggedIn = false;
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon, size: 28),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_isLoggedIn) {
      return LoginScreen(authService: widget.authService);
    }

    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    const double fixedBarHeight = 70.0;
    final double totalBarHeight = fixedBarHeight + bottomPadding;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        height: totalBarHeight,
        child: Container(
          height: totalBarHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: fixedBarHeight,
                child: BottomNavigationBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  selectedItemColor: primaryColor,
                  unselectedItemColor: Colors.grey.shade600,
                  selectedLabelStyle: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                      color: primaryColor),
                  unselectedLabelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      color: Colors.grey.shade600),
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                  items: <BottomNavigationBarItem>[
                    _buildNavItem(Icons.home_filled, "Home"),
                    _buildNavItem(Icons.calendar_month_outlined, "Calendar"),
                    _buildNavItem(Icons.medical_services_outlined, "Doctor"),
                    _buildNavItem(Icons.person_outline, "Profile"),
                  ],
                ),
              ),
              SizedBox(height: bottomPadding),
            ],
          ),
        ),
      ),
    );
  }
}
