import 'package:flutter/material.dart';
// TODO: أضف الحزم في pubspec.yaml:
//   flutter_tts: ^4.0.2
//   speech_to_text: ^7.0.0
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

  int _index = 0;
  int _correctCount = 0;
  bool _isRecording = false;
  double? _accuracy; // 0..1
  String _recognizedText = '';

  PracticeSentence get _sentence => widget.sentences[_index];

  Future<void> _playTarget() async {
    // final tts = FlutterTts();
    // await tts.setLanguage(learningLang);
    // await tts.speak(_sentence.textIn(learningLang));
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      setState(() => _isRecording = false);
      // TODO: أوقف speech_to_text واحسب نسبة التطابق الفعلية بين
      // ما نطقه المستخدم و _sentence.textIn(learningLang)
      _evaluateMock();
    } else {
      setState(() {
        _isRecording = true;
        _accuracy = null;
        _recognizedText = '';
      });
      // TODO: ابدأ الاستماع عبر speech_to_text هنا
    }
  }

  void _evaluateMock() {
    // قيمة تجريبية مؤقتة إلى حين ربط speech_to_text الفعلي
    setState(() {
      _accuracy = 0.92;
      _recognizedText = _sentence.textIn(learningLang).toLowerCase();
      if (_accuracy! >= 0.75) _correctCount++;
    });
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
          ],
        ),
      ),
    );
  }
}
