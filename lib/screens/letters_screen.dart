import 'package:flutter/material.dart';
import '../models/alphabet_model.dart';
import '../services/alphabet_service.dart';
import '../services/tts_service.dart';
import '../utils/app_colors.dart';
import '../utils/language_config.dart';

class LettersScreen extends StatefulWidget {
  const LettersScreen({super.key});

  @override
  State<LettersScreen> createState() => _LettersScreenState();
}

class _LettersScreenState extends State<LettersScreen> {
  late Future<List<AlphabetLetter>> _lettersFuture;
  final TtsService _tts = TtsService();

  @override
  void initState() {
    super.initState();
    _lettersFuture =
        AlphabetService().loadAlphabet(LanguageConfig.learningLangCode);
  }

  @override
  Widget build(BuildContext context) {
    final learningName =
        LanguageConfig.supportedLanguages[LanguageConfig.learningLangCode] ??
            LanguageConfig.learningLangCode;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        foregroundColor: AppColors.white,
        title: Text('الحروف الأبجدية · $learningName'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<AlphabetLetter>>(
        future: _lettersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'لا تتوفر حروف بعد للغة "$learningName".\n'
                  'الملف المطلوب: assets/data/alphabets/'
                  '${LanguageConfig.learningLangCode}.json',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.navy),
                ),
              ),
            );
          }

          final letters = snapshot.data ?? [];
          if (letters.isEmpty) {
            return const Center(child: Text('لا توجد حروف لهذه اللغة'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: letters.length,
            itemBuilder: (context, index) {
              final item = letters[index];
              return _LetterTile(
                letter: item.letter,
                name: item.name,
                onTap: () => _tts.speak(
                  item.letter,
                  LanguageConfig.learningLangCode,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _LetterTile extends StatelessWidget {
  final String letter;
  final String name;
  final VoidCallback onTap;

  const _LetterTile({
    required this.letter,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lilac.withOpacity(0.25),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.lilac, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              letter,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: const TextStyle(fontSize: 11, color: AppColors.navy),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
