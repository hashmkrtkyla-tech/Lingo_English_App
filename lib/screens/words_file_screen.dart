import 'package:flutter/material.dart';
import '../models/word_model.dart';
import '../services/dictionary_service.dart';
import '../services/tts_service.dart';
import '../utils/app_colors.dart';
import '../utils/language_config.dart';

class WordsFileScreen extends StatefulWidget {
  final String fileName;   // مثال: "easy_1"
  final String levelTitle; // مثال: "المستوى 1"

  const WordsFileScreen({
    super.key,
    required this.fileName,
    required this.levelTitle,
  });

  @override
  State<WordsFileScreen> createState() => _WordsFileScreenState();
}

class _WordsFileScreenState extends State<WordsFileScreen> {
  late Future<List<WordModel>> _wordsFuture;
  final TtsService _tts = TtsService();

  @override
  void initState() {
    super.initState();
    _wordsFuture = DictionaryService().loadFile(widget.fileName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        foregroundColor: AppColors.white,
        title: Text(widget.levelTitle),
        centerTitle: true,
      ),
      body: FutureBuilder<List<WordModel>>(
        future: _wordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          }
          final words = snapshot.data ?? [];
          if (words.isEmpty) {
            return const Center(child: Text('لا توجد كلمات في هذا الملف'));
          }

          return Column(
            children: [
              _buildHeaderRow(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    return _buildWordRow(words[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeaderRow() {
    final learningName =
        LanguageConfig.supportedLanguages[LanguageConfig.learningLangCode] ??
            LanguageConfig.learningLangCode;
    final nativeName =
        LanguageConfig.supportedLanguages[LanguageConfig.nativeLangCode] ??
            LanguageConfig.nativeLangCode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              learningName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.navy,
              ),
            ),
          ),
          const Icon(Icons.swap_horiz, color: AppColors.navy),
          Expanded(
            child: Text(
              nativeName,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.navy,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordRow(WordModel word) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _WordCard(
              text: word.word,
              backgroundColor: AppColors.babyBlue,
              onSpeak: () =>
                  _tts.speak(word.word, LanguageConfig.learningLangCode),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _WordCard(
              text: word.meaning,
              backgroundColor: AppColors.sage,
              onSpeak: () =>
                  _tts.speak(word.meaning, LanguageConfig.nativeLangCode),
            ),
          ),
        ],
      ),
    );
  }
}

class _WordCard extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final VoidCallback onSpeak;

  const _WordCard({
    required this.text,
    required this.backgroundColor,
    required this.onSpeak,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.navy,
              ),
            ),
          ),
          InkWell(
            onTap: onSpeak,
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.volume_up, size: 20, color: AppColors.navy),
            ),
          ),
        ],
      ),
    );
  }
}
