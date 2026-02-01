import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:womens_health/app.dart'; // Здесь лежит MyApp

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Строим наше приложение и запускаем кадр
    await tester.pumpWidget(const WomensHealthApp()); // <--- заменили WomensHealthApp на MyApp

    // Проверяем, что счетчик начинается с 0
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Нажимаем на кнопку "+" и перерисовываем экран
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Проверяем, что значение увеличилось
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
