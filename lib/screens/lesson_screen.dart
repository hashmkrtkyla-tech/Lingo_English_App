import 'dart:math';
import 'package:flutter/material.dart';
import 'celebration_screen.dart';
import '../data/language_config.dart';
import '../data/word_database.dart';

class LessonScreen extends StatefulWidget {
  final String lessonTitle;
  const LessonScreen({super.key, required this.lessonTitle});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late List<WordEntry> _words;
  int currentQuestion = 0;
  int totalQuestions = 5;
  String? selectedAnswer;
  bool answered = false;
  late List<String> _currentOptions;

  @override
  void initState() {
    super.initState();
    _words = wordDatabaseByLanguage[AppState.currentLanguageCode] ?? [];
    if (_words.isEmpty) {
      // احتياط: لو مافيش كلمات لهذه اللغة بعد، رجّع كلمات إنجليزية افتراضية
      _words = wordDatabaseByLanguage['en'] ?? [];
    }
    _generateOptions();
  }

  WordEntry get _currentWord => _words[currentQuestion % _words.length];

  void _generateOptions() {
    final correct = _currentWord.meaning;
    final wrongPool = _words
        .where((w) => w.meaning != correct)
        .map((w) => w.meaning)
        .toSet()
        .toList();
    wrongPool.shuffle();

    final options = <String>[correct, ...wrongPool.take(3)];
    // لو مافيش كلمات كفاية للخيارات الخاطئة، نكمل بخيارات عامة
    const fallback = ['اختيار خاطئ', 'إجابة أخرى', 'لا شيء مما سبق'];
    int i = 0;
    while (options.length < 4) {
      options.add(fallback[i % fallback.length]);
      i++;
    }
    options.shuffle();
    _currentOptions = options;
  }

  void _selectAnswer(String option) {
    if (answered) return;
    setState(() {
      selectedAnswer = option;
      answered = true;
    });
  }

  void _nextQuestion() {
    if (currentQuestion < totalQuestions - 1) {
      setState(() {
        currentQuestion++;
        selectedAnswer = null;
        answered = false;
        _generateOptions();
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CelebrationScreen(xpEarned: 20)),
      );
    }
  }

  Color _optionColor(String option) {
    if (!answered) return Colors.white;
    if (option == _currentWord.meaning) return Colors.green.shade100;
    if (option == selectedAnswer) return Colors.red.shade100;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final word = _currentWord;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        title: LinearProgressIndicator(
          value: (currentQuestion + 1) / totalQuestions,
          backgroundColor: Colors.grey.shade200,
          color: const Color(0xFF58CC02),
          minHeight: 10,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ما معنى هذه الكلمة؟', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F7FB),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(word.word, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(word.pronunciation, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ..._currentOptions.map((option) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => _selectAnswer(option),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      decoration: BoxDecoration(
                        color: _optionColor(option),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(option, style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                )),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: answered ? _nextQuestion : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF58CC02),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(currentQuestion < totalQuestions - 1 ? 'متابعة' : 'إنهاء'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
