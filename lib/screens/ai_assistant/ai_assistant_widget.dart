// lib/screens/ai_assistant/ai_assistant_widget.dart

import 'package:flutter/material.dart';

// (Модель ChatMessage останется в этом файле для простоты)
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isUser, required this.timestamp});
}

class AiAssistantWidget extends StatefulWidget {
  const AiAssistantWidget({super.key});

  @override
  State<AiAssistantWidget> createState() => _AiAssistantWidgetState();
}

class _AiAssistantWidgetState extends State<AiAssistantWidget> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final Color primaryPink = const Color(0xFFFF89AC);
  final Color darkTextColor = const Color(0xFF4A4A6A);

  // Ограничиваем высоту виджета, чтобы он был частью скролла Home
  static const double _widgetHeight = 400;

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Здравствуйте! Я ваша анонимная ИИ-помощница. Задайте мне вопрос о вашем здоровье.",
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ];

  void _handleSubmitted(String text) {
    // ... (логика отправки и имитации ответа остается такой же, как в предыдущем ответе)
    if (text.trim().isEmpty) return;

    _textController.clear();
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });

    _simulateAiResponse(text);
    _scrollToBottom();
  }

  void _simulateAiResponse(String userText) {
    String response;
    if (userText.toLowerCase().contains('цикл') || userText.toLowerCase().contains('период')) {
      response = "Я могу предоставить информацию о фазах цикла. Уточните, что вас интересует?";
    } else {
      response = "Спасибо за ваш вопрос. Я обрабатываю информацию. Пожалуйста, поделитесь подробностями о вашем самочувствии.";
    }

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(ChatMessage(
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _scrollToBottom();
      });
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _widgetHeight, // Фиксированная высота для интеграции в SingleChildScrollView
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          // Заголовок виджета
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 8.0, left: 15.0),
            child: Row(
              children: [
                Icon(Icons.psychology_outlined, color: primaryPink, size: 28),
                const SizedBox(width: 8),
                Text('Ваш Анонимный Ассистент', style: TextStyle(color: darkTextColor, fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
          ),
          const Divider(height: 1.0, color: Color(0xFFFDEEF2)),

          // Список сообщений
          Flexible(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (_, int index) => _buildMessageBubble(_messages[index]),
            ),
          ),

          // Поле ввода
          _buildTextComposer(),
        ],
      ),
    );
  }

  // (Методы _buildMessageBubble и _buildTextComposer остаются такими же, как в предыдущем ответе,
  // но должны быть скопированы сюда)

  Widget _buildMessageBubble(ChatMessage message) {
    final bool isUser = message.isUser;
    // ... (код сообщения)
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (!isUser)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                backgroundColor: primaryPink.withOpacity(0.1),
                child: Icon(Icons.psychology_outlined, color: primaryPink, size: 20),
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: isUser ? primaryPink.withOpacity(0.9) : const Color(0xFFFDEEF2), // Немного светлее для фона Home
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: isUser ? const Radius.circular(18) : const Radius.circular(4),
                  bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isUser ? Colors.white : darkTextColor,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          if (isUser)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                backgroundColor: darkTextColor.withOpacity(0.1),
                child: Icon(Icons.person_outline, color: darkTextColor, size: 20),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0, top: 5.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0), // Более нейтральный фон для Home Screen
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: const InputDecoration.collapsed(
                hintText: "Напишите...",
              ),
              textInputAction: TextInputAction.send,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              icon: Icon(Icons.send, color: primaryPink),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ),
        ],
      ),
    );
  }
}