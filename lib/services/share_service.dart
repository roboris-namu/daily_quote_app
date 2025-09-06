import 'package:share_plus/share_plus.dart';
import '../models/quote.dart';
import '../models/language.dart';

/// 공유 기능을 관리하는 서비스 클래스
class ShareService {
  /// 텍스트로 명언을 공유하는 메서드
  static Future<void> shareQuoteAsText(Quote quote, {Language language = Language.english}) {
    final text = quote.getTextForLanguage(language.code);
    final author = quote.author;
    final shareText = '"$text"\n\n- $author';
    
    return Share.share(shareText);
  }

  /// 이미지로 명언을 공유하는 메서드 (텍스트를 이미지로 변환하여 공유)
  static Future<void> shareQuoteAsImage(Quote quote, {Language language = Language.english}) {
    // 실제 구현에서는 명언 텍스트를 이미지로 변환하는 로직이 필요합니다.
    // 현재는 텍스트로 공유하는 것으로 대체합니다.
    return shareQuoteAsText(quote, language: language);
  }

  /// 명언을 다양한 형태로 공유하는 메서드
  static Future<void> shareQuote(Quote quote, {Language language = Language.english}) {
    return shareQuoteAsText(quote, language: language);
  }
}
