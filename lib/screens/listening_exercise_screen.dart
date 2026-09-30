import 'package:flutter/material.dart';
// TODO: أضف الحزمة في pubspec.yaml: flutter_tts: ^4.0.2
// import 'package:flutter_tts/flutter_tts.dart';
import '../main.dart';
import '../utils/practice_colors.dart';
import '../models/practice_sentence.dart';
import '../services/practice_service.dart';
import 'lesson_complete_screen.dart';

class ListeningExerciseScreen extends StatefulWidget {
  final int lessonNumber;
  final List<PracticeSentence> sentences; // 5 جمل

  const ListeningExerciseScreen({
    super.key,
    required this.lessonNumber,
    required this.sentences,
  });

  @override
  State<ListeningExerciseScreen> createState() =>
      _ListeningExerciseScreenState();
}

class _ListeningExerciseScreenState extends State<ListeningExerciseScreen> {
  final String learningLang = AppState.currentLanguageCode;
  final String nativeLang = 'ar';

  int _index = 0;
  int _correctCount = 0;
  String? _selected;
  bool? _isCorrect;
  late BlankExercise _current;

  @override
  void initState() {
    super.initState();
    _buildCurrent();
  }

  void _buildCurrent() {
    _current = PracticeService.instance.buildBlankExercise(
      sentence: widget.sentences[_index],
      learningLang: learningLang,
      nativeLang: nativeLang,
    );
    _selected = null;
    _isCorrect = null;
  }

  Future<void> _playAudio() async {
    // await _tts.setLanguage(learningLang);
    // await _tts.speak(widget.sentences[_index].textIn(learningLang));
  }

  void _choose(String word) {
    if (_selected != null) return;
    setState(() {
      _selected = word;
      _isCorrect = word == _current.correctWord;
      if (_isCorrect == true) _correctCount++;
    });
  }

  void _next() {
    if (_index < widget.sentences.length - 1) {
      setState(() {
        _index++;
        _buildCurrent();
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
    final options = [_current.correctWord, _current.distractorWord];

    return Scaffold(
      backgroundColor: PracticeColors.background,
      appBar: AppBar(
        backgroundColor: PracticeColors.background,
        foregroundColor: PracticeColors.textPrimary,
        elevation: 0,
        title: Text('الدرس ${widget.lessonNumber} — الاستماع'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Center(
              child: Text('${_index + 1}/${widget.sentences.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_index + 1) / widget.sentences.length,
              backgroundColor: PracticeColors.divider,
              color: PracticeColors.primary,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: PracticeColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: _playAudio,
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: 84,
                      height: 84,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: PracticeColors.primary,
                      ),
                      child: const Icon(Icons.volume_up,
                          color: Colors.white, size: 36),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('اضغط لتشغيل الصوت',
                      style: TextStyle(color: PracticeColors.textSecondary)),
                  const SizedBox(height: 24),
                  Text(
                    _current.textWithBlank,
                    textAlign: TextAlign.center,
                    style:
                        const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ...options.map((word) => _OptionButton(
                  word: word,
                  isSelected: _selected == word,
                  isCorrect: word == _current.correctWord,
                  hasAnswered: _selected != null,
                  onTap: () => _choose(word),
                )),
            const Spacer(),
            if (_selected != null)
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _isCorrect == true
                          ? PracticeColors.correctBg
                          : PracticeColors.wrongBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isCorrect == true ? 'أحسنت! الإجابة صحيحة' : 'حاول مرة أخرى',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _isCorrect == true
                                ? PracticeColors.correctText
                                : PracticeColors.wrong,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(_current.translation),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PracticeColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('متابعة',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final String word;
  final bool isSelected;
  final bool isCorrect;
  final bool hasAnswered;
  final VoidCallback onTap;

  const _OptionButton({
    required this.word,
    required this.isSelected,
    required this.isCorrect,
    required this.hasAnswered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = PracticeColors.divider;
    Color? bgColor;
    if (hasAnswered && isSelected) {
      borderColor = isCorrect ? PracticeColors.correctText : PracticeColors.wrong;
      bgColor = isCorrect ? PracticeColors.correctBg : PracticeColors.wrongBg;
    } else if (hasAnswered && isCorrect) {
      borderColor = PracticeColors.correctText;
      bgColor = PracticeColors.correctBg;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: bgColor ?? PracticeColors.cardBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Text(word, style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
