import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  final Color primaryPink = const Color(0xFFFF89AC);
  final Color darkTextColor = const Color(0xFF4A4A6A);
  final Color lightBackgroundColor = const Color(0xFFFDEEF2);

  // Список часто задаваемых вопросов (FAQ)
  final List<Map<String, String>> faqItems = const [
    {
      'question': 'Как правильно начать цикл?',
      'answer': 'Цикл начинается с первого дня менструации. Вам нужно отметить этот день в календаре, чтобы приложение начало расчеты.'
    },
    {
      'question': 'Насколько точны прогнозы?',
      'answer': 'Прогнозы овуляции и периода основаны на внесенных вами данных. Чем регулярнее вы вносите информацию (длительность цикла, настроение, симптомы), тем точнее становятся расчеты.'
    },
    {
      'question': 'Как сбросить данные цикла?',
      'answer': 'Перейдите в "Профиль" -> "Период и Овуляция" и нажмите "Сброс данных". Все предыдущие записи будут удалены.'
    },
    {
      'question': 'Могу ли я добавить свои симптомы?',
      'answer': 'Да, вы можете добавлять пользовательские симптомы и заметки через основное окно календаря, выбирая конкретный день.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Справочный центр и FAQ',
          style: TextStyle(
            color: darkTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryPink),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Секция FAQ ---
            Text(
              'Часто задаваемые вопросы',
              style: TextStyle(
                color: darkTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 15),

            Container(
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
                children: faqItems.map((item) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent, // Убираем разделители
                    ),
                    child: ExpansionTile(
                      // Иконка перед заголовком
                      leading: Icon(
                        Icons.info_outline,
                        color: primaryPink,
                      ),
                      // Заголовок вопроса
                      title: Text(
                        item['question']!,
                        style: TextStyle(
                          color: darkTextColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      // Стиль для стрелки
                      iconColor: primaryPink,
                      collapsedIconColor: Colors.grey,
                      // Тело ответа
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15, top: 5),
                          child: Text(
                            item['answer']!,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 40),

            // --- Секция Поддержки ---
            Text(
              'Связаться с нами',
              style: TextStyle(
                color: darkTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 15),

            _buildContactCard(
              icon: Icons.email_outlined,
              title: 'Написать на Email',
              subtitle: 'Отправьте нам подробное сообщение',
              action: () => _showSnackbar(context, 'Открытие почтового клиента...'),
            ),
            const SizedBox(height: 15),
            _buildContactCard(
              icon: Icons.support_agent_outlined,
              title: 'Чат поддержки',
              subtitle: 'Ответ в течение 24 часов',
              action: () => _showSnackbar(context, 'Открытие чата поддержки...'),
            ),

            const SizedBox(height: 40),

            // Информация о приложении
            Center(
              child: Text(
                'Health Cycle v1.0.0',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Вспомогательный виджет для карточки контактов
  Widget _buildContactCard({required IconData icon, required String title, required String subtitle, required VoidCallback action}) {
    return InkWell(
      onTap: action,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: primaryPink.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: primaryPink.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryPink.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: primaryPink, size: 30),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: darkTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  // Вспомогательная функция для всплывающего уведомления
  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 700),
      ),
    );
  }
}