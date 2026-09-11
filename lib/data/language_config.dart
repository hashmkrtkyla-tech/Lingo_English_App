class LanguageOption {
  final String code;       // رمز اللغة: en, es, fr...
  final String name;       // الاسم بالعربي: "الإنجليزية"
  final String flagEmoji;  // 🇬🇧 🇪🇸 🇫🇷
  final bool isAvailable;  // هل المحتوى جاهز فعليًا لهذه اللغة؟

  const LanguageOption({
    required this.code,
    required this.name,
    required this.flagEmoji,
    this.isAvailable = false,
  });
}

// القائمة الكاملة - فعّل isAvailable:true فقط للغات التي جهزت محتواها
const List<LanguageOption> availableLanguages = [
  LanguageOption(code: 'en', name: 'الإنجليزية', flagEmoji: '🇬🇧', isAvailable: true),
  LanguageOption(code: 'es', name: 'الإسبانية', flagEmoji: '🇪🇸', isAvailable: true),
  LanguageOption(code: 'fr', name: 'الفرنسية', flagEmoji: '🇫🇷', isAvailable: true),
  LanguageOption(code: 'de', name: 'الألمانية', flagEmoji: '🇩🇪', isAvailable: true),
  LanguageOption(code: 'it', name: 'الإيطالية', flagEmoji: '🇮🇹', isAvailable: true),
  LanguageOption(code: 'ja', name: 'اليابانية', flagEmoji: '🇯🇵', isAvailable: true),
  LanguageOption(code: 'ko', name: 'الكورية', flagEmoji: '🇰🇷', isAvailable: true),
  LanguageOption(code: 'tr', name: 'التركية', flagEmoji: '🇹🇷', isAvailable: true),
  LanguageOption(code: 'ru', name: 'الروسية', flagEmoji: '🇷🇺', isAvailable: true),
  LanguageOption(code: 'pt', name: 'البرتغالية', flagEmoji: '🇵🇹', isAvailable: true),
  LanguageOption(code: 'zh', name: 'الصينية', flagEmoji: '🇨🇳'), // مقفولة حاليًا لحد ما تجهز محتواها
];

// حفظ اللغة المختارة حاليًا (بسيط الآن، سنطوره لاحقًا بالتخزين الدائم)
class AppState {
  static String currentLanguageCode = 'en';

  static LanguageOption get currentLanguage =>
      availableLanguages.firstWhere((l) => l.code == currentLanguageCode);
}
