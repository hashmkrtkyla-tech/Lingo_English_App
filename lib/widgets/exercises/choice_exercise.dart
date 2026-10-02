import 'package:flutter/material.dart';
import '../../data/feedback_messages.dart';
import '../../models/exercise_model.dart';
import '../../services/course_tts.dart';
import 'ex_common.dart';

/// اختر الإجابة الصحيحة / ترجم الجملة بالخيارات / ما معنى هذه الكلمة (layout: bigcard)
class ChoiceExercise extends StatefulWidget {
  final ExerciseModel ex;
  final String lang, nativeLang;
  final ExerciseController ctrl;
  final VoidCallback onSkip;
  const ChoiceExercise({
    super.key,
    required this.ex,
    required this.lang,
    required this.nativeLang,
    required this.ctrl,
    required this.onSkip,
  });

  @override
  State<ChoiceExercise> createState() => _ChoiceExerciseState();
}

class _ChoiceExerciseState extends State<ChoiceExercise> {
  late final List<String> _opts;
  int? _sel;
  ExerciseModel get ex => widget.ex;
  late final UiText _ui = uiFor(widget.nativeLang);

  @override
  void initState() {
    super.initState();
    _opts = [...ex.options]..shuffle();
    widget.ctrl.checker = () => _sel != null && _opts[_sel!] == ex.answer;
    autoSpeak(ex, widget.lang, widget.nativeLang);
  }

  Widget _bigCard() {
    final pLang = sideLang(ex.promptLang, widget.lang, widget.nativeLang);
    final aLang = sideLang(ex.audioLang, widget.lang, widget.nativeLang);
    return GestureDetector(
      onTap: () => CourseTts.speak(ex.audio.isEmpty ? ex.prompt : ex.audio, aLang),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: kLine, width: 2),
        ),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.volume_up_rounded, color: kBlue, size: 34),
            const SizedBox(width: 12),
            Flexible(
              child: Directionality(
                textDirection: dirOf(pLang),
                child: Text(ex.prompt,
                    style: const TextStyle(
                        fontSize: 36, fontWeight: FontWeight.w800, color: kInk)),
              ),
            ),
          ]),
          if (ex.hint.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(ex.hint,
                style: const TextStyle(color: Colors.black45, fontSize: 17)),
          ],
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final aDir = dirOf(sideLang(ex.answerLang, widget.lang, widget.nativeLang));
    final big = ex.layout == 'bigcard';
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(exTitle(ex, _ui), style: kTitleStyle),
        const SizedBox(height: 24),
        big
            ? _bigCard()
            : PromptRow(ex: ex, lang: widget.lang, nativeLang: widget.nativeLang),
        SizedBox(height: big ? 26 : 30),
        ...List.generate(_opts.length, (i) {
          final sel = _sel == i;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () {
                setState(() => _sel = i);
                widget.ctrl.setReady(true);
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: big ? 14 : 18),
                decoration: tileDeco(sel: sel),
                child: Directionality(
                  textDirection: aDir,
                  child: Text(_opts[i],
                      style: TextStyle(
                          fontSize: 19,
                          color: sel ? kBlue : Colors.black87,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ),
          );
        }),
      ]),
    );
  }
}
