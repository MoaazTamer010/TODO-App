// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Todo app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app starts with the correct title and input field.
    expect(find.text('My Tasks'), findsOneWidget);
    expect(find.text('What needs to be done?'), findsOneWidget);

    // Enter a new task.
    await tester.enterText(
      find.byType(TextField),
      'New Task Test',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    // Verify the task was added to the list.
    expect(find.text('New Task Test'), findsOneWidget);
  });
}