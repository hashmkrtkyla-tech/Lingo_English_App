class LanguageConfig {
  // لغة التعلم ولغة الأم الحاليتان (تُحدَّثان من إعدادات المستخدم)
  static String learningLangCode = 'en';
  static String nativeLangCode = 'ar';

  static String learningLangName = 'English';
  static String nativeLangName = 'العربية';

  // أسماء اللغات الـ15 المدعومة (code -> اسم للعرض)
  static const Map<String, String> supportedLanguages = {
    'ar': 'العربية',
    'en': 'English',
    'fr': 'Français',
    'es': 'Español',
    'de': 'Deutsch',
    'it': 'Italiano',
    'ja': '日本語',
    'ko': '한국어',
    'tr': 'Türkçe',
    'ru': 'Русский',
    'pt': 'Português',
    'zh': '中文',
    'hi': 'हिन्दी',
    'nl': 'Nederlands',
    'sv': 'Svenska',
  };

  // ربط كود اللغة بمحرك النطق (TTS locale)
  static const Map<String, String> ttsLocales = {
    'ar': 'ar-SA',
    'en': 'en-US',
    'fr': 'fr-FR',
    'es': 'es-ES',
    'de': 'de-DE',
    'it': 'it-IT',
    'ja': 'ja-JP',
    'ko': 'ko-KR',
    'tr': 'tr-TR',
    'ru': 'ru-RU',
    'pt': 'pt-PT',
    'zh': 'zh-CN',
    'hi': 'hi-IN',
    'nl': 'nl-NL',
    'sv': 'sv-SE',
  };

  static String localeFor(String langCode) =>
      ttsLocales[langCode] ?? 'en-US';
}
