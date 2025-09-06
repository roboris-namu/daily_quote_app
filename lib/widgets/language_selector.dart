import 'package:flutter/material.dart';
import '../models/language.dart';

/// 언어 선택 위젯
class LanguageSelector extends StatelessWidget {
  final Language currentLanguage;
  final Function(Language) onLanguageChanged;

  const LanguageSelector({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Language>(
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          currentLanguage.shortName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      onSelected: onLanguageChanged,
      itemBuilder: (BuildContext context) => Language.values.map((Language language) {
        return PopupMenuItem<Language>(
          value: language,
          child: Row(
            children: [
              Text(
                language.shortName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Text(language.name),
            ],
          ),
        );
      }).toList(),
    );
  }
}
