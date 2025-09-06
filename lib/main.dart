import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

/// Daily Quotes 앱의 메인 진입점
void main() {
  runApp(const DailyQuotesApp());
}

/// Daily Quotes 앱의 루트 위젯
class DailyQuotesApp extends StatelessWidget {
  const DailyQuotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Quotes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'NotoSans',
      ),
      home: const HomeScreen(),
    );
  }
}
