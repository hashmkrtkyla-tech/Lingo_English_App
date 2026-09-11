// نموذج الكلمة الواحدة - هذا هو المصدر الوحيد لتعريف شكل الكلمة في التطبيق
class WordModel {
  final String word;          // الكلمة بلغة التعلم
  final String pronunciation; // النطق الصوتي
  final String meaning;       // المعنى بلغة الواجهة (عربي/إنجليزي حسب المستخدم)
  final String level;         // المستوى: A1, A2, B1, B2, C1, C2
  final String languageCode;  // رمز اللغة اللي تنتمي لها الكلمة (en, es, fr...)

  const WordModel({
    required this.word,
    required this.pronunciation,
    required this.meaning,
    required this.level,
    required this.languageCode,
  });

  // تحويل من/إلى Map - مفيد لاحقًا عند التخزين في قاعدة بيانات (Firebase) أو محليًا
  factory WordModel.fromMap(Map<String, dynamic> map) {
    return WordModel(
      word: map['word'] ?? '',
      pronunciation: map['pronunciation'] ?? '',
      meaning: map['meaning'] ?? '',
      level: map['level'] ?? 'A1',
      languageCode: map['languageCode'] ?? 'en',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'pronunciation': pronunciation,
      'meaning': meaning,
      'level': level,
      'languageCode': languageCode,
    };
  }
}
