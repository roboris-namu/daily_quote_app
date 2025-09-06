/// 명언 데이터 모델 클래스
class Quote {
  final int id;
  final String english;
  final String korean;
  final String chinese;
  final String spanish;
  final String portuguese;
  final String hindi;
  final String indonesian;
  final String japanese;
  final String author;

  const Quote({
    required this.id,
    required this.english,
    required this.korean,
    required this.chinese,
    required this.spanish,
    required this.portuguese,
    required this.hindi,
    required this.indonesian,
    required this.japanese,
    required this.author,
  });

  /// JSON에서 Quote 객체로 변환
  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'] as int,
      english: json['english'] as String,
      korean: json['korean'] as String,
      chinese: json['chinese'] as String,
      spanish: json['spanish'] as String,
      portuguese: json['portuguese'] as String,
      hindi: json['hindi'] as String,
      indonesian: json['indonesian'] as String,
      japanese: json['japanese'] as String,
      author: json['author'] as String,
    );
  }

  /// Quote 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'english': english,
      'korean': korean,
      'chinese': chinese,
      'spanish': spanish,
      'portuguese': portuguese,
      'hindi': hindi,
      'indonesian': indonesian,
      'japanese': japanese,
      'author': author,
    };
  }

  @override
  String toString() {
    return 'Quote(id: $id, english: $english, korean: $korean, chinese: $chinese, spanish: $spanish, portuguese: $portuguese, hindi: $hindi, indonesian: $indonesian, japanese: $japanese, author: $author)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Quote && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  /// 특정 언어의 명언 텍스트를 가져오는 메서드
  String getTextForLanguage(String languageCode) {
    switch (languageCode) {
      case 'en':
        return english;
      case 'ko':
        return korean;
      case 'zh':
        return chinese;
      case 'es':
        return spanish;
      case 'pt-BR':
        return portuguese;
      case 'hi':
        return hindi;
      case 'id':
        return indonesian;
      case 'ja':
        return japanese;
      default:
        return english; // 기본값은 영어
    }
  }
}
