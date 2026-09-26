import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/practice_sentence.dart';

enum ExerciseType { listening, speaking, reorder, grammar }

class PracticeService {
  static final PracticeService instance = PracticeService._internal();
  PracticeService._internal();

  final Map<String, List<PracticeSentence>> _sentencesByDifficulty = {};
  WordPairsTable? _pairsTable;
  bool _loaded = false;

  static const _assetPaths = {
    'easy': 'assets/practice/sentences/easy_sentences.json',
    'medium': 'assets/practice/sentences/medium_sentences.json',
    'hard': 'assets/practice/sentences/hard_sentences.json',
  };
  static const _pairsAssetPath = 'assets/practice/sentences/practice_pairs.json';

  /// يُستدعى مرة واحدة عند دخول صفحة التدريبات لأول مرة
  Future<void> loadAll() async {
    if (_loaded) return;
    for (final entry in _assetPaths.entries) {
      final raw = await rootBundle.loadString(entry.value);
      final List<dynamic> list = json.decode(raw) as List<dynamic>;
      _sentencesByDifficulty[entry.key] =
          list.map((e) => PracticeSentence.fromJson(e as Map<String, dynamic>)).toList();
    }
    final rawPairs = await rootBundle.loadString(_pairsAssetPath);
    _pairsTable = WordPairsTable.fromJson(json.decode(rawPairs) as Map<String, dynamic>);
    _loaded = true;
  }

  /// يقسّم جمل مستوى معين إلى ٣٠ درساً، كل درس ٥ جمل
  List<List<PracticeSentence>> lessonsFor(String difficulty) {
    final all = _sentencesByDifficulty[difficulty] ?? [];
    const perLesson = 5;
    final lessons = <List<PracticeSentence>>[];
    for (var i = 0; i < all.length; i += perLesson) {
      final end = (i + perLesson < all.length) ? i + perLesson : all.length;
      lessons.add(all.sublist(i, end));
    }
    return lessons; // متوقع أن يكون طولها 30 إذا كانت البيانات 150 جملة
  }

  /// يبني تمرين الاستماع/القراءة: يخفي الكلمة الصحيحة من الجملة ويجهز الخيارين
  BlankExercise buildBlankExercise({
    required PracticeSentence sentence,
    required String learningLang,
    required String nativeLang,
  }) {
    final options = _pairsTable?.optionsFor(sentence.pairKey, learningLang);
    final text = sentence.textIn(learningLang);
    final translation = sentence.textIn(nativeLang);

    if (options == null) {
      return BlankExercise(
        textWithBlank: text,
        correctWord: '',
        distractorWord: '',
        translation: translation,
      );
    }

    final correctWord = options[sentence.correctOption] ?? '';
    final otherKey = sentence.correctOption == 'a' ? 'b' : 'a';
    final distractorWord = options[otherKey] ?? '';

    final regex = RegExp(
      r'\b' + RegExp.escape(correctWord) + r'\b',
      caseSensitive: false,
    );
    final textWithBlank = correctWord.isEmpty
        ? text
        : text.replaceFirst(regex, '_____');

    return BlankExercise(
      textWithBlank: textWithBlank,
      correctWord: correctWord,
      distractorWord: distractorWord,
      translation: translation,
    );
  }

  /// لتمرين ترتيب الجمل: يقسّم الجملة إلى كلمات مبعثرة
  List<String> wordsForReorder(PracticeSentence sentence, String learningLang) {
    final text = sentence.textIn(learningLang).replaceAll('.', '').trim();
    final words = text.split(' ')..shuffle();
    return words;
  }

  List<String> correctOrder(PracticeSentence sentence, String learningLang) {
    final text = sentence.textIn(learningLang).replaceAll('.', '').trim();
    return text.split(' ');
  }
}
