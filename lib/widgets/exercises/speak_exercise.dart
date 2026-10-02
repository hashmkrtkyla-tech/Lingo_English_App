import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../data/feedback_messages.dart';
import '../../models/exercise_model.dart';
import '../../services/course_tts.dart';
import 'ex_common.dart';

/// انطق هذه الجملة: صوت الجملة ومعها مكتوبة، وفي الأسفل زر تسجيل
class SpeakExercise extends StatefulWidget {
  final ExerciseModel ex;
  final String lang, nativeLang;
  final ExerciseController ctrl;
  final VoidCallback onSkip;
  const SpeakExercise({
    super.key,
    required this.ex,
    required this.lang,
    required this.nativeLang,
    required this.ctrl,
    required this.onSkip,
  });

  @override
  State<SpeakExercise> createState() => _SpeakExerciseState();
}

class _SpeakExerciseState extends State<SpeakExercise> {
  final stt.SpeechToText _stt = stt.SpeechToText();
  bool _avail = false, _listening = false;
  String _heard = '';
  double _score = 0;
  ExerciseModel get ex => widget.ex;
  late final UiText _ui = uiFor(widget.nativeLang);

  @override
  void initState() {
    super.initState();
    widget.ctrl.checker = () => _score >= 0.7;
    autoSpeak(ex, widget.lang, widget.nativeLang);
    _stt.initialize(onStatus: (s) {
      if ((s == 'done' || s == 'notListening') && mounted) {
        setState(() => _listening = false);
      }
    }).then((ok) {
      if (mounted) setState(() => _avail = ok);
    });
  }

  @override
  void dispose() {
    _stt.stop();
    super.dispose();
  }

  List<String> _tok(String s) {
    final n = norm(s);
    if (widget.lang == 'ja' || widget.lang == 'zh') {
      return n.replaceAll(' ', '').split('');
    }
    return n.split(' ');
  }

  double _sim(String heard) {
    final target = _tok(ex.sentence);
    if (target.isEmpty) return 0;
    final h = _tok(heard).toSet();
    return target.where(h.contains).length / target.length;
  }

  Future<void> _toggle() async {
    if (!_avail) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_ui.micUnavailable)));
      return;
    }
    if (_listening) {
      await _stt.stop();
      setState(() => _listening = false);
      return;
    }
    setState(() {
      _listening = true;
      _heard = '';
      _score = 0;
    });
    await _stt.listen(
      localeId: CourseTts.sttLocale(widget.lang),
      listenFor: const Duration(seconds: 10),
      onResult: (r) {
        if (!mounted) return;
        setState(() {
          _heard = r.recognizedWords;
          _score = _sim(_heard);
          if (r.finalResult) _listening = false;
        });
        if (_heard.isNotEmpty) widget.ctrl.setReady(true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(exTitle(ex, _ui), style: kTitleStyle),
        const SizedBox(height: 24),
        PromptRow(ex: ex, lang: widget.lang, nativeLang: widget.nativeLang),
        const SizedBox(height: 40),
        Center(
          child: GestureDetector(
            onTap: _toggle,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: _listening ? kRed : kBlue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: (_listening ? kRed : kBlue).withOpacity(.35),
                      blurRadius: 20,
                      spreadRadius: _listening ? 8 : 0)
                ],
              ),
              child: Icon(_listening ? Icons.stop_rounded : Icons.mic_rounded,
                  color: Colors.white, size: 46),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Center(
          child: Text(_listening ? _ui.listening : _ui.tapSpeak,
              style: const TextStyle(color: kBlue, fontSize: 16)),
        ),
        if (_heard.isNotEmpty) ...[
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kLine, width: 2),
            ),
            child: Directionality(
              textDirection: dirOf(widget.lang),
              child: Text(_heard, style: const TextStyle(fontSize: 20)),
            ),
          ),
        ],
        const SizedBox(height: 24),
        SkipLink(_ui.skipSpeak, onTap: widget.onSkip),
      ]),
    );
  }
}
