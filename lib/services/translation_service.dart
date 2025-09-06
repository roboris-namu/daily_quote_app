import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class TranslationService {
  static final Map<String, Map<String, String>> _translations = {};
  static String _currentLanguage = 'en';

  // 현재 언어 설정
  static void setLanguage(String languageCode) {
    _currentLanguage = languageCode;
  }

  // 현재 언어 가져오기
  static String get currentLanguage => _currentLanguage;

  // 번역 파일 로드
  static Future<void> loadTranslations() async {
    final languages = ['en', 'ko', 'es', 'pt', 'hi', 'id', 'ja', 'zh'];
    
    for (String lang in languages) {
      try {
        final String jsonString = await rootBundle.loadString('assets/translations/$lang.json');
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        _translations[lang] = jsonMap.map((key, value) => MapEntry(key, value.toString()));
      } catch (e) {
        debugPrint('Error loading translation for $lang: $e');
        // 영어를 기본값으로 사용
        if (lang != 'en') {
          _translations[lang] = _translations['en'] ?? {};
        }
      }
    }
  }

  // 번역 텍스트 가져오기
  static String translate(String key) {
    final translation = _translations[_currentLanguage]?[key];
    if (translation != null) {
      return translation;
    }
    
    // 현재 언어에 번역이 없으면 영어로 폴백
    final englishTranslation = _translations['en']?[key];
    if (englishTranslation != null) {
      return englishTranslation;
    }
    
    // 영어에도 없으면 키 자체를 반환
    return key;
  }

  // 모든 지원 언어 목록 가져오기
  static List<String> get supportedLanguages => ['en', 'ko', 'es', 'pt', 'hi', 'id', 'ja', 'zh'];

  // 언어 이름 가져오기
  static String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en': return 'English';
      case 'ko': return '한국어';
      case 'es': return 'Español';
      case 'pt': return 'Português';
      case 'hi': return 'हिन्दी';
      case 'id': return 'Bahasa Indonesia';
      case 'ja': return '日本語';
      case 'zh': return '中文';
      default: return 'English';
    }
  }

  // 언어 단축 이름 가져오기
  static String getLanguageShortName(String languageCode) {
    switch (languageCode) {
      case 'en': return 'EN';
      case 'ko': return '한';
      case 'es': return 'ES';
      case 'pt': return 'PT';
      case 'hi': return 'हि';
      case 'id': return 'ID';
      case 'ja': return '日';
      case 'zh': return '中';
      default: return 'EN';
    }
  }
}
