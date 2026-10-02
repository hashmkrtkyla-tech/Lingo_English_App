import 'package:flutter_tts/flutter_tts.dart';

/// نطق نصوص الدورة (يستخدم حزمة flutter_tts الموجودة عندك أصلاً)
class CourseTts {
  static final FlutterTts _tts = FlutterTts();

  static const Map<String, String> _loc = {
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
    'pt': 'pt-BR',
    'zh': 'zh-CN',
    'hi': 'hi-IN',
    'nl': 'nl-NL',
    'sv': 'sv-SE',
  };

  static String locale(String lang) => _loc[lang] ?? 'en-US';

  /// صيغة التعرف على الكلام: en_US
  static String sttLocale(String lang) => locale(lang).replaceAll('-', '_');

  static Future<void> speak(String text, String lang, {bool slow = false}) async {
    if (text.trim().isEmpty) return;
    try {
      await _tts.stop();
      await _tts.setLanguage(locale(lang));
      await _tts.setSpeechRate(slow ? 0.25 : 0.45);
      await _tts.speak(text);
    } catch (_) {}
  }
}
