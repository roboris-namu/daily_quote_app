import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/quote.dart';
import '../models/language.dart';
import '../services/favorites_service.dart';
import '../services/share_service.dart';
import '../widgets/quote_card.dart';
import '../widgets/language_selector.dart';

/// 즐겨찾기 화면
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Quote> _favoriteQuotes = [];
  bool _isLoading = true;
  Language _currentLanguage = Language.english; // 기본 언어는 영어

  @override
  void initState() {
    super.initState();
    _loadFavoriteQuotes();
  }

  /// 즐겨찾기된 명언들을 로드하는 메서드
  Future<void> _loadFavoriteQuotes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final quotes = await FavoritesService.getFavoriteQuotes();
      setState(() {
        _favoriteQuotes = quotes;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('즐겨찾기 명언 로드 중 오류 발생: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// 언어를 변경하는 메서드
  void _changeLanguage(Language language) {
    setState(() {
      _currentLanguage = language;
    });
  }

  /// 즐겨찾기에서 명언을 제거하는 메서드
  Future<void> _removeFromFavorites(Quote quote) async {
    final success = await FavoritesService.removeFromFavorites(quote);
    if (success) {
      setState(() {
        _favoriteQuotes.remove(quote);
      });

      // 햅틱 피드백
      HapticFeedback.lightImpact();

      // 스낵바 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('즐겨찾기에서 제거되었습니다'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  /// 명언을 공유하는 메서드
  Future<void> _shareQuote(Quote quote) async {
    await ShareService.shareQuote(quote, language: _currentLanguage);
  }

  /// 모든 즐겨찾기를 제거하는 메서드
  Future<void> _clearAllFavorites() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('모든 즐겨찾기 제거'),
        content: const Text('모든 즐겨찾기를 제거하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('제거'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await FavoritesService.clearAllFavorites();
      if (success) {
        setState(() {
          _favoriteQuotes.clear();
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('모든 즐겨찾기가 제거되었습니다'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          '즐겨찾기',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          // 언어 변경 버튼
          LanguageSelector(
            currentLanguage: _currentLanguage,
            onLanguageChanged: _changeLanguage,
          ),
          // 모든 즐겨찾기 제거 버튼
          if (_favoriteQuotes.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all, color: Colors.white),
              onPressed: _clearAllFavorites,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
              ),
            )
          : _favoriteQuotes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '즐겨찾기된 명언이 없습니다',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '하트 버튼을 눌러 명언을 즐겨찾기에 추가해보세요',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadFavoriteQuotes,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _favoriteQuotes.length,
                    itemBuilder: (context, index) {
                      final quote = _favoriteQuotes[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: QuoteCard(
                          quote: quote,
                          currentLanguage: _currentLanguage,
                          isFavorite: true,
                          onFavoriteToggle: () => _removeFromFavorites(quote),
                          onShare: () => _shareQuote(quote),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
