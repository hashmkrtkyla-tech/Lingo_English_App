import 'dart:math';
import 'package:flutter/material.dart';
import '../main.dart';
import '../utils/practice_colors.dart';
import '../models/practice_sentence.dart';
import '../services/practice_service.dart';

class QuickChallengeScreen extends StatefulWidget {
  const QuickChallengeScreen({super.key});

  @override
  State<QuickChallengeScreen> createState() => _QuickChallengeScreenState();
}

class _QuickChallengeScreenState extends State<QuickChallengeScreen> {
  final String learningLang = AppState.currentLanguageCode;
  final String nativeLang = 'ar';

  late List<PracticeSentence> _questions;
  int _index = 0;
  int _correctCount = 0;
  String? _selected;
  bool? _isCorrect;
  late BlankExercise _current;

  @override
  void initState() {
    super.initState();
    _questions = _pickRandomFive();
    _buildCurrent();
  }

  /// يسحب ٥ جمل عشوائية من أي مستوى (سهل/متوسط/صعب) — بدون محتوى جديد
  List<PracticeSentence> _pickRandomFive() {
    final all = [
      ...PracticeService.instance.lessonsFor('easy').expand((l) => l),
      ...PracticeService.instance.lessonsFor('medium').expand((l) => l),
      ...PracticeService.instance.lessonsFor('hard').expand((l) => l),
    ];
    all.shuffle(Random());
    return all.take(5).toList();
  }

  void _buildCurrent() {
    _current = PracticeService.instance.buildBlankExercise(
      sentence: _questions[_index],
      learningLang: learningLang,
      nativeLang: nativeLang,
    );
    _selected = null;
    _isCorrect = null;
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
    if (_index < _questions.length - 1) {
      setState(() {
        _index++;
        _buildCurrent();
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    final earned = _correctCount * 10;
    AppState.diamonds += earned;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('نتيجة التحدي السريع ⚡'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$_correctCount من أصل ${_questions.length} إجابات صحيحة',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.diamond, color: PracticeColors.premiumGold, size: 18),
                const SizedBox(width: 6),
                Text('+$earned ماس',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: PracticeColors.premiumGold)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // إغلاق الحوار
              Navigator.pop(context); // العودة للشاشة الرئيسية
            },
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
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
        title: const Text('التحدي السريع ⚡'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Center(
              child: Text('${_index + 1}/${_questions.length}',
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
              value: (_index + 1) / _questions.length,
              backgroundColor: PracticeColors.divider,
              color: PracticeColors.mediumTier,
            ),
            const SizedBox(height: 32),
            Text(
              _current.textWithBlank,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ...options.map((word) => Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: InkWell(
                    onTap: () => _choose(word),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: _selected == word
                            ? (_isCorrect == true
                                ? PracticeColors.correctBg
                                : PracticeColors.wrongBg)
                            : PracticeColors.cardBackground,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _selected == word
                              ? (_isCorrect == true
                                  ? PracticeColors.correctText
                                  : PracticeColors.wrong)
                              : PracticeColors.divider,
                          width: 1.5,
                        ),
                      ),
                      child: Text(word, style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                )),
            const Spacer(),
            if (_selected != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PracticeColors.mediumTier,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    _index < _questions.length - 1 ? 'متابعة' : 'إنهاء',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
