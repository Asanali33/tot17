// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:taskflow/main.dart';

void main() {
  testWidgets('App launches and shows main screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TaskFlowApp());

    // Verify that the main screen is displayed (check for bottom navigation bar items)
    expect(find.text('Задачи'), findsOneWidget);
    expect(find.text('Статистика'), findsOneWidget);
    expect(find.text('Настройки'), findsOneWidget);
  });
}
