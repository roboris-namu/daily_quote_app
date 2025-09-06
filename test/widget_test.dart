// This is a basic Flutter widget test for Daily Quotes app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:daily_quote_app/main.dart';

void main() {
  testWidgets('Daily Quotes app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DailyQuotesApp());

    // Verify that the app loads without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
    
    // Wait for the app to load completely
    await tester.pumpAndSettle();
    
    // Verify that the app title is displayed
    expect(find.text('Daily Quotes'), findsOneWidget);
  });
}
