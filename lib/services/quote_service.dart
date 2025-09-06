import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/quote.dart';

/// 명언 데이터를 관리하는 서비스 클래스
class QuoteService {
  static const String _quotesAssetPath = 'assets/quotes.json';
  static List<Quote>? _quotes;

  /// 명언 데이터를 로드하는 메서드
  static Future<List<Quote>> loadQuotes() async {
    if (_quotes != null) return _quotes!;

    try {
      // assets/quotes.json 파일을 읽어옴
      final String jsonString = await rootBundle.loadString(_quotesAssetPath);
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // JSON 데이터를 Quote 객체 리스트로 변환
      final List<dynamic> quotesJson = jsonData['quotes'] as List<dynamic>;
      _quotes = quotesJson.map((json) => Quote.fromJson(json)).toList();

      return _quotes!;
    } catch (e) {
      debugPrint('명언 데이터 로드 중 오류 발생: $e');
      return [];
    }
  }

  /// 오늘의 명언을 가져오는 메서드 (날짜 기반 인덱스)
  static Future<Quote?> getTodaysQuote() async {
    final quotes = await loadQuotes();
    if (quotes.isEmpty) return null;

    // 현재 날짜를 기준으로 인덱스 계산
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final index = dayOfYear % quotes.length;

    return quotes[index];
  }

  /// 특정 날짜의 명언을 가져오는 메서드
  static Future<Quote?> getQuoteForDate(DateTime date) async {
    final quotes = await loadQuotes();
    if (quotes.isEmpty) return null;

    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    final index = dayOfYear % quotes.length;

    return quotes[index];
  }

  /// 모든 명언을 가져오는 메서드
  static Future<List<Quote>> getAllQuotes() async {
    return await loadQuotes();
  }

  /// ID로 명언을 찾는 메서드
  static Future<Quote?> getQuoteById(int id) async {
    final quotes = await loadQuotes();
    try {
      return quotes.firstWhere((quote) => quote.id == id);
    } catch (e) {
      return null;
    }
  }
}
