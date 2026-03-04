// lib/screens/articles/article_screen.dart

import 'package:flutter/material.dart';
import '../../models/article.dart';

class ArticleScreen extends StatelessWidget {
  final Article article;

  const ArticleScreen({super.key, required this.article});

  final Color darkTextColor = const Color(0xFF4A4A6A);
  final Color primaryPink = const Color(0xFFFF89AC);
  final Color lightPink = const Color(0xFFFFF5F8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Article',
          style: TextStyle(
            color: darkTextColor,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: lightPink,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF4A4A6A),
              size: 16,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            article.content,
            style: TextStyle(
              color: darkTextColor,
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ),
      ),

      bottomNavigationBar: _buildEnhancedBottomNavigation(context),
    );
  }

  // ==============================
  // Bottom Navigation
  // ==============================

  Widget _buildEnhancedBottomNavigation(BuildContext context) {
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
            _buildNavItem(Icons.home_filled, 'Home', true),
            _buildNavItem(Icons.calendar_month_outlined, 'Calendar', false),
            _buildNavItem(Icons.add_circle_outlined, '', false)
                .withArticleFloatingAction(),
            _buildNavItem(Icons.medical_services_outlined, 'Health', false),
            _buildNavItem(Icons.person_outline, 'Profile', false),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, bool isActive) {
    return Column(
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
            color: isActive ? primaryPink : const Color(0xFF4A4A6A),
            size: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? primaryPink : const Color(0xFF4A4A6A),
            fontSize: 10,
            fontWeight:
            isActive ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ==============================
// УНИКАЛЬНЫЙ EXTENSION (без конфликта)
// ==============================

extension ArticleFloatingActionExtension on Widget {
  Widget withArticleFloatingAction() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: this,
        ),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFFFF89AC),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }
}