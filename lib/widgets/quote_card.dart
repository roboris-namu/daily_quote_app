import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../models/language.dart';
import '../services/translation_service.dart';

/// 명언을 표시하는 카드 위젯
class QuoteCard extends StatelessWidget {
  final Quote quote;
  final Language currentLanguage;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onShare;

  const QuoteCard({
    super.key,
    required this.quote,
    required this.currentLanguage,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.deepPurple.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade50,
              Colors.deepPurple.shade100,
            ],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 명언 텍스트
            Text(
              quote.getTextForLanguage(currentLanguage.code),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
              maxLines: 10, // 최대 10줄까지 표시
              overflow: TextOverflow.ellipsis, // 넘치는 텍스트는 ...으로 표시
            ),
            const SizedBox(height: 20),

            // 구분선
            Container(
              height: 1,
              color: Colors.deepPurple.withOpacity(0.3),
            ),
            const SizedBox(height: 16),

            // 작가명
            Text(
              '- ${quote.author}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.deepPurple.shade700,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 20),

            // 액션 버튼들
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 즐겨찾기 버튼 (아이콘만)
                _buildIconOnlyButton(
                  icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey[600]!,
                  onPressed: onFavoriteToggle,
                ),

                const SizedBox(width: 16),

                // 공유 버튼 (아이콘 + 텍스트)
                Flexible(
                  child: _buildActionButton(
                    icon: Icons.share,
                    label: TranslationService.translate('share'),
                    color: Colors.deepPurple,
                    onPressed: onShare,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 아이콘만 있는 버튼을 생성하는 메서드
  Widget _buildIconOnlyButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }

  /// 액션 버튼을 생성하는 메서드
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
