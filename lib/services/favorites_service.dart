import 'package:shared_preferences/shared_preferences.dart';
import '../models/quote.dart';

/// 즐겨찾기 기능을 관리하는 서비스 클래스
class FavoritesService {
  static const String _favoritesKey = 'favorite_quotes';

  /// 즐겨찾기된 명언 ID 목록을 가져오는 메서드
  static Future<List<int>> getFavoriteIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? favoriteStrings = prefs.getStringList(_favoritesKey);

      if (favoriteStrings == null) return [];

      return favoriteStrings.map((id) => int.parse(id)).toList();
    } catch (e) {
      print('즐겨찾기 ID 목록 로드 중 오류 발생: $e');
      return [];
    }
  }

  /// 즐겨찾기된 명언들을 가져오는 메서드
  static Future<List<Quote>> getFavoriteQuotes() async {
    try {
      final favoriteIds = await getFavoriteIds();
      if (favoriteIds.isEmpty) return [];

      final List<Quote> favoriteQuotes = [];
      for (final id in favoriteIds) {
        final quote = await QuoteService.getQuoteById(id);
        if (quote != null) {
          favoriteQuotes.add(quote);
        }
      }

      return favoriteQuotes;
    } catch (e) {
      print('즐겨찾기 명언 목록 로드 중 오류 발생: $e');
      return [];
    }
  }

  /// 명언을 즐겨찾기에 추가하는 메서드
  static Future<bool> addToFavorites(Quote quote) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = await getFavoriteIds();

      if (!favoriteIds.contains(quote.id)) {
        favoriteIds.add(quote.id);
        final favoriteStrings = favoriteIds.map((id) => id.toString()).toList();
        return await prefs.setStringList(_favoritesKey, favoriteStrings);
      }

      return true; // 이미 즐겨찾기에 있음
    } catch (e) {
      print('즐겨찾기 추가 중 오류 발생: $e');
      return false;
    }
  }

  /// 명언을 즐겨찾기에서 제거하는 메서드
  static Future<bool> removeFromFavorites(Quote quote) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = await getFavoriteIds();

      favoriteIds.remove(quote.id);
      final favoriteStrings = favoriteIds.map((id) => id.toString()).toList();
      return await prefs.setStringList(_favoritesKey, favoriteStrings);
    } catch (e) {
      print('즐겨찾기 제거 중 오류 발생: $e');
      return false;
    }
  }

  /// 명언이 즐겨찾기에 있는지 확인하는 메서드
  static Future<bool> isFavorite(Quote quote) async {
    try {
      final favoriteIds = await getFavoriteIds();
      return favoriteIds.contains(quote.id);
    } catch (e) {
      print('즐겨찾기 확인 중 오류 발생: $e');
      return false;
    }
  }

  /// 즐겨찾기 토글 메서드
  static Future<bool> toggleFavorite(Quote quote) async {
    try {
      final isCurrentlyFavorite = await isFavorite(quote);

      if (isCurrentlyFavorite) {
        return await removeFromFavorites(quote);
      } else {
        return await addToFavorites(quote);
      }
    } catch (e) {
      print('즐겨찾기 토글 중 오류 발생: $e');
      return false;
    }
  }

  /// 모든 즐겨찾기 제거 메서드
  static Future<bool> clearAllFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_favoritesKey);
    } catch (e) {
      print('모든 즐겨찾기 제거 중 오류 발생: $e');
      return false;
    }
  }
}
