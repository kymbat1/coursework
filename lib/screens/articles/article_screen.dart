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
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Color(0xFF4A4A6A), size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Улучшенная секция изображения
            _buildHeaderImage(context, article.imageName),

            // 2. Контент с улучшенным оформлением
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // Категория с чипом
                  _buildCategoryChip(),

                  const SizedBox(height: 16),

                  // Заголовок с градиентом
                  _buildTitleWithGradient(),

                  const SizedBox(height: 20),

                  // Автор и дата с улучшенным оформлением
                  _buildAuthorAndDate(),

                  const SizedBox(height: 28),

                  // Тело статьи с улучшенной типографикой
                  _buildEnhancedContent(),

                  const SizedBox(height: 40),

                  // Разделитель
                  _buildDivider(),

                  const SizedBox(height: 32),

                  // Статистика статьи
                  _buildArticleStats(),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),

      // Улучшенная нижняя навигация
      bottomNavigationBar: _buildEnhancedBottomNavigation(context),
    );
  }

  Widget _buildHeaderImage(BuildContext context, String imageName) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.35,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.1),
            Colors.transparent,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Основное изображение
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[200],
            // Для реального использования:
            // child: Image.asset(
            //   'assets/images/$imageName',
            //   fit: BoxFit.cover,
            // ),
          ),

          // Градиент поверх изображения
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Кнопка избранного в углу
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.favorite_border,
                color: darkTextColor,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: primaryPink.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'HEALTH',
        style: TextStyle(
          color: primaryPink,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildTitleWithGradient() {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [darkTextColor, darkTextColor.withOpacity(0.8)],
        tileMode: TileMode.clamp,
      ).createShader(bounds),
      child: Text(
        article.title,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          height: 1.3,
          color: Colors.white, // Цвет будет переопределен градиентом
        ),
      ),
    );
  }

  Widget _buildAuthorAndDate() {
    return Row(
      children: [
        // Аватар автора
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: primaryPink.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person,
            color: primaryPink,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.author,
                style: TextStyle(
                  color: darkTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                article.date,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        // Время чтения
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: lightPink,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.schedule, color: primaryPink, size: 14),
              const SizedBox(width: 4),
              Text(
                '5 min read',
                style: TextStyle(
                  color: primaryPink,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Первый абзац с выделением
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            article.content,
            style: TextStyle(
              color: darkTextColor.withOpacity(0.9),
              fontSize: 17,
              height: 1.7,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Цитата (если есть в данных)
        _buildQuoteWidget(),

        const SizedBox(height: 24),

        // Второй абзац (дополнительный контент)
        Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris...',
          style: TextStyle(
            color: darkTextColor.withOpacity(0.8),
            fontSize: 16,
            height: 1.6,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildQuoteWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: lightPink,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            color: primaryPink,
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.format_quote_rounded,
            color: primaryPink.withOpacity(0.7),
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            'Health is a state of complete harmony of the body, mind and spirit.',
            style: TextStyle(
              color: darkTextColor,
              fontSize: 16,
              fontStyle: FontStyle.italic,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '- Ancient Proverb',
            style: TextStyle(
              color: darkTextColor.withOpacity(0.6),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.shade200,
      height: 1,
      thickness: 1,
    );
  }

  Widget _buildArticleStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(Icons.favorite_border, '2.4K', 'Likes'),
        _buildStatItem(Icons.remove_red_eye_outlined, '15.2K', 'Views'),
        _buildStatItem(Icons.share_outlined, '342', 'Shares'),
        _buildStatItem(Icons.comment_outlined, '128', 'Comments'),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String count, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: lightPink,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: primaryPink, size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          count,
          style: TextStyle(
            color: darkTextColor,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

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
                .withFloatingAction(),
            _buildNavItem(Icons.medical_services_outlined, 'Health', false),
            _buildNavItem(Icons.person_outline, 'Profile', false),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
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
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// Extension для центральной кнопки
extension FloatingActionExtension on Widget {
  Widget withFloatingAction() {
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
          child: CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFFFF89AC),
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