/// 명언 데이터 모델 클래스
class Quote {
  final int id;
  final String english;
  final String korean;
  final String author;

  const Quote({
    required this.id,
    required this.english,
    required this.korean,
    required this.author,
  });

  /// JSON에서 Quote 객체로 변환
  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'] as int,
      english: json['english'] as String,
      korean: json['korean'] as String,
      author: json['author'] as String,
    );
  }

  /// Quote 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'english': english,
      'korean': korean,
      'author': author,
    };
  }

  @override
  String toString() {
    return 'Quote(id: $id, english: $english, korean: $korean, author: $author)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Quote && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
