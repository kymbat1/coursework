// lib/screens/doctors/chat_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/doctor.dart';
import 'package:url_launcher/url_launcher.dart'; // Для симуляции звонка

// --- Вспомогательные экраны для оплаты ---

class PaymentSummaryScreen extends StatelessWidget {
  final Doctor doctor;
  final double totalCost = 8000.0; // Пример
  final double totalAdjustment = 1500.0; // Пример скидки
  final Color primaryPink = const Color(0xFFFF89AC);
  final Color darkTextColor = const Color(0xFF4A4A6A);

  const PaymentSummaryScreen({super.key, required this.doctor});

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'kk_KZ',
      symbol: '₸',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final toPay = totalCost - totalAdjustment;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Payment summary', style: TextStyle(color: darkTextColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: darkTextColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transaction for Consultation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // Врач
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: doctor.statusColor,
                    shape: BoxShape.circle,
                  ),
                  margin: const EdgeInsets.only(right: 8),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doctor.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: darkTextColor)),
                    Text(doctor.specialty, style: TextStyle(fontSize: 13, color: Colors.grey)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 25),

            // Детали оплаты
            _buildCostRow("Total Cost", totalCost, darkTextColor),
            _buildCostRow("Total Adjustment", -totalAdjustment, Colors.redAccent),
            const Divider(height: 30),
            _buildCostRow("To Pay", toPay, darkTextColor, isBold: true),
            const SizedBox(height: 20),

            // Промо
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.lightGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.discount, color: Colors.green, size: 20),
                  const SizedBox(width: 10),
                  Text('Save more with our promo!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Выбор оплаты
            Text('Select a payment method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: darkTextColor)),
            const SizedBox(height: 15),
            _buildPaymentMethodTile('Master Card', 'assets/mastercard.png', primaryPink),
            _buildPaymentMethodTile('Paypal', 'assets/paypal.png', Colors.grey),
            _buildPaymentMethodTile('Visa', 'assets/visa.png', Colors.grey),

            const Spacer(),

            // Кнопка оплаты
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const TransactionSuccessScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                child: const Text('Payment', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(String title, double amount, Color color, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: darkTextColor,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            (amount < 0 ? '-' : '') + formatCurrency(amount.abs()),
            style: TextStyle(
              fontSize: 16,
              color: color,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile(String name, String imagePath, Color dotColor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: dotColor == primaryPink ? primaryPink : Colors.transparent, width: 2),
      ),
      child: Row(
        children: [
          //  (Заглушка для иконки)
          Container(width: 40, height: 25, color: Colors.transparent),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: darkTextColor),
            ),
          ),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionSuccessScreen extends StatelessWidget {
  const TransactionSuccessScreen({super.key});

  final Color primaryPink = const Color(0xFFFF89AC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 80),
            ),
            const SizedBox(height: 30),
            const Text(
              'Transaction Successfully',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 150),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Возвращаемся к чату (или на главный экран чатов)
                  Navigator.popUntil(context, (route) => route.isFirst); // Пример: возвращение к корню навигации
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                child: const Text('Back to chat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// --- Основной экран чата ---

class ChatScreen extends StatefulWidget {
  final Doctor doctor;
  const ChatScreen({super.key, required this.doctor});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final Color primaryPink = const Color(0xFFFF89AC);
  final Color darkTextColor = const Color(0xFF4A4A6A);

  // Пример сообщений для демонстрации
  final List<Map<String, dynamic>> _messages = [
    {'text': 'How are you?', 'isMe': false},
    {'text': 'Im fine doc, can you give me article about Ovulation Production?', 'isMe': true},
    {
      'type': 'article',
      'title': 'Ovulation Periode for Your Health',
      'subtitle': 'Article about your health to periode ovulation',
      'isMe': false
    },
    {'text': 'how do you play when it tranferors from one side to anothers', 'isMe': true},
    {'text': 'why dont have emojis🤪', 'isMe': false},
    {'text': 'hi how do i off hints? i really hate that.', 'isMe': true},
  ];

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({'text': text, 'isMe': true});
    });
    _controller.clear();
    // Симуляция ответа доктора
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add({'text': 'Thank you for your question. I will respond shortly.', 'isMe': false});
      });
    });
  }

  void _makeCall(bool isVideo) async {
    final String url = isVideo ? 'tel:1234567890' : 'tel:1234567890'; // Замените на реальный URL для звонков/видео
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch ${isVideo ? "video" : "audio"} call.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: _buildAppBarTitle(),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: darkTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.videocam_outlined, color: darkTextColor),
            onPressed: () => _makeCall(true),
          ),
          IconButton(
            icon: Icon(Icons.call_outlined, color: darkTextColor),
            onPressed: () => _makeCall(false),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(15.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return _buildMessage(message);
              },
            ),
          ),
          _buildChatInput(context),
        ],
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.doctor.name,
          style: TextStyle(color: darkTextColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(
          widget.doctor.isOnline ? 'Online' : 'Offline',
          style: TextStyle(
            color: widget.doctor.statusColor,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    final isMe = message['isMe'] as bool;
    final type = message['type'] as String? ?? 'text';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? primaryPink : Colors.grey.shade100,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMe ? 20 : 5),
            bottomRight: Radius.circular(isMe ? 5 : 20),
          ),
        ),
        child: type == 'article' ? _buildArticleMessage(message) : _buildTextMessage(message, isMe),
      ),
    );
  }

  Widget _buildTextMessage(Map<String, dynamic> message, bool isMe) {
    return Text(
      message['text'] as String,
      style: TextStyle(
        color: isMe ? Colors.white : darkTextColor,
        fontSize: 15,
      ),
    );
  }

  Widget _buildArticleMessage(Map<String, dynamic> message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          //  (Заглушка)
          child: Center(child: Icon(Icons.article, color: primaryPink, size: 40)),
        ),
        const SizedBox(height: 10),
        Text(
          message['title'] as String,
          style: TextStyle(
            color: darkTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          message['subtitle'] as String,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildChatInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.sentiment_satisfied_alt_outlined, color: Colors.grey),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Emoji selector placeholder'))),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type a message',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
              onSubmitted: _sendMessage,
            ),
          ),
          IconButton(
            icon: Icon(Icons.attachment, color: Colors.grey),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Attach file placeholder'))),
          ),
          Container(
            decoration: BoxDecoration(
              color: primaryPink,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () => _sendMessage(_controller.text),
            ),
          ),
        ],
      ),
    );
  }
}