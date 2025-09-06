/// 지원되는 언어 열거형
enum Language {
  english('en', 'English', 'EN'),
  korean('ko', '한국어', '한'),
  spanish('es', 'Español', 'ES'),
  portuguese('pt-BR', 'Português', 'PT'),
  hindi('hi', 'हिन्दी', 'हि'),
  indonesian('id', 'Bahasa Indonesia', 'ID'),
  japanese('ja', '日本語', '日');

  const Language(this.code, this.name, this.shortName);

  final String code;
  final String name;
  final String shortName;

  /// 언어 코드로 Language 찾기
  static Language fromCode(String code) {
    return Language.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => Language.english, // 기본값은 영어
    );
  }

  /// Quote 객체에서 해당 언어의 텍스트 가져오기
  String getQuoteText(Map<String, dynamic> quoteData) {
    switch (this) {
      case Language.english:
        return quoteData['english'] as String;
      case Language.korean:
        return quoteData['korean'] as String;
      case Language.spanish:
        return quoteData['spanish'] as String;
      case Language.portuguese:
        return quoteData['portuguese'] as String;
      case Language.hindi:
        return quoteData['hindi'] as String;
      case Language.indonesian:
        return quoteData['indonesian'] as String;
      case Language.japanese:
        return quoteData['japanese'] as String;
    }
  }
}
