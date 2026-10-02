import 'package:flutter/material.dart';
import '../data/feedback_messages.dart';
import '../models/exercise_model.dart';
import '../models/lesson_model.dart';
import '../services/feedback_service.dart';
import '../services/progress_service.dart';
import '../widgets/exercises/build_exercise.dart';
import '../widgets/exercises/choice_exercise.dart';
import '../widgets/exercises/ex_common.dart';
import '../widgets/exercises/fill_exercise.dart';
import '../widgets/exercises/listenpick_exercise.dart';
import '../widgets/exercises/match_exercise.dart';
import '../widgets/exercises/speak_exercise.dart';
import '../widgets/exercises/typeword_exercise.dart';
import 'lesson_result_screen.dart';

class LessonScreen extends StatefulWidget {
  final String lang, nativeLang, levelKey;
  final LessonModel lesson;
  const LessonScreen({
    super.key,
    required this.lang,
    required this.levelKey,
    required this.lesson,
    this.nativeLang = 'ar',
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late final List<ExerciseModel> _items;
  late final UiText _ui = uiFor(widget.nativeLang);

  int _i = 0, _combo = 0, _right = 0, _wrong = 0, _tries = 0;
  bool _checked = false, _lastOk = false, _busy = false;
  String _msg = '';
  ExerciseController _ctrl = ExerciseController();
  Key _exKey = UniqueKey();
  final DateTime _start = DateTime.now();

  @override
  void initState() {
    super.initState();
    _items =
        widget.lesson.exercises.map((e) => ExerciseModel.fromJson(e)).toList();
  }

  /// "هيا نرى"
  Future<void> _check() async {
    if (_checked || _busy) return;
    _busy = true;
    final ok = _ctrl.checker();
    _ctrl.onResult?.call(ok);
    final msg = ok
        ? await FeedbackService.nextPraise(_ui.praise)
        : await FeedbackService.nextRetry(_ui.retryMsgs);
    _busy = false;
    if (!mounted) return;
    setState(() {
      _checked = true;
      _lastOk = ok;
      _msg = msg;
      if (ok) {
        if (_tries == 0) {
          _right++;
          _combo++;
        }
        _tries = 0;
      } else {
        _wrong++;
        _tries++;
        _combo = 0;
      }
    });
  }

  /// "محاولة أخرى": نفس التمرين من جديد
  void _retry() {
    setState(() {
      _checked = false;
      _ctrl = ExerciseController();
      _exKey = UniqueKey();
    });
  }

  /// "رائع لنكمل" أو تخطي (للصوت والنطق)
  void _advance() {
    if (_i + 1 >= _items.length) {
      _finish();
      return;
    }
    setState(() {
      _i++;
      _checked = false;
      _tries = 0;
      _ctrl = ExerciseController();
      _exKey = UniqueKey();
    });
  }

  Future<void> _finish() async {
    await ProgressService.completeLesson(
        widget.lang, widget.levelKey, widget.lesson.order);
    final secs = DateTime.now().difference(_start).inSeconds;
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            LessonResultScreen(seconds: secs, right: _right, wrong: _wrong),
      ),
    );
    if (mounted) Navigator.pop(context, true);
  }

  Future<void> _confirmExit() async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(_ui.exitTitle),
          content: Text(_ui.exitBody),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(_ui.exitStay)),
            TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(_ui.exitLeave, style: const TextStyle(color: kRed))),
          ],
        ),
      ),
    );
    if (yes == true && mounted) Navigator.pop(context, false);
  }

  Widget _exercise(ExerciseModel ex) {
    final l = widget.lang, n = widget.nativeLang;
    switch (ex.type) {
      case ExType.choice:
        return ChoiceExercise(
            key: _exKey, ex: ex, lang: l, nativeLang: n, ctrl: _ctrl, onSkip: _advance);
      case ExType.build:
        return BuildExercise(
            key: _exKey, ex: ex, lang: l, nativeLang: n, ctrl: _ctrl, onSkip: _advance);
      case ExType.fill:
        return FillExercise(
            key: _exKey, ex: ex, lang: l, nativeLang: n, ctrl: _ctrl, onSkip: _advance);
      case ExType.listenpick:
        return ListenPickExercise(
            key: _exKey, ex: ex, lang: l, nativeLang: n, ctrl: _ctrl, onSkip: _advance);
      case ExType.typeword:
        return TypeWordExercise(
            key: _exKey, ex: ex, lang: l, nativeLang: n, ctrl: _ctrl, onSkip: _advance);
      case ExType.speak:
        return SpeakExercise(
            key: _exKey, ex: ex, lang: l, nativeLang: n, ctrl: _ctrl, onSkip: _advance);
      case ExType.match:
        return MatchExercise(
            key: _exKey, ex: ex, lang: l, nativeLang: n, ctrl: _ctrl, onSkip: _advance);
    }
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Column(children: [
        if (_combo >= 3)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text('$_combo ${_ui.comboSuffix}',
                style: const TextStyle(
                    color: Color(0xFFFF9600),
                    fontWeight: FontWeight.w800,
                    fontSize: 16)),
          ),
        Row(children: [
          IconButton(
            onPressed: _confirmExit,
            icon: const Icon(Icons.close_rounded, size: 32, color: Colors.black45),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: _i / _items.length),
                duration: const Duration(milliseconds: 350),
                builder: (_, v, __) => LinearProgressIndicator(
                  value: v,
                  minHeight: 16,
                  backgroundColor: kLine,
                  color: kGreen,
                ),
              ),
            ),
          ),
        ]),
      ]),
    );
  }

  Widget _button(String text, Color c, Color shadow, VoidCallback? onTap) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled ? c : kLine,
          borderRadius: BorderRadius.circular(16),
          boxShadow:
              enabled ? [BoxShadow(color: shadow, offset: const Offset(0, 4))] : null,
        ),
        child: Text(text,
            style: TextStyle(
                color: enabled ? Colors.white : Colors.black38,
                fontSize: 18,
                fontWeight: FontWeight.w800)),
      ),
    );
  }

  Widget _bottom(ExerciseModel ex) {
    if (!_checked) {
      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => _button(
                _ui.check, kGreen, kGreenDark, _ctrl.ready ? _check : null),
          ),
        ),
      );
    }
    final ok = _lastOk;
    final fg = ok ? kGreenDark : kRed;
    return Container(
      width: double.infinity,
      color: ok ? kGreenSoft : kRedSoft,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(ok ? Icons.check_circle : Icons.info_rounded,
                      color: fg, size: 30),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(_msg,
                        style: TextStyle(
                            color: fg, fontSize: 21, fontWeight: FontWeight.w800)),
                  ),
                ]),
                // عند النجاح فقط: معنى الجملة بلغة المستخدم
                if (ok && ex.meaning.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('${_ui.meaning} ${ex.meaning}',
                      style: TextStyle(color: fg, fontSize: 17)),
                ],
                const SizedBox(height: 14),
                _button(
                  ok ? _ui.next : _ui.retryBtn,
                  ok ? kGreen : kRed,
                  ok ? kGreenDark : const Color(0xFFB71C1C),
                  ok ? _advance : _retry,
                ),
              ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ex = _items[_i];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: Column(children: [
            _header(),
            Expanded(
              child: IgnorePointer(ignoring: _checked, child: _exercise(ex)),
            ),
            _bottom(ex),
          ]),
        ),
      ),
    );
  }
}
