/// يمثل جملة تدريب واحدة (من ملفات easy/medium/hard_sentences.json)
class PracticeSentence {
  final String id;
  final String difficulty; // easy | medium | hard
  final String pairKey; // مثال: he_she, is_are, do_does...
  final String correctOption; // "a" أو "b"
  final Map<String, String> sentences; // كود اللغة -> النص الكامل

  PracticeSentence({
    required this.id,
    required this.difficulty,
    required this.pairKey,
    required this.correctOption,
    required this.sentences,
  });

  factory PracticeSentence.fromJson(Map<String, dynamic> json) {
    return PracticeSentence(
      id: json['id'] as String,
      difficulty: json['difficulty'] as String,
      pairKey: json['pairKey'] as String,
      correctOption: json['correctOption'] as String,
      sentences: Map<String, String>.from(json['sentences'] as Map),
    );
  }

  /// النص الكامل بلغة معينة (لغة التعلم أو اللغة الأم)
  String textIn(String langCode) => sentences[langCode] ?? '';
}

/// جدول الأزواج المشترك (practice_pairs.json)
/// البنية: { "he_she": { "en": {"a": "He", "b": "She"}, "ar": {...}, ... }, ... }
class WordPairsTable {
  final Map<String, Map<String, Map<String, String>>> pairs;

  WordPairsTable(this.pairs);

  factory WordPairsTable.fromJson(Map<String, dynamic> json) {
    final result = <String, Map<String, Map<String, String>>>{};
    json.forEach((pairKey, langsMap) {
      final langs = <String, Map<String, String>>{};
      (langsMap as Map<String, dynamic>).forEach((lang, options) {
        langs[lang] = Map<String, String>.from(options as Map);
      });
      result[pairKey] = langs;
    });
    return WordPairsTable(result);
  }

  /// يعيد {"a": "...", "b": "..."} بلغة ونوع زوج معينين
  Map<String, String>? optionsFor(String pairKey, String langCode) {
    return pairs[pairKey]?[langCode];
  }
}

/// نتيجة تجهيز جملة الاستماع: النص بعد إخفاء الكلمة + الخيارين
class BlankExercise {
  final String textWithBlank;
  final String correctWord;
  final String distractorWord;
  final String translation;

  BlankExercise({
    required this.textWithBlank,
    required this.correctWord,
    required this.distractorWord,
    required this.translation,
  });
}
