import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/quote.dart';
import '../models/language.dart';
import '../services/favorites_service.dart';
import '../services/share_service.dart';
import '../services/translation_service.dart';
import '../widgets/quote_card.dart';
import '../widgets/language_selector.dart';

/// 즐겨찾기 화면
class FavoritesScreen extends StatefulWidget {
  final Language initialLanguage;

  const FavoritesScreen({
    super.key,
    required this.initialLanguage,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Quote> _favoriteQuotes = [];
  bool _isLoading = true;
  late Language _currentLanguage;

  @override
  void initState() {
    super.initState();
    _currentLanguage = widget.initialLanguage;
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
    // 번역 서비스에 언어 변경 알림
    TranslationService.setLanguage(language.code);
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
          SnackBar(
            content:
                Text(TranslationService.translate('removed_from_favorites')),
            duration: const Duration(seconds: 2),
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
        title: Text(TranslationService.translate('remove_from_favorites')),
        content: Text(TranslationService.translate('remove_from_favorites')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(TranslationService.translate('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(TranslationService.translate('remove_from_favorites')),
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
            SnackBar(
              content:
                  Text(TranslationService.translate('removed_from_favorites')),
              duration: const Duration(seconds: 2),
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
        title: Text(
          TranslationService.translate('favorites'),
          style: const TextStyle(
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
                        TranslationService.translate('no_favorites'),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
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
