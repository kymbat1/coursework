import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/doctor.dart';
import 'chat_screen.dart'; // Предполагаем, что ChatScreen существует

class DoctorDetailScreen extends StatefulWidget {
  final Doctor doctor;
  const DoctorDetailScreen({super.key, required this.doctor});

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  final Color primaryPink = const Color(0xFFFF89AC);
  final Color darkTextColor = const Color(0xFF4A4A6A);
  final Color lightBackgroundColor = const Color(0xFFFDEEF2);

  // --- Состояния для выбора даты и времени ---
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;

  final List<String> _availableTimes = [
    '09:00',
    '10:30',
    '12:00',
    '14:30',
    '16:00',
    '17:30'
  ];

  // Форматирование цены
  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'kk_KZ',
      symbol: '₸',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  // --- WIDGETS ---

  // 1. Секция с аватаром и основной информацией
  Widget _buildHeader(BuildContext context) {
    final doctor = widget.doctor;
    final isFemale = doctor.gender == 'Female';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Аватар
              CircleAvatar(
                radius: 45,
                backgroundColor: lightBackgroundColor,
                child: Icon(
                  isFemale ? Icons.person_3_rounded : Icons.person_rounded,
                  color: primaryPink,
                  size: 50,
                ),
              ),
              const SizedBox(width: 20),
              // Имя и специальность
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: darkTextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctor.specialty,
                      style: TextStyle(
                        fontSize: 16,
                        color: primaryPink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Рейтинг и Отзывы
                    Row(
                      children: [
                        Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                        const SizedBox(width: 5),
                        Text(
                          '${doctor.rating.toStringAsFixed(1)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: darkTextColor,
                          ),
                        ),
                        Text(
                          ' (140 Reviews)',
                          style: TextStyle(
                            fontSize: 14,
                            color: darkTextColor.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Краткое описание
          Text(
            "Dr. ${doctor.name.split(' ')[1]} is a dedicated specialist with 10+ years of experience in treating women's health issues. Focused on fertility and hormonal balance.",
            style: TextStyle(
              fontSize: 15,
              color: darkTextColor.withOpacity(0.8),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // 2. Секция выбора даты и времени
  Widget _buildScheduleSection() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Appointment Time',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: darkTextColor,
            ),
          ),
          const SizedBox(height: 15),

          // Выбор Дня
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7, // На неделю вперед
              itemBuilder: (context, index) {
                final date = DateTime.now().add(Duration(days: index));
                final isSelected =
                    date.day == _selectedDate.day && date.month == _selectedDate.month;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                      _selectedTime = null; // Сбрасываем время при смене дня
                    });
                  },
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      color: isSelected ? primaryPink : lightBackgroundColor,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isSelected ? primaryPink : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('EEE').format(date), // Day name
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : darkTextColor.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          DateFormat('d').format(date), // Day number
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: isSelected ? Colors.white : darkTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // Выбор Времени
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _availableTimes.map((time) {
              final isSelected = time == _selectedTime;
              return ChoiceChip(
                label: Text(time),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedTime = selected ? time : null;
                  });
                },
                selectedColor: primaryPink.withOpacity(0.9),
                backgroundColor: lightBackgroundColor,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : darkTextColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // 3. Секция отзывов (заглушка)
  Widget _buildReviewSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Patient Reviews (140)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: darkTextColor,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Действие для просмотра всех отзывов
                },
                child: Text('See All', style: TextStyle(color: primaryPink)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Карточка отзыва
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: darkTextColor.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(radius: 18, child: Icon(Icons.person)),
                    const SizedBox(width: 10),
                    Text('Aruzhan K.', style: TextStyle(fontWeight: FontWeight.bold, color: darkTextColor)),
                    const Spacer(),
                    Icon(Icons.star, color: Colors.amber, size: 18),
                    Text(' 5.0', style: TextStyle(fontWeight: FontWeight.bold, color: darkTextColor)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'The consultation was very informative and helpful. Highly recommend the doctor!',
                  style: TextStyle(color: darkTextColor.withOpacity(0.8)),
                ),
                const SizedBox(height: 5),
                Text('2 days ago', style: TextStyle(fontSize: 12, color: darkTextColor.withOpacity(0.5))),
              ],
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // --- ОСНОВНАЯ СТРУКТУРА ЭКРАНА ---
    return Scaffold(
      backgroundColor: lightBackgroundColor.withOpacity(0.5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: darkTextColor),
        actions: [
          IconButton(
            icon: Icon(Icons.chat_bubble_outline_rounded, color: primaryPink),
            onPressed: () {
              // Переход на чат с этим доктором
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(doctor: widget.doctor),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite_border, color: primaryPink),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Added to Favourites!')),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100), // Отступ для фиксированной кнопки
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildScheduleSection(),
            const Divider(height: 30, thickness: 1, indent: 24, endIndent: 24),
            _buildReviewSection(),
            const SizedBox(height: 20),
          ],
        ),
      ),

      // --- ФИКСИРОВАННАЯ КНОПКА ЗАПИСИ ---
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: darkTextColor.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Цена
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Consultation Fee',
                  style: TextStyle(
                    fontSize: 14,
                    color: darkTextColor.withOpacity(0.6),
                  ),
                ),
                Text(
                  _formatCurrency(widget.doctor.consultationFee),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: primaryPink,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            // Кнопка Записи
            Expanded(
              child: ElevatedButton(
                onPressed: _selectedTime != null
                    ? () {
                  final formattedDate = DateFormat('dd MMM yyyy').format(_selectedDate);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Appointment booked with Dr. ${widget.doctor.name.split(' ')[1]} on $formattedDate at $_selectedTime!',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: primaryPink,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
                    : null, // Кнопка неактивна, пока не выбрано время
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPink,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Book Appointment',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}