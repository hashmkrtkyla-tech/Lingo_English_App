import 'package:flutter/material.dart';
import '../../data/feedback_messages.dart';
import '../../models/exercise_model.dart';
import '../../services/course_tts.dart';
import 'ex_common.dart';

/// الأزواج المطابقة:
/// pairs: [[كلمة اللغة المتعلَّمة, ترجمتها بلغة المستخدم], ...]
/// layout "audio" (الافتراضي): اليمين بطاقات صوت، واليسار الكلمات بلغة المستخدم.
/// layout "text": اليمين كلمات اللغة المتعلَّمة مكتوبة.
class MatchExercise extends StatefulWidget {
  final ExerciseModel ex;
  final String lang, nativeLang;
  final ExerciseController ctrl;
  final VoidCallback onSkip;
  const MatchExercise({
    super.key,
    required this.ex,
    required this.lang,
    required this.nativeLang,
    required this.ctrl,
    required this.onSkip,
  });

  @override
  State<MatchExercise> createState() => _MatchExerciseState();
}

class _MatchExerciseState extends State<MatchExercise> {
  late final List<int> _aOrder, _bOrder;
  int? _selA, _selB, _wrongA, _wrongB;
  final Set<int> _done = {};
  ExerciseModel get ex => widget.ex;
  late final UiText _ui = uiFor(widget.nativeLang);
  int get _n => ex.pairs.length;
  bool get _audioMode => ex.layout != 'text';

  @override
  void initState() {
    super.initState();
    _aOrder = List.generate(_n, (i) => i)..shuffle();
    _bOrder = List.generate(_n, (i) => i)..shuffle();
    widget.ctrl.checker = () => true;
  }

  void _tapA(int pos) {
    if (_done.contains(_aOrder[pos])) return;
    CourseTts.speak(ex.pairs[_aOrder[pos]][0], widget.lang);
    setState(() => _selA = pos);
    _try();
  }

  void _tapB(int pos) {
    if (_done.contains(_bOrder[pos])) return;
    setState(() => _selB = pos);
    _try();
  }

  void _try() {
    if (_selA == null || _selB == null) return;
    final a = _aOrder[_selA!], b = _bOrder[_selB!];
    if (a == b) {
      setState(() {
        _done.add(a);
        _selA = null;
        _selB = null;
      });
      if (_done.length == _n) widget.ctrl.setReady(true);
    } else {
      setState(() {
        _wrongA = _selA;
        _wrongB = _selB;
        _selA = null;
        _selB = null;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _wrongA = null;
            _wrongB = null;
          });
        }
      });
    }
  }

  Widget _textTile(String text, String lang,
      {required bool sel,
      required bool wrong,
      required bool done,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: done ? null : onTap,
      child: Opacity(
        opacity: done ? 0.25 : 1,
        child: Container(
          width: double.infinity,
          height: 64,
          alignment: Alignment.center,
          decoration: tileDeco(sel: sel, wrong: wrong),
          child: Directionality(
            textDirection: dirOf(lang),
            child: Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: sel ? kBlue : Colors.black87,
                    fontWeight: FontWeight.w500)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(exTitle(ex, _ui), style: kTitleStyle),
        const SizedBox(height: 40),
        // العمود الأول يظهر على اليمين (الواجهة RTL): الصوت، ثم الكلمات يساراً
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Column(
              children: List.generate(_n, (pos) {
                final id = _aOrder[pos];
                final sel = _selA == pos, wrong = _wrongA == pos;
                final done = _done.contains(id);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _audioMode
                      ? AudioTile(
                          sel: sel,
                          wrong: wrong,
                          done: done,
                          onTap: () => _tapA(pos))
                      : _textTile(ex.pairs[id][0], widget.lang,
                          sel: sel,
                          wrong: wrong,
                          done: done,
                          onTap: () => _tapA(pos)),
                );
              }),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              children: List.generate(_n, (pos) {
                final id = _bOrder[pos];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _textTile(ex.pairs[id][1], widget.nativeLang,
                      sel: _selB == pos,
                      wrong: _wrongB == pos,
                      done: _done.contains(id),
                      onTap: () => _tapB(pos)),
                );
              }),
            ),
          ),
        ]),
      ]),
    );
  }
}
