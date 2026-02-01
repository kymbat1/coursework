// lib/screens/calendar/cycle_calendar_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

// *** ВАЖНО: ПАКЕТЫ ДОЛЖНЫ БЫТЬ В pubspec.yaml ***
import 'package:table_calendar/table_calendar.dart';
import '../../models/doctor.dart'; // Предполагается наличие этой модели
import '../../models/mood.dart';   // Предполагается наличие этой модели (и moodsData)
import '../../models/article.dart'; // Предполагается наличие этой модели
import '../doctors/doctor_list_screen.dart'; // Предполагается наличие этого экрана
import '../notifications/notification_screen.dart'; // Предполагается наличие этого экрана
import '../main_wrapper.dart'; // Предполагается наличие этого экрана

// НОВЫЙ ИМПОРТ ДЛЯ ИМЕНИ ПОЛЬЗОВАТЕЛЯ
import '../../services/user_service.dart';

// Вспомогательная функция для сравнения дат
bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

// ====================================================================
// --- SCREEN: ArticleDetailScreen (Экран для чтения) ---
// ====================================================================

class ArticleDetailScreen extends StatelessWidget {
  final Article article;
  final Color darkTextColor = const Color(0xFF4A4A6A);

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: true,
            pinned: true,
            snap: false,
            backgroundColor: article.accentColor.withOpacity(0.9),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
              title: Text(
                article.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [article.accentColor, article.accentColor.withOpacity(0.7)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: Icon(article.icon, size: 80, color: Colors.white.withOpacity(0.8)),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${article.subtitle} • 3 мин чтения',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Divider(height: 30),
                      Text(
                        article.content,
                        style: TextStyle(
                          fontSize: 17,
                          height: 1.6,
                          color: darkTextColor,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: article.accentColor,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)
                              )
                          ),
                          child: const Text('Вернуться к списку', style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ====================================================================
// --- SCREEN: ArticleListScreen (Список статей с поиском) ---
// ====================================================================

class ArticleListScreen extends StatefulWidget {
  final Color primaryPink = const Color(0xFFFF89AC);
  final Color darkTextColor = const Color(0xFF4A4A6A);
  final Color lightBackgroundColor = const Color(0xFFFDEEF2);

  const ArticleListScreen({
    super.key,
  });

  @override
  State<ArticleListScreen> createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  String _searchQuery = '';
  late List<Article> _filteredArticles;

  // ЛОКАЛЬНАЯ КОПИЯ ДЛЯ ArticleListScreen
  final List<Article> _articlesData = [
    Article(
      title: "Месячные: что нормально?",
      subtitle: "Ответы для юных девушек.",
      bgColor: const Color(0xFFF2E6F5),
      accentColor: const Color(0xFFB17DCE),
      icon: Icons.girl,
      content: "Первые месячные, или менархе, — это важный этап. Главное — помнить: каждая женщина уникальна, и цикл может сильно отличаться. Нормальный цикл длится от 21 до 35 дней. Если цикл очень болезненный или нерегулярный дольше года, стоит проконсультироваться с врачом. Не стесняйтесь говорить об этом! Наш ИИ-помощник всегда готов анонимно ответить на любые вопросы.",
    ),
    Article(
      title: "Ищем своего маммолога",
      subtitle: "Как подготовиться к первому приему.",
      bgColor: const Color(0xFFF9E7D8),
      accentColor: const Color(0xFFD3A47A),
      icon: Icons.medical_services_outlined,
      content: "Для многих девушек и женщин осмотр маммолога или гинеколога может быть стрессом, особенно если врач мужчина. На нашей платформе вы найдете только женщин-специалистов. Перед приемом составьте список вопросов, которые вас волнуют. Вы имеете полное право попросить ассистента присутствовать на осмотре, если это сделает вас спокойнее. Читайте отзывы других женщин!",
    ),
    Article(
      title: "5 минут для ментального здоровья",
      subtitle: "Простые практики для снятия стресса.",
      bgColor: const Color(0xFFDDF5F2),
      accentColor: const Color(0xFF7AD3BB),
      icon: Icons.self_improvement,
      content: "Стресс влияет на гормональный фон. Попробуйте дыхание '4-7-8': 4 секунды вдох, 7 секунд задержка, 8 секунд выдох. Это мгновенно успокаивает нервную систему. Или просто выделите 5 минут, чтобы послушать любимую музыку без отвлечений. Регулярные медитации, которые мы предлагаем в разделе 'Ментальное здоровье', также помогают стабилизировать цикл.",
    ),
  ];


  @override
  void initState() {
    super.initState();
    _filteredArticles = _articlesData;
  }

  void _filterArticles(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredArticles = _articlesData;
      } else {
        _filteredArticles = _articlesData.where((article) {
          final titleLower = article.title.toLowerCase();
          final contentLower = article.content.toLowerCase();
          final searchLower = query.toLowerCase();

          return titleLower.contains(searchLower) || contentLower.contains(searchLower);
        }).toList();
      }
    });
  }

  Widget _buildListItem(Article article) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(article: article),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: widget.darkTextColor.withOpacity(0.1), width: 1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: article.accentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(article.icon, color: article.accentColor, size: 28),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: widget.darkTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    article.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: widget.darkTextColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: widget.darkTextColor.withOpacity(0.4), size: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.lightBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Все статьи',
          style: TextStyle(
            color: widget.darkTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: widget.lightBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: widget.darkTextColor),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20, top: 10),
              child: TextField(
                onChanged: _filterArticles,
                decoration: InputDecoration(
                  hintText: 'Поиск по статьям...',
                  hintStyle: TextStyle(color: widget.darkTextColor.withOpacity(0.5)),
                  prefixIcon: Icon(Icons.search, color: widget.primaryPink),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
              ),
            ),
            Expanded(
              child: _filteredArticles.isEmpty
                  ? Center(
                child: Text(
                  _searchQuery.isEmpty ? 'Статьи не найдены.' : 'Статьи по запросу "$_searchQuery" не найдены.',
                  style: TextStyle(color: widget.darkTextColor.withOpacity(0.7), fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: _filteredArticles.length,
                itemBuilder: (context, index) {
                  return _buildListItem(_filteredArticles[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================================================
// --- DIALOG WIDGET: ОКНО ВЫБОРА ЭМОЦИЙ ---
// ====================================================================

class MoodSelectionDialog extends StatelessWidget {
  final Function(Mood) onSelectMood;
  final Color primaryPink;
  final Color darkTextColor;

  const MoodSelectionDialog({
    super.key,
    required this.onSelectMood,
    required this.primaryPink,
    required this.darkTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 8),
      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Choose Your Mood',
        style: TextStyle(
          color: darkTextColor,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.9,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: moodsData.length,
          itemBuilder: (context, index) {
            final mood = moodsData[index];
            return InkWell(
              onTap: () {
                onSelectMood(mood);
                Navigator.of(context).pop();
              },
              borderRadius: BorderRadius.circular(15),
              child: Container(
                decoration: BoxDecoration(
                    color: mood.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: mood.color.withOpacity(0.5), width: 1.5)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(mood.icon, size: 35, color: mood.color),
                    const SizedBox(height: 5),
                    Text(
                      mood.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: darkTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ====================================================================
// --- CUSTOM PAINTER: ЭЛЕГАНТНОЕ КРАСИВОЕ СЕРДЦЕ ---
// ====================================================================

class ElegantHeartPainter extends CustomPainter {
  final Gradient gradient;
  final Color shadowColor;

  ElegantHeartPainter({required this.gradient, required this.shadowColor});

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    Path path = Path();

    path.moveTo(width / 2, height * 0.9);
    path.cubicTo(
      width, height * 0.55,
      width * 0.85, height * 0.1,
      width / 2, height * 0.25,
    );
    path.cubicTo(
      width * 0.15, height * 0.1,
      0, height * 0.55,
      width / 2, height * 0.9,
    );
    path.close();

    final Paint shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10.0);
    canvas.drawPath(path.shift(const Offset(0, 12)), shadowPaint);

    final Rect rect = Offset.zero & size;
    final Paint fillPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is ElegantHeartPainter && oldDelegate.gradient != gradient;
  }
}

// ====================================================================
// --- NEW SCREEN: CycleHistoryCalendar (Полный календарь с историей) ---
// ====================================================================

class CycleHistoryCalendar extends StatelessWidget {
  final Set<DateTime> periodDays;
  final Color primaryPink = const Color(0xFFFF89AC);
  final Color darkTextColor = const Color(0xFF4A4A6A);

  const CycleHistoryCalendar({super.key, required this.periodDays});

  // Функция для проверки, является ли день днем месячных
  bool _isPeriodDay(DateTime day) {
    // Сравниваем только год, месяц и день, игнорируя время
    return periodDays.contains(DateTime(day.year, day.month, day.day));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'История цикла',
            style: TextStyle(color: darkTextColor, fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: darkTextColor),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TableCalendar(
            locale: 'ru_RU', // Важно для локализации
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2027, 12, 31),
            focusedDay: DateTime(2025, 11, 6), // Фокусируем на запрошенной дате
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(color: darkTextColor, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(color: primaryPink.withOpacity(0.2), shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(color: primaryPink, shape: BoxShape.circle),
              outsideDaysVisible: false,
              markersAlignment: Alignment.bottomCenter,
              defaultTextStyle: TextStyle(color: darkTextColor),
              weekendTextStyle: TextStyle(color: darkTextColor.withOpacity(0.7)),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                if (_isPeriodDay(day)) {
                  return Container(
                    margin: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: primaryPink.withOpacity(0.6), // РОЗОВЫЙ ФОН для месячных
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  );
                }
                return null;
              },
            ),
            selectedDayPredicate: (day) {
              return false;
            },
            onPageChanged: (focusedDay) {
              // Для обработки смены месяца
            },
          ),
        ),
      ),
    );
  }
}

// ====================================================================
// --- DIALOG WIDGET: PeriodTrackerDialog (Отметка месячных) ---
// ====================================================================

class PeriodTrackerDialog extends StatefulWidget {
  final Function(DateTime start, DateTime end) onSave;
  final Color primaryPink;

  const PeriodTrackerDialog({super.key, required this.onSave, required this.primaryPink});

  @override
  State<PeriodTrackerDialog> createState() => _PeriodTrackerDialogState();
}

class _PeriodTrackerDialogState extends State<PeriodTrackerDialog> {
  DateTime? _startDate;
  DateTime? _endDate;
  final Color darkTextColor = const Color(0xFF4A4A6A);

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
      helpText: isStart ? 'Дата начала' : 'Дата окончания',
      cancelText: 'Отмена',
      confirmText: 'Подтвердить',
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: widget.primaryPink,
              onPrimary: Colors.white,
              onSurface: darkTextColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: widget.primaryPink),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool canSave = _startDate != null && _endDate != null && _endDate!.isAfter(_startDate!.subtract(const Duration(days: 1)));

    return AlertDialog(
      title: Text('Отметить месячные', style: TextStyle(color: darkTextColor, fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDateButton('Начало', _startDate, true),
          const SizedBox(height: 15),
          _buildDateButton('Конец', _endDate, false),
          const SizedBox(height: 15),
          if (_startDate != null && _endDate != null && !canSave)
            Text(
              'Дата окончания должна быть позже даты начала.',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Отмена', style: TextStyle(color: darkTextColor)),
        ),
        ElevatedButton(
          onPressed: canSave ? () {
            widget.onSave(_startDate!, _endDate!);
            Navigator.of(context).pop();
          } : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.primaryPink,
          ),
          child: const Text('Сохранить', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildDateButton(String label, DateTime? date, bool isStart) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.primaryPink.withOpacity(0.5), width: 1.5),
      ),
      child: ListTile(
        onTap: () => _selectDate(context, isStart),
        leading: Icon(isStart ? Icons.calendar_today : Icons.event_busy, color: widget.primaryPink),
        title: Text(label, style: TextStyle(color: darkTextColor, fontWeight: FontWeight.w600)),
        trailing: Text(
          date == null ? 'Выберите дату' : DateFormat('dd MMMM yyyy', 'ru_RU').format(date),
          style: TextStyle(color: darkTextColor.withOpacity(0.8), fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}


// ====================================================================
// --- ОСНОВНОЙ КОНТЕНТ: CycleCalendarContent ---
// ====================================================================

class CycleCalendarContent extends StatefulWidget {
  const CycleCalendarContent({super.key});

  @override
  State<CycleCalendarContent> createState() => _CycleCalendarContentState();
}

class _CycleCalendarContentState extends State<CycleCalendarContent>
    with SingleTickerProviderStateMixin {

  // НОВОЕ ПОЛЕ: Сервис пользователя
  late UserService _userService;

  DateTime _selectedDay = DateTime.now();
  Mood? _selectedMood;

  late AnimationController _heartAnimationController;
  late Animation<double> _heartScaleAnimation;

  final int cycleDay = 10;
  final double probability = 12.4;

  // ==================== ДАННЫЕ ЦИКЛА ====================
  Set<DateTime> _trackedPeriodDays = {};

  // ФИКЦИВНАЯ ИСТОРИЯ МЕСЯЧНЫХ (сентябрь/октябрь 2025)
  final List<List<DateTime>> _periodHistory = [
    [DateTime(2025, 10, 2), DateTime(2025, 10, 6)],
    [DateTime(2025, 9, 5), DateTime(2025, 9, 9)],
  ];

  // ДАТА, КОТОРУЮ МЫ ОТОБРАЖАЕМ В КАЧЕСТВЕ ТЕКУЩЕЙ (6 ноября 2025)
  final DateTime _displayDate = DateTime(2025, 11, 6);
  // ============================================================

  final Color primaryPink = const Color(0xFFFF89AC);
  final Color darkTextColor = const Color(0xFF4A4A6A);
  final Color lightBackgroundColor = const Color(0xFFFDEEF2);

  // ВОССТАНОВЛЕННЫЙ СПИСОК СТАТЕЙ
  final List<Article> _articlesData = [
    Article(
      title: "Месячные: что нормально?",
      subtitle: "Ответы для юных девушек.",
      bgColor: const Color(0xFFF2E6F5),
      accentColor: const Color(0xFFB17DCE),
      icon: Icons.girl,
      content: "Первые месячные, или менархе, — это важный этап. Главное — помнить: каждая женщина уникальна, и цикл может сильно отличаться. Нормальный цикл длится от 21 до 35 дней. Если цикл очень болезненный или нерегулярный дольше года, стоит проконсультироваться с врачом. Не стесняйтесь говорить об этом! Наш ИИ-помощник всегда готов анонимно ответить на любые вопросы.",
    ),
    Article(
      title: "Ищем своего маммолога",
      subtitle: "Как подготовиться к первому приему.",
      bgColor: const Color(0xFFF9E7D8),
      accentColor: const Color(0xFFD3A47A),
      icon: Icons.medical_services_outlined,
      content: "Для многих девушек и женщин осмотр маммолога или гинеколога может быть стрессом, особенно если врач мужчина. На нашей платформе вы найдете только женщин-специалистов. Перед приемом составьте список вопросов, которые вас волнуют. Вы имеете полное право попросить ассистента присутствовать на осмотре, если это сделает вас спокойнее. Читайте отзывы других женщин!",
    ),
    Article(
      title: "5 минут для ментального здоровья",
      subtitle: "Простые практики для снятия стресса.",
      bgColor: const Color(0xFFDDF5F2),
      accentColor: const Color(0xFF7AD3BB),
      icon: Icons.self_improvement,
      content: "Стресс влияет на гормональный фон. Попробуйте дыхание '4-7-8': 4 секунды вдох, 7 секунд задержка, 8 секунд выдох. Это мгновенно успокаивает нервную систему. Или просто выделите 5 минут, чтобы послушать любимую музыку без отвлечений. Регулярные медитации, которые мы предлагаем в разделе 'Ментальное здоровье', также помогают стабилизировать цикл.",
    ),
  ];


  @override
  void initState() {
    super.initState();

    // Инициализация сервиса пользователя и установка имени
    _userService = UserService();
    // Устанавливаем фиктивное имя для демонстрации
    _userService.setUserName("Тестовый", "Пользователь");

    _heartAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _heartScaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _heartAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _selectedMood = moodsData.first;
    _generateTrackedPeriods();
  }

  void _generateTrackedPeriods() {
    final Set<DateTime> days = {};
    for (var period in _periodHistory) {
      final start = period[0];
      final end = period[1];
      for (int i = 0; i <= end.difference(start).inDays; i++) {
        days.add(DateTime(start.year, start.month, start.day).add(Duration(days: i)));
      }
    }
    _trackedPeriodDays = days;
  }

  @override
  void dispose() {
    _heartAnimationController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day) {
    setState(() {
      _selectedDay = day;
      final format = DateFormat('d MMMM yyyy', 'ru_RU');
      _showSnackbar('Выбран день: ${format.format(day)}');
    });
  }

  void _showAllMoodsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MoodSelectionDialog(
          primaryPink: primaryPink,
          darkTextColor: darkTextColor,
          onSelectMood: (mood) {
            setState(() {
              _selectedMood = mood;
            });
            _showSnackbar('Настроение "${mood.name}" выбрано!');
          },
        );
      },
    );
  }

  void _showPeriodTrackerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PeriodTrackerDialog(
          primaryPink: primaryPink,
          onSave: (start, end) {
            setState(() {
              _periodHistory.add([start, end]);
              _generateTrackedPeriods();
            });
            _showSnackbar('Цикл успешно отмечен: ${DateFormat('dd.MM.yy').format(start)} - ${DateFormat('dd.MM.yy').format(end)}');
          },
        );
      },
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: darkTextColor,
        duration: const Duration(milliseconds: 800),
      ),
    );
  }

  void _navigateToNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationScreen()),
    );
  }

  void _navigateToAllArticles(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ArticleListScreen()),
    );
  }

  void _showCycleHistoryCalendar(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CycleHistoryCalendar(periodDays: _trackedPeriodDays),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: lightBackgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, _userService.userName), // ПЕРСОНАЛИЗИРОВАННОЕ ИМЯ
              const SizedBox(height: 35),
              _buildAnimatedElegantHeartCard(cycleDay, probability),
              const SizedBox(height: 35),
              _buildCalendarSection(_displayDate),
              const SizedBox(height: 35),
              _buildPeriodTrackerButton(),
              const SizedBox(height: 35),
              _buildMoodSection(),
              const SizedBox(height: 35),
              _buildArticlesSection(context),
              SizedBox(height: 10 + MediaQuery.of(context).padding.bottom + 80),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildPeriodTrackerButton() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: _showPeriodTrackerDialog,
        icon: const Icon(Icons.water_drop_outlined, color: Colors.white, size: 20),
        label: const Text('Отметить месячные', style: TextStyle(color: Colors.white, fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPink,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: darkTextColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (onTap != null)
          TextButton(
            onPressed: onTap,
            child: Text(
              'See All',
              style: TextStyle(
                color: primaryPink,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildArticlesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          "Read & Grow",
          onTap: () => _navigateToAllArticles(context),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _articlesData.length,
            itemBuilder: (context, index) {
              final article = _articlesData[index];
              return _buildHorizontalArticleCard(context, article);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalArticleCard(BuildContext context, Article article) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ArticleDetailScreen(article: article)),
        );
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: article.bgColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(article.icon, color: article.accentColor, size: 30),
            const SizedBox(height: 8),
            Text(
              article.title,
              style: TextStyle(
                color: darkTextColor,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              article.subtitle,
              style: TextStyle(
                color: darkTextColor.withOpacity(0.7),
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Your Mood"),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_selectedMood != null)
              _buildMoodCard(_selectedMood!.name, _selectedMood!.color, icon: _selectedMood!.icon),

            _buildMoodCard(
              "See All",
              primaryPink,
              isAdd: true,
              onTap: _showAllMoodsDialog,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMoodCard(String text, Color bgColor, {bool isAdd = false, IconData? icon, VoidCallback? onTap}) {
    if (isAdd) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: InkWell(
            onTap: onTap ?? () => _showSnackbar('Добавить настроение'),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: primaryPink, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryPink,
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 30),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: darkTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: InkWell(
          onTap: onTap ?? () => _showSnackbar('Выбрано: $text'),
          borderRadius: BorderRadius.circular(18),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: bgColor.withOpacity(0.25),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Center(
                    child: Icon(icon, color: darkTextColor, size: 40),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: darkTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedElegantHeartCard(int cycleDay, double probability) {
    return Center(
      child: AnimatedBuilder(
        animation: _heartScaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _heartScaleAnimation.value,
            child: child,
          );
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 350,
              height: 350,
              child: CustomPaint(
                painter: ElegantHeartPainter(
                  gradient: LinearGradient(
                    colors: [primaryPink.withOpacity(0.95), primaryPink.withOpacity(0.75)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  shadowColor: primaryPink.withOpacity(0.5),
                ),
              ),
            ),
            Positioned(top: 40, left: 30, child: Icon(Icons.favorite, color: primaryPink.withOpacity(0.6), size: 35)),
            Positioned(bottom: 20, right: 30, child: Icon(Icons.favorite, color: primaryPink.withOpacity(0.6), size: 25)),
            Positioned(
              top: 30,
              right: 30,
              child: InkWell(
                onTap: () => _showSnackbar('Редактировать'),
                customBorder: const CircleBorder(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.edit_outlined, color: Colors.white, size: 24),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Period",
                  style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                ),
                Text(
                  "Day $cycleDay",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 60,
                      shadows: [
                        Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 4,
                            color: Colors.black12)
                      ]),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Possible Pregnancy:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  "${probability.toStringAsFixed(1)}%",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ОБНОВЛЕННЫЙ МЕТОД: с именем пользователя на русском
  Widget _buildHeader(BuildContext context, String userName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Добро пожаловать",
              style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Text(
              userName, // ИМЯ ПОЛЬЗОВАТЕЛЯ ИЗ СЕРВИСА
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: darkTextColor,
              ),
            ),
          ],
        ),
        IconButton(
          iconSize: 28,
          onPressed: () => _navigateToNotifications(context),
          icon: CircleAvatar(
            backgroundColor: primaryPink.withOpacity(0.1),
            child: Stack(
              children: [
                Icon(Icons.notifications_none_rounded, color: primaryPink, size: 28),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: primaryPink,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarSection(DateTime focusDate) {
    // Используем _displayDate (6 ноября 2025)
    final DateTime displayDate = _displayDate;

    // Создаем неделю вокруг displayDate
    List<DateTime> weekDays = List.generate(
        7,
            (index) => displayDate.add(Duration(days: index - 3))
    );

    return Column(
      children: [
        // Кнопка для вызова полного календаря (НОВЫЙ ФУНКЦИОНАЛ)
        InkWell(
          onTap: () => _showCycleHistoryCalendar(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today_outlined, color: darkTextColor, size: 16),
                const SizedBox(width: 6),
                // Обновлено на 6 ноября 2025
                Text(
                  DateFormat('d MMMM yyyy', 'ru_RU').format(displayDate),
                  style: TextStyle(color: darkTextColor, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.arrow_drop_down, color: darkTextColor, size: 24),
              ],
            ),
          ),
        ),
        const SizedBox(height: 25),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekDays.map((day) {
            final bool isSelected = isSameDay(day, displayDate);

            // Проверка на день месячных (выделение розовым)
            final bool isCycleDay = _trackedPeriodDays.contains(DateTime(day.year, day.month, day.day));

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: InkWell(
                  onTap: () => _onDaySelected(day),
                  customBorder: const CircleBorder(),
                  child: Container(
                    height: 75,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? primaryPink
                          : (isCycleDay
                          ? primaryPink.withOpacity(0.4)
                          : Colors.white),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isSelected ? 0.2 : 0.05),
                          blurRadius: isSelected ? 8 : 4,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('E', 'ru_RU').format(day).substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            color: isSelected || isCycleDay ? Colors.white : darkTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('d').format(day),
                          style: TextStyle(
                            color: isSelected || isCycleDay ? Colors.white : darkTextColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}