import 'package:flutter/material.dart';
import '../../data/feedback_messages.dart';
import '../../models/exercise_model.dart';
import '../../services/course_tts.dart';
import 'ex_common.dart';

/// اكتب الكلمة الناقصة: صوت الجملة كاملة، والجملة مكتوبة وفيها فراغ يكتب فيه المستخدم.
/// sentence: "My mom and my ___"   answer: "dad"   audio: "My mom and my dad"
class TypeWordExercise extends StatefulWidget {
  final ExerciseModel ex;
  final String lang, nativeLang;
  final ExerciseController ctrl;
  final VoidCallback onSkip;
  const TypeWordExercise({
    super.key,
    required this.ex,
    required this.lang,
    required this.nativeLang,
    required this.ctrl,
    required this.onSkip,
  });

  @override
  State<TypeWordExercise> createState() => _TypeWordExerciseState();
}

class _TypeWordExerciseState extends State<TypeWordExercise> {
  final TextEditingController _c = TextEditingController();
  ExerciseModel get ex => widget.ex;
  late final UiText _ui = uiFor(widget.nativeLang);

  @override
  void initState() {
    super.initState();
    widget.ctrl.checker = () {
      final u = norm(_c.text);
      return u == norm(ex.answer) || ex.accept.any((a) => norm(a) == u);
    };
    widget.ctrl.onResult = (ok) {
      if (ok && ex.audio.isNotEmpty) CourseTts.speak(ex.audio, widget.lang);
    };
    autoSpeak(ex, widget.lang, widget.nativeLang);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tDir = dirOf(widget.lang);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(exTitle(ex, _ui), style: kTitleStyle),
        const SizedBox(height: 24),
        PromptRow(
          ex: ex,
          lang: widget.lang,
          nativeLang: widget.nativeLang,
          content: AudioButtons(text: ex.audio, lang: widget.lang),
        ),
        const SizedBox(height: 28),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 150),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: kLine, width: 2),
          ),
          child: sentenceFlow(
            ex.sentence,
            tDir,
            (k) => SizedBox(
              width: 130,
              child: TextField(
                controller: _c,
                textDirection: tDir,
                autocorrect: false,
                enableSuggestions: false,
                style: const TextStyle(fontSize: 22),
                onChanged: (t) => widget.ctrl.setReady(t.trim().isNotEmpty),
                decoration: const InputDecoration(
                  isDense: true,
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kLine, width: 2)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kBlue, width: 2)),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        SkipLink(_ui.skipListen, onTap: widget.onSkip),
      ]),
    );
  }
}
