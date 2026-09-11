import 'package:flutter/material.dart';
import '../data/language_config.dart';
import '../widgets/language_card_widget.dart';
import '../main.dart';

class LanguageSelectScreen extends StatelessWidget {
  const LanguageSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'ماذا تريد أن تتعلم؟',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.1,
        ),
        itemCount: availableLanguages.length,
        itemBuilder: (context, index) {
          final lang = availableLanguages[index];
          return LanguageCardWidget(
            language: lang,
            onTap: () {
              if (!lang.isAvailable) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('هذه اللغة قريبًا! 🚀')),
                );
                return;
              }
              AppState.currentLanguageCode = lang.code;
              Navigator.pushReplacement(
                context,
                
MaterialPageRoute(builder: (_) => const MainNavigation()),
