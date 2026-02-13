import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:womens_health/screens/dummy_screen.dart';
import 'package:womens_health/screens/profile/help_screen.dart';
import 'package:womens_health/widgets/custom_button.dart';

void main() {
  testWidgets('CustomButton отображает текст и вызывает onPressed', (
    WidgetTester tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: 'Сохранить',
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Сохранить'), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('DummyScreen показывает заголовок и текст заглушки', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DummyScreen(
          title: 'Тестовый экран',
          bgColor: Colors.white,
        ),
      ),
    );

    expect(find.text('Тестовый экран'), findsOneWidget);
    expect(find.textContaining('Это заглушка для экрана'), findsOneWidget);
  });

  testWidgets('HelpScreen раскрывает FAQ и показывает Snackbar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HelpScreen()));

    final faqQuestion = find.text('Как правильно начать цикл?');
    expect(faqQuestion, findsOneWidget);

    await tester.tap(faqQuestion);
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Цикл начинается с первого дня менструации'),
      findsOneWidget,
    );

    await tester.tap(find.text('Написать на Email'));
    await tester.pump();

    expect(find.text('Открытие почтового клиента...'), findsOneWidget);
  });
}
