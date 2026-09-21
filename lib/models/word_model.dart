// نموذج الكلمة الواحدة - هذا هو المصدر الوحيد لتعريف شكل الكلمة في التطبيق
class WordModel {
  final String word;          // الكلمة بلغة التعلم
  final String pronunciation; // النطق الصوتي
  final String meaning;       // المعنى بلغة الواجهة (عربي/إنجليزي حسب المستخدم)
  final String level;         // المستوى: A1, A2, B1, B2, C1, C2 (أو easy/medium/hard لكلمات القاموس)
  final String languageCode;  // رمز اللغة اللي تنتمي لها الكلمة (en, es, fr...)

  // === إضافة جديدة: خريطة كل الترجمات (اختيارية) ===
  // تُستخدم فقط في شاشات القاموس الجديدة للبحث عبر الـ15 لغة
  // لا تؤثر على أي كود قديم يستخدم fromMap / toMap
  final Map<String, String>? translations;
  final String? id;

  const WordModel({
    required this.word,
    required this.pronunciation,
    required this.meaning,
    required this.level,
    required this.languageCode,
    this.translations,
    this.id,
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

  // === factory جديد خاص بملفات القاموس (easy_1.json ... hard_5.json) ===
  // يبني WordModel من صيغة { id, difficulty, translations: {15 لغة} }
  // بناءً على لغة التعلم ولغة الأم الحاليتين
  factory WordModel.fromDictionaryJson(
    Map<String, dynamic> json, {
    required String learningLangCode,
    required String nativeLangCode,
  }) {
    final Map<String, String> allTranslations =
        Map<String, String>.from(json['translations'] as Map);

    return WordModel(
      id: json['id'] as String,
      word: allTranslations[learningLangCode] ?? '',
      meaning: allTranslations[nativeLangCode] ?? '',
      pronunciation: '', // لا يوجد نطق IPA حاليًا في البيانات
      level: json['difficulty'] as String, // easy / medium / hard
      languageCode: learningLangCode,
      translations: allTranslations,
    );
  }
}
