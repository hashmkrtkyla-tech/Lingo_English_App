import 'package:flutter/material.dart';
import '../../data/feedback_messages.dart';
import '../../models/exercise_model.dart';
import '../../services/course_tts.dart';
import 'ex_common.dart';

/// أكمل الجملة: فراغ واحد أو أكثر، والكلمات في الأسفل.
/// الترتيب مهم: أول كلمة تضغطها تدخل الفراغ الأول، والثانية الفراغ الثاني...
/// sentence: "This ___ ___ ."   blanks: ["is","Max"]   distractors: [...]
class FillExercise extends StatefulWidget {
  final ExerciseModel ex;
  final String lang, nativeLang;
  final ExerciseController ctrl;
  final VoidCallback onSkip;
  const FillExercise({
    super.key,
    required this.ex,
    required this.lang,
    required this.nativeLang,
    required this.ctrl,
    required this.onSkip,
  });

  @override
  State<FillExercise> createState() => _FillExerciseState();
}

class _FillExerciseState extends State<FillExercise> {
  late final List<String> _bank;
  final List<int> _picked = [];
  ExerciseModel get ex => widget.ex;
  late final UiText _ui = uiFor(widget.nativeLang);

  @override
  void initState() {
    super.initState();
    _bank = [...ex.blanks, ...ex.distractors]..shuffle();
    widget.ctrl.checker = () {
      if (_picked.length != ex.blanks.length) return false;
      for (var k = 0; k < ex.blanks.length; k++) {
        if (_bank[_picked[k]] != ex.blanks[k]) return false;
      }
      return true;
    };
    widget.ctrl.onResult = (ok) {
      if (ok && ex.audio.isNotEmpty) CourseTts.speak(ex.audio, widget.lang);
    };
    autoSpeak(ex, widget.lang, widget.nativeLang);
  }

  void _tapBank(int i) {
    if (_picked.contains(i) || _picked.length >= ex.blanks.length) return;
    setState(() => _picked.add(i));
    widget.ctrl.setReady(_picked.length == ex.blanks.length);
    CourseTts.speak(_bank[i], widget.lang);
  }

  void _tapSlot(int k) {
    if (k >= _picked.length) return;
    setState(() => _picked.removeAt(k));
    widget.ctrl.setReady(false);
  }

  Widget _slot(int k) {
    if (k < _picked.length) {
      return WordChip(_bank[_picked[k]], green: true, onTap: () => _tapSlot(k));
    }
    return gapBox();
  }

  @override
  Widget build(BuildContext context) {
    final pLang = sideLang(ex.promptLang, widget.lang, widget.nativeLang);
    final aDir = dirOf(sideLang(ex.answerLang, widget.lang, widget.nativeLang));

    final bubble = Row(mainAxisSize: MainAxisSize.min, children: [
      if (ex.audio.isNotEmpty)
        InkWell(
          onTap: () => CourseTts.speak(ex.audio, widget.lang),
          child: const Padding(
            padding: EdgeInsetsDirectional.only(end: 8),
            child: Icon(Icons.volume_up_rounded, color: kBlue, size: 30),
          ),
        ),
      Flexible(child: sentenceFlow(ex.sentence, dirOf(pLang), _slot)),
    ]);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(exTitle(ex, _ui), style: kTitleStyle),
        const SizedBox(height: 24),
        PromptRow(
            ex: ex,
            lang: widget.lang,
            nativeLang: widget.nativeLang,
            content: bubble),
        const SizedBox(height: 60),
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
      ]),
    );
  }
}
