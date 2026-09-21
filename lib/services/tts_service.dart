import 'package:flutter_tts/flutter_tts.dart';
import '../utils/language_config.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _tts = FlutterTts();

  Future<void> speak(String text, String langCode) async {
    if (text.isEmpty) return;
    await _tts.setLanguage(LanguageConfig.localeFor(langCode));
    await _tts.setSpeechRate(0.45);
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> stop() async => _tts.stop();
}
