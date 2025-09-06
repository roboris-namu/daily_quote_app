import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../models/language.dart';

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
                // 즐겨찾기 버튼
                _buildActionButton(
                  icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                  label: isFavorite ? '즐겨찾기 해제' : '즐겨찾기',
                  color: isFavorite ? Colors.red : Colors.grey[600]!,
                  onPressed: onFavoriteToggle,
                ),

                // 공유 버튼
                _buildActionButton(
                  icon: Icons.share,
                  label: '공유',
                  color: Colors.deepPurple,
                  onPressed: onShare,
                ),
              ],
            ),
          ],
        ),
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
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
