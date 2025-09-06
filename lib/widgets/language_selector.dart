import 'package:flutter/material.dart';

/// 언어 선택 위젯
class LanguageSelector extends StatelessWidget {
  final bool isKorean;
  final VoidCallback onLanguageChanged;

  const LanguageSelector({
    super.key,
    required this.isKorean,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          isKorean ? '한' : 'EN',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      onPressed: onLanguageChanged,
      tooltip: isKorean ? 'Switch to English' : '한국어로 전환',
    );
  }
}
