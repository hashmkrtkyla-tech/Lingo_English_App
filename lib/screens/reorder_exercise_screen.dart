import 'package:flutter/material.dart';
import '../utils/practice_colors.dart';
import '../models/practice_sentence.dart';
import '../services/practice_service.dart';
import 'lesson_complete_screen.dart';

class ReorderExerciseScreen extends StatefulWidget {
  final int lessonNumber;
  final List<PracticeSentence> sentences;

  const ReorderExerciseScreen({
    super.key,
    required this.lessonNumber,
    required this.sentences,
  });

  @override
  State<ReorderExerciseScreen> createState() => _ReorderExerciseScreenState();
}

class _ReorderExerciseScreenState extends State<ReorderExerciseScreen> {
  final String learningLang = 'en';

  int _index = 0;
  int _correctCount = 0;
  List<String> _bank = [];
  List<String> _chosen = [];
  bool? _isCorrect;

  @override
  void initState() {
    super.initState();
    _setupSentence();
  }

  void _setupSentence() {
    _bank =
        PracticeService.instance.wordsForReorder(widget.sentences[_index], learningLang);
    _chosen = [];
    _isCorrect = null;
  }

  void _pickWord(String word, int bankIndex) {
    if (_isCorrect != null) return;
    setState(() {
      _chosen.add(word);
      _bank.removeAt(bankIndex);
    });
  }

  void _removeChosen(int index) {
    if (_isCorrect != null) return;
    setState(() {
      _bank.add(_chosen[index]);
      _chosen.removeAt(index);
    });
  }

  void _check() {
    final correct =
        PracticeService.instance.correctOrder(widget.sentences[_index], learningLang);
    final isRight = const ListEquality().equals(_chosen, correct);
    setState(() {
      _isCorrect = isRight;
      if (isRight) _correctCount++;
    });
  }

  void _retry() {
    setState(() => _setupSentence());
  }

  void _next() {
    if (_index < widget.sentences.length - 1) {
      setState(() {
        _index++;
        _setupSentence();
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
    return Scaffold(
      backgroundColor: PracticeColors.background,
      appBar: AppBar(
        backgroundColor: PracticeColors.background,
        foregroundColor: PracticeColors.textPrimary,
        elevation: 0,
        title: Text('الدرس ${widget.lessonNumber} — ترتيب الجمل'),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('رتّب الكلمات لتكوين الجملة الصحيحة',
                textAlign: TextAlign.center,
                style: TextStyle(color: PracticeColors.textSecondary)),
            const SizedBox(height: 20),
            Container(
              constraints: const BoxConstraints(minHeight: 90),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: PracticeColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isCorrect == null
                      ? PracticeColors.divider
                      : (_isCorrect! ? PracticeColors.correctText : PracticeColors.wrong),
                  width: 1.5,
                ),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (int i = 0; i < _chosen.length; i++)
                    _WordChip(
                      word: _chosen[i],
                      color: PracticeColors.primaryDark,
                      onTap: () => _removeChosen(i),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                for (int i = 0; i < _bank.length; i++)
                  _WordChip(
                    word: _bank[i],
                    color: PracticeColors.textSecondary,
                    onTap: () => _pickWord(_bank[i], i),
                  ),
              ],
            ),
            const Spacer(),
            if (_isCorrect != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  _isCorrect! ? 'أحسنت! الترتيب صحيح' : 'أعد المحاولة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _isCorrect! ? PracticeColors.correctText : PracticeColors.wrong,
                  ),
                ),
              ),
            ElevatedButton(
              onPressed: _isCorrect == true
                  ? _next
                  : (_isCorrect == false ? _retry : (_bank.isEmpty ? _check : null)),
              style: ElevatedButton.styleFrom(
                backgroundColor: PracticeColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                _isCorrect == true
                    ? 'متابعة'
                    : (_isCorrect == false ? 'أعد المحاولة' : 'تحقق'),
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WordChip extends StatelessWidget {
  final String word;
  final Color color;
  final VoidCallback onTap;

  const _WordChip({required this.word, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Text(word, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

/// مساعد بسيط لمقارنة قائمتين من النصوص (لتفادي إضافة حزمة خارجية فقط لهذا الغرض)
class ListEquality {
  const ListEquality();
  bool equals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].toLowerCase() != b[i].toLowerCase()) return false;
    }
    return true;
  }
}
