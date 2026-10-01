import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../main.dart';
import '../utils/practice_colors.dart';
import '../models/practice_sentence.dart';
import 'lesson_complete_screen.dart';

class SpeakingExerciseScreen extends StatefulWidget {
  final int lessonNumber;
  final List<PracticeSentence> sentences;

  const SpeakingExerciseScreen({
    super.key,
    required this.lessonNumber,
    required this.sentences,
  });

  @override
  State<SpeakingExerciseScreen> createState() => _SpeakingExerciseScreenState();
}

class _SpeakingExerciseScreenState extends State<SpeakingExerciseScreen> {
  final String learningLang = AppState.currentLanguageCode;
  final String nativeLang = 'ar';

  final FlutterTts _tts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _speechReady = false;

  int _index = 0;
  int _correctCount = 0;
  bool _isRecording = false;
  double? _accuracy; // 0..1
  String _recognizedText = '';

  PracticeSentence get _sentence => widget.sentences[_index];

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    final available = await _speech.initialize(
      onError: (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تعذّر تشغيل التعرف على الصوت: ${error.errorMsg}')),
          );
        }
      },
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (mounted && _isRecording) {
            setState(() => _isRecording = false);
          }
        }
      },
    );
    if (mounted) setState(() => _speechReady = available);
  }

  @override
  void dispose() {
    _speech.stop();
    _tts.stop();
    super.dispose();
  }

  /// يحوّل كود اللغة عندنا (مثل en, fr, ar) إلى معرّف لغة مفهوم للـTTS/Speech
  String _localeIdFor(String code) {
    const map = {
      'en': 'en-US',
      'ar': 'ar-SA',
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
    return map[code] ?? 'en-US';
  }

  Future<void> _playTarget() async {
    await _tts.setLanguage(_localeIdFor(learningLang));
    await _tts.setSpeechRate(0.45);
    await _tts.speak(_sentence.textIn(learningLang));
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _speech.stop();
      setState(() => _isRecording = false);
      return;
    }

    if (!_speechReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('التعرف على الصوت غير متاح على هذا الجهاز')),
      );
      return;
    }

    setState(() {
      _isRecording = true;
      _accuracy = null;
      _recognizedText = '';
    });

    await _speech.listen(
      localeId: _localeIdFor(learningLang),
      onResult: (result) {
        setState(() {
          _recognizedText = result.recognizedWords;
        });
        if (result.finalResult) {
          _evaluate(result.recognizedWords);
        }
      },
      listenFor: const Duration(seconds: 12),
      pauseFor: const Duration(seconds: 3),
    );
  }

  /// يحسب نسبة التطابق الفعلية بين ما نطقه المستخدم والجملة المطلوبة
  void _evaluate(String spoken) {
    final target = _normalize(_sentence.textIn(learningLang));
    final said = _normalize(spoken);
    final score = _similarity(target, said);
    setState(() {
      _accuracy = score;
      _recognizedText = spoken;
      _isRecording = false;
      if (score >= 0.75) _correctCount++;
    });
  }

  String _normalize(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .trim();
  }

  /// نسبة تشابه بسيطة بين نصين اعتماداً على مسافة ليفنشتاين الحرفية
  double _similarity(String a, String b) {
    if (a.isEmpty && b.isEmpty) return 1.0;
    if (a.isEmpty || b.isEmpty) return 0.0;
    final distance = _levenshtein(a, b);
    final maxLen = a.length > b.length ? a.length : b.length;
    return (1 - (distance / maxLen)).clamp(0.0, 1.0);
  }

  int _levenshtein(String s, String t) {
    final m = s.length, n = t.length;
    final d = List.generate(m + 1, (_) => List<int>.filled(n + 1, 0));
    for (var i = 0; i <= m; i++) d[i][0] = i;
    for (var j = 0; j <= n; j++) d[0][j] = j;
    for (var i = 1; i <= m; i++) {
      for (var j = 1; j <= n; j++) {
        final cost = s[i - 1] == t[j - 1] ? 0 : 1;
        d[i][j] = [
          d[i - 1][j] + 1,
          d[i][j - 1] + 1,
          d[i - 1][j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
    }
    return d[m][n];
  }

  void _next() {
    if (_index < widget.sentences.length - 1) {
      setState(() {
        _index++;
        _accuracy = null;
        _recognizedText = '';
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LessonCompleteScreen(
            correctCount: _correctCount,
            total: widget.sentences.length,
            pointsEarned: _correctCount * 10,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSuccess = (_accuracy ?? 0) >= 0.75;

    return Scaffold(
      backgroundColor: PracticeColors.speakingBg,
      appBar: AppBar(
        backgroundColor: PracticeColors.speakingBg,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text('الدرس ${widget.lessonNumber} — التحدث'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Center(
              child: Text('${_index + 1}/${widget.sentences.length}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              _sentence.textIn(learningLang),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _sentence.textIn(nativeLang),
              textAlign: TextAlign.center,
              style: const TextStyle(color: PracticeColors.textSecondary, fontSize: 16),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: PracticeColors.speakingCard,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: _playTarget,
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: PracticeColors.primary,
                      ),
                      child: const Icon(Icons.volume_up, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('استمع للنطق الصحيح',
                      style: TextStyle(color: PracticeColors.textSecondary)),
                ],
              ),
            ),
            const Spacer(),
            if (_accuracy != null) ...[
              Text(
                '${(_accuracy! * 100).round()}%',
                style: TextStyle(
                  color: isSuccess ? PracticeColors.correct : PracticeColors.wrong,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text('الدقة', style: TextStyle(color: PracticeColors.textSecondary)),
              const SizedBox(height: 8),
              Text(
                isSuccess ? '✨ ممتاز! نطق رائع' : 'أعد المحاولة',
                style: TextStyle(
                    color: isSuccess ? PracticeColors.correct : PracticeColors.wrong,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text('قلت: "$_recognizedText"',
                  style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 20),
            ] else if (_isRecording && _recognizedText.isNotEmpty) ...[
              Text('"$_recognizedText"',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 16)),
              const SizedBox(height: 20),
            ],
            GestureDetector(
              onTap: _toggleRecording,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: _isRecording
                        ? [PracticeColors.wrong, PracticeColors.wrong]
                        : [PracticeColors.recordButtonStart, PracticeColors.recordButtonEnd],
                  ),
                ),
                child: Icon(_isRecording ? Icons.stop : Icons.mic,
                    color: Colors.white, size: 32),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isRecording ? 'يستمع الآن...' : 'اضغط وسجّل نطقك للجملة أعلاه',
              style: const TextStyle(color: PracticeColors.textSecondary),
            ),
            const SizedBox(height: 16),
            if (_accuracy != null && isSuccess)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PracticeColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('متابعة', style: TextStyle(color: Colors.white)),
                ),
              ),
            if (_accuracy != null && !isSuccess)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => setState(() {
                    _accuracy = null;
                    _recognizedText = '';
                  }),
                  child: const Text('أعد المحاولة',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
