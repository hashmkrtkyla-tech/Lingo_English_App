import 'package:flutter/material.dart';
import '../../data/feedback_messages.dart';
import '../../models/exercise_model.dart';
import '../../services/course_tts.dart';
import 'ex_common.dart';

/// استمع للتعرف على الكلمة الناقصة:
/// الجملة فيها فراغ، وتحتها بطاقتا صوت. الضغط على بطاقة ينطق كلمتها ويختارها.
/// sentence: "This is ___ dad ."   options: ["my","hi"]   answer: "my"
class ListenPickExercise extends StatefulWidget {
  final ExerciseModel ex;
  final String lang, nativeLang;
  final ExerciseController ctrl;
  final VoidCallback onSkip;
  const ListenPickExercise({
    super.key,
    required this.ex,
    required this.lang,
    required this.nativeLang,
    required this.ctrl,
    required this.onSkip,
  });

  @override
  State<ListenPickExercise> createState() => _ListenPickExerciseState();
}

class _ListenPickExerciseState extends State<ListenPickExercise> {
  late final List<String> _opts;
  int? _sel;
  ExerciseModel get ex => widget.ex;
  late final UiText _ui = uiFor(widget.nativeLang);

  @override
  void initState() {
    super.initState();
    _opts = [...ex.options]..shuffle();
    widget.ctrl.checker = () => _sel != null && _opts[_sel!] == ex.answer;
    widget.ctrl.onResult = (ok) {
      if (ok && ex.audio.isNotEmpty) CourseTts.speak(ex.audio, widget.lang);
    };
    autoSpeak(ex, widget.lang, widget.nativeLang);
  }

  @override
  Widget build(BuildContext context) {
    final pLang = sideLang(ex.promptLang, widget.lang, widget.nativeLang);

    final bubble = Row(mainAxisSize: MainAxisSize.min, children: [
      if (ex.audio.isNotEmpty)
        InkWell(
          onTap: () => CourseTts.speak(ex.audio, widget.lang),
          child: const Padding(
            padding: EdgeInsetsDirectional.only(end: 8),
            child: Icon(Icons.volume_up_rounded, color: kBlue, size: 30),
          ),
        ),
      Flexible(
        child: sentenceFlow(
          ex.sentence,
          dirOf(pLang),
          (k) => gapBox(
            minWidth: 60,
            child: _sel == null
                ? null
                : Text(_opts[_sel!],
                    style: const TextStyle(
                        fontSize: 22, color: kBlue, fontWeight: FontWeight.w700)),
          ),
        ),
      ),
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
        const SizedBox(height: 40),
        ...List.generate(_opts.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: AudioTile(
              height: 76,
              sel: _sel == i,
              onTap: () {
                setState(() => _sel = i);
                widget.ctrl.setReady(true);
                CourseTts.speak(_opts[i], widget.lang);
              },
            ),
          );
        }),
        const SizedBox(height: 10),
        SkipLink(_ui.skipListen, onTap: widget.onSkip),
      ]),
    );
  }
}
