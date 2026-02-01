import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/doctor.dart';
import 'doctor_detail_screen.dart';
import 'chat_screen.dart';
// Импортируем новый экран
import 'all_doctors_screen.dart';

// Импортируем Product и dummyDoctors, если они определены в doctor.dart
// Обратите внимание: dummyProducts больше не используются в этом файле.
import '../../models/doctor.dart' show dummyDoctors;

// Добавим заглушку для экрана списка чатов
class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Chats'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: const Center(
        child: Text('This is the list of your active chats!'),
      ),
    );
  }
}

class DoctorListScreen extends StatelessWidget {
  const DoctorListScreen({super.key});

  final Color primaryPink = const Color(0xFFFF89AC);
  final Color darkTextColor = const Color(0xFF4A4A6A);
  final Color lightBackgroundColor = const Color(0xFFFDEEF2);

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'kk_KZ',
      symbol: '₸',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  void _navigateToChatList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChatListScreen(),
      ),
    );
  }

  void _navigateToUniqueChat(BuildContext context, Doctor doctor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          doctor: doctor,
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting unique chat with Dr. ${doctor.name.split(' ')[1]}!'),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Telemedicine',
          style: TextStyle(
            color: darkTextColor,
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: darkTextColor),
        automaticallyImplyLeading: false,

        actions: [
          IconButton(
            icon: Icon(Icons.chat_bubble_outline_rounded, color: darkTextColor, size: 24),
            onPressed: () => _navigateToChatList(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        // Уменьшаем отступ сверху, но сохраняем горизонтальные
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 24), // Увеличенный отступ снизу
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 30),

            // Рекомендуемые врачи
            _buildSectionHeader(
              'Recommended Doctors',
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllDoctorsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),

            // Список рекомендованных врачей
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dummyDoctors.length,
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              itemBuilder: (context, index) {
                // Ограничим список до 3 врачей, чтобы стимулировать переход на "See All"
                if (index >= 3) return const SizedBox.shrink();
                return _buildDoctorCard(context, dummyDoctors[index]);
              },
            ),

            // УДАЛЕНА СЕКЦИЯ Health Products

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: lightBackgroundColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: primaryPink.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Search doctor or specialist',
          hintStyle: TextStyle(color: Color(0xFF4A4A6A), fontSize: 16),
          prefixIcon: Icon(Icons.search, color: Color(0xFFFF89AC), size: 24),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 15),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: darkTextColor,
          ),
        ),
        TextButton(
          onPressed: onSeeAll,
          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(50, 30)),
          child: Text(
            "See All",
            style: TextStyle(color: primaryPink, fontWeight: FontWeight.w700, fontSize: 15),
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorCard(BuildContext context, Doctor doctor) {
    final bool isFemale = doctor.gender == 'Female';

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorDetailScreen(doctor: doctor),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: darkTextColor.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: lightBackgroundColor,
                  child: Icon(
                    isFemale ? Icons.person_3_rounded : Icons.person_rounded,
                    color: primaryPink,
                    size: 40,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: doctor.statusColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: darkTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.stars, color: Colors.amber, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        '${doctor.rating.toStringAsFixed(1)}% Positive',
                        style: TextStyle(
                          fontSize: 14,
                          color: darkTextColor.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    doctor.specialty,
                    style: TextStyle(
                      fontSize: 14,
                      color: primaryPink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatCurrency(doctor.consultationFee),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: darkTextColor,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _navigateToUniqueChat(context, doctor),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPink,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Chat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- УДАЛЕННЫЙ WIDGET: _buildProductList() ---

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }
}