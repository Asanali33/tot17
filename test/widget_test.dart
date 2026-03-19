// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:taskflow/main.dart';
import 'package:taskflow/providers/locale_provider.dart';

void main() {
  testWidgets('App loads with provider', (WidgetTester tester) async {
    // Build our app with required providers and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => LocaleProvider())],
        child: const TaskFlowApp(),
      ),
    );

    // Verify that app bar title exists.
    expect(find.text('TaskFlow'), findsOneWidget);

    // Enter text and add a task.
    await tester.enterText(find.byType(TextField).first, 'Test task');
    await tester.tap(find.text('Добавить'));
    await tester.pumpAndSettle();

    // After selecting category and adding, task should appear.
    expect(find.text('Test task'), findsOneWidget);
  });
}
