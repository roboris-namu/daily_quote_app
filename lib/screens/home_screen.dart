import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/quote.dart';
import '../models/language.dart';
import '../services/quote_service.dart';
import '../services/favorites_service.dart';
import '../services/share_service.dart';
import '../services/translation_service.dart';
import '../widgets/quote_card.dart';
import '../widgets/language_selector.dart';
import 'favorites_screen.dart';

/// 메인 홈 화면
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Quote? _todaysQuote;
  bool _isLoading = true;
  Language _currentLanguage = Language.english; // 기본 언어는 영어
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadTodaysQuote();
  }

  /// 오늘의 명언을 로드하는 메서드
  Future<void> _loadTodaysQuote() async {
    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint('명언 로드 시작...');
      final quote = await QuoteService.getTodaysQuote();
      debugPrint('명언 로드 완료: ${quote?.id}');

      if (quote != null) {
        setState(() {
          _todaysQuote = quote;
          _isLoading = false;
        });

        // 즐겨찾기 상태 확인
        _checkFavoriteStatus();
      } else {
        debugPrint('명언이 null입니다.');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('명언 로드 중 오류 발생: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// 즐겨찾기 상태를 확인하는 메서드
  Future<void> _checkFavoriteStatus() async {
    if (_todaysQuote != null) {
      final isFavorite = await FavoritesService.isFavorite(_todaysQuote!);
      setState(() {
        _isFavorite = isFavorite;
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

  /// 즐겨찾기를 토글하는 메서드
  Future<void> _toggleFavorite() async {
    if (_todaysQuote != null) {
      final success = await FavoritesService.toggleFavorite(_todaysQuote!);
      if (success) {
        setState(() {
          _isFavorite = !_isFavorite;
        });

        // 햅틱 피드백
        HapticFeedback.lightImpact();

        // 스낵바 표시
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _isFavorite
                    ? TranslationService.translate('added_to_favorites')
                    : TranslationService.translate('removed_from_favorites'),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  /// 명언을 공유하는 메서드
  Future<void> _shareQuote() async {
    if (_todaysQuote != null) {
      await ShareService.shareQuote(_todaysQuote!, language: _currentLanguage);
    }
  }

  /// 즐겨찾기 화면으로 이동하는 메서드
  void _navigateToFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FavoritesScreen(initialLanguage: _currentLanguage),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          TranslationService.translate('app_title'),
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
          // 즐겨찾기 화면으로 이동하는 버튼
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: _navigateToFavorites,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
              ),
            )
          : _todaysQuote == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        TranslationService.translate('quote_of_the_day'),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadTodaysQuote,
                        child: Text(TranslationService.translate('refresh')),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadTodaysQuote,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // 오늘의 명언 카드
                        QuoteCard(
                          quote: _todaysQuote!,
                          currentLanguage: _currentLanguage,
                          isFavorite: _isFavorite,
                          onFavoriteToggle: _toggleFavorite,
                          onShare: _shareQuote,
                        ),
                        const SizedBox(height: 24),
                        // 새로고침 버튼
                        ElevatedButton.icon(
                          onPressed: _loadTodaysQuote,
                          icon: const Icon(Icons.refresh),
                          label: Text(TranslationService.translate('refresh')),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
