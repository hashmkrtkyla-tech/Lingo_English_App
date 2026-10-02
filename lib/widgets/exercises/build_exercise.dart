import 'package:flutter/material.dart';
import '../../data/feedback_messages.dart';
import '../../models/exercise_model.dart';
import '../../services/course_tts.dart';
import 'ex_common.dart';

/// ترجم الجملة (ترتيب كلمات) / أدخل ما تسمع (promptIsAudio)
class BuildExercise extends StatefulWidget {
  final ExerciseModel ex;
  final String lang, nativeLang;
  final ExerciseController ctrl;
  final VoidCallback onSkip;
  const BuildExercise({
    super.key,
    required this.ex,
    required this.lang,
    required this.nativeLang,
    required this.ctrl,
    required this.onSkip,
  });

  @override
  State<BuildExercise> createState() => _BuildExerciseState();
}

class _BuildExerciseState extends State<BuildExercise> {
  late final List<String> _bank;
  final List<int> _picked = [];
  ExerciseModel get ex => widget.ex;
  late final UiText _ui = uiFor(widget.nativeLang);
  bool get _answerIsTarget => ex.answerLang != 'native';

  @override
  void initState() {
    super.initState();
    _bank = [...ex.words, ...ex.distractors]..shuffle();
    widget.ctrl.checker = _check;
    // عند الإجابة الصحيحة ينطق الجملة كاملة
    widget.ctrl.onResult = (ok) {
      if (ok && _answerIsTarget) {
        CourseTts.speak(ex.words.join(ex.joiner), widget.lang);
      }
    };
    autoSpeak(ex, widget.lang, widget.nativeLang);
  }

  bool _check() =>
      _picked.map((i) => _bank[i]).join(ex.joiner) == ex.words.join(ex.joiner);

  void _tapBank(int i) {
    if (_picked.contains(i)) return;
    setState(() => _picked.add(i));
    widget.ctrl.setReady(true);
    if (_answerIsTarget) CourseTts.speak(_bank[i], widget.lang);
  }

  void _tapAnswer(int i) {
    setState(() => _picked.remove(i));
    widget.ctrl.setReady(_picked.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final aDir = dirOf(sideLang(ex.answerLang, widget.lang, widget.nativeLang));
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(exTitle(ex, _ui), style: kTitleStyle),
        const SizedBox(height: 24),
        PromptRow(ex: ex, lang: widget.lang, nativeLang: widget.nativeLang),
        const SizedBox(height: 24),
        Directionality(
          textDirection: aDir,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 120),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              border: Border.symmetric(
                  horizontal: BorderSide(color: kLine, width: 2)),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 10,
              children: _picked
                  .map((i) => WordChip(_bank[i], onTap: () => _tapAnswer(i)))
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Directionality(
          textDirection: aDir,
          child: Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 10,
              children: List.generate(
                _bank.length,
                (i) => WordChip(_bank[i],
                    ghost: _picked.contains(i), onTap: () => _tapBank(i)),
              ),
            ),
          ),
        ),
        if (ex.promptIsAudio) ...[
          const SizedBox(height: 24),
          SkipLink(_ui.skipListen, onTap: widget.onSkip),
        ],
      ]),
    );
  }
}
