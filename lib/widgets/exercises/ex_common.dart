import 'package:flutter/material.dart';
import '../../data/feedback_messages.dart';
import '../../models/exercise_model.dart';
import '../../services/course_tts.dart';

const kGreen = Color(0xFF58CC02);
const kGreenDark = Color(0xFF58A700);
const kGreenSoft = Color(0xFFD7FFB8);
const kBlue = Color(0xFF1CB0F6);
const kBlueSoft = Color(0xFFDDF4FF);
const kRed = Color(0xFFEA2B2B);
const kRedSoft = Color(0xFFFFDFE0);
const kLine = Color(0xFFE5E5E5);
const kInk = Color(0xFF3C3C3C);
const kTitleStyle =
    TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: kInk);
const kAvatars = ['🦉', '🐻', '🧑‍🦱', '👩', '👨‍🦳', '👧', '🧔'];

/// يربط التمرين بزر "هيا نرى" في شاشة الدرس
class ExerciseController extends ChangeNotifier {
  bool ready = false;
  bool Function() checker = () => false;

  /// يُستدعى بعد الضغط على "هيا نرى" (مثلاً لنطق الجملة عند الإجابة الصحيحة)
  void Function(bool ok)? onResult;

  void setReady(bool v) {
    if (ready != v) {
      ready = v;
      notifyListeners();
    }
  }
}

const _accents = {
  'á': 'a', 'à': 'a', 'â': 'a', 'ä': 'a',
  'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e',
  'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i',
  'ó': 'o', 'ò': 'o', 'ô': 'o', 'ö': 'o',
  'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u',
  'ñ': 'n', 'ç': 'c',
};

/// توحيد النص للمقارنة: حروف صغيرة، بدون علامات ترقيم ولا تشكيل لاتيني
String norm(String s) {
  var t = s.toLowerCase();
  _accents.forEach((k, v) => t = t.replaceAll(k, v));
  return t
      .replaceAll(RegExp(r'[.,!?;:،؛؟。！？、，¿¡।]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

TextDirection dirOf(String lang) =>
    lang == 'ar' ? TextDirection.rtl : TextDirection.ltr;

String sideLang(String side, String lang, String nativeLang) =>
    side == 'native' ? nativeLang : lang;

String exTitle(ExerciseModel ex, UiText ui) {
  if (ex.title.isNotEmpty) return ex.title;
  switch (ex.type) {
    case ExType.choice:
      return ui.titles[ex.layout == 'bigcard' ? 'meaning' : 'choice'] ?? '';
    case ExType.build:
      return ui.titles[ex.promptIsAudio ? 'buildAudio' : 'build'] ?? '';
    default:
      return ui.titles[ex.type.name] ?? '';
  }
}

/// ينطق الجملة تلقائياً عند فتح التمرين
void autoSpeak(ExerciseModel ex, String lang, String nativeLang) {
  if (ex.audio.isEmpty) return;
  CourseTts.speak(ex.audio, sideLang(ex.audioLang, lang, nativeLang));
}

BoxDecoration tileDeco({bool sel = false, bool wrong = false}) {
  final c = wrong
      ? kRed
      : sel
          ? kBlue
          : kLine;
  return BoxDecoration(
    color: wrong
        ? kRedSoft
        : sel
            ? kBlueSoft
            : Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: c, width: 2),
    boxShadow: [BoxShadow(color: c, offset: const Offset(0, 3))],
  );
}

/// زرا الصوت: عادي + بطيء
class AudioButtons extends StatelessWidget {
  final String text, lang;
  const AudioButtons({super.key, required this.text, required this.lang});

  @override
  Widget build(BuildContext context) {
    Widget b(IconData i, bool slow) => IconButton(
          onPressed: () => CourseTts.speak(text, lang, slow: slow),
          icon: Icon(i, color: kBlue, size: 34),
        );
    return Row(mainAxisSize: MainAxisSize.min, children: [
      b(Icons.volume_up_rounded, false),
      b(Icons.slow_motion_video, true),
    ]);
  }
}

/// بطاقة صوتية (للأزواج والاستماع)
class AudioTile extends StatelessWidget {
  final bool sel, wrong, done;
  final VoidCallback onTap;
  final double height;
  const AudioTile({
    super.key,
    required this.onTap,
    this.sel = false,
    this.wrong = false,
    this.done = false,
    this.height = 64,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: done ? null : onTap,
      child: Opacity(
        opacity: done ? 0.25 : 1,
        child: Container(
          width: double.infinity,
          height: height,
          alignment: Alignment.center,
          decoration: tileDeco(sel: sel, wrong: wrong),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Icon(Icons.graphic_eq, color: kBlue, size: 32),
            SizedBox(width: 10),
            Icon(Icons.volume_up_rounded, color: kBlue, size: 30),
          ]),
        ),
      ),
    );
  }
}

/// الشخصية + فقاعة الكلام. إن مُرّر content يُستخدم بدل المحتوى الافتراضي
class PromptRow extends StatelessWidget {
  final ExerciseModel ex;
  final String lang, nativeLang;
  final Widget? content;
  const PromptRow({
    super.key,
    required this.ex,
    required this.lang,
    required this.nativeLang,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    final pLang = sideLang(ex.promptLang, lang, nativeLang);
    final aLang = sideLang(ex.audioLang, lang, nativeLang);
    final seed =
        (ex.prompt + ex.sentence + ex.audio + ex.type.name).hashCode.abs();
    final emoji = kAvatars[seed % kAvatars.length];
    final text = ex.type == ExType.speak ? ex.sentence : ex.prompt;

    final Widget body = content ??
        (ex.promptIsAudio
            ? AudioButtons(text: ex.audio, lang: aLang)
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    if (ex.audio.isNotEmpty)
                      InkWell(
                        onTap: () => CourseTts.speak(ex.audio, aLang),
                        child: const Padding(
                          padding: EdgeInsetsDirectional.only(end: 8),
                          child: Icon(Icons.volume_up_rounded,
                              color: kBlue, size: 30),
                        ),
                      ),
                    Flexible(
                      child: Directionality(
                        textDirection: dirOf(pLang),
                        child: Text(text,
                            style: const TextStyle(fontSize: 22, color: kInk)),
                      ),
                    ),
                  ]),
                  if (ex.hint.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(ex.hint,
                          style: const TextStyle(color: Colors.black45)),
                    ),
                ],
              ));

    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(
        width: 96,
        height: 96,
        alignment: Alignment.center,
        decoration:
            const BoxDecoration(color: kBlueSoft, shape: BoxShape.circle),
        child: Text(emoji, style: const TextStyle(fontSize: 52)),
      ),
      const SizedBox(width: 10),
      Flexible(
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kLine, width: 2),
          ),
          child: body,
        ),
      ),
    ]);
  }
}

/// جملة فيها فراغات "___" يملؤها slot(k)
Widget sentenceFlow(
  String sentence,
  TextDirection dir,
  Widget Function(int k) slot, {
  double fontSize = 22,
}) {
  final parts = sentence.split('___');
  final kids = <Widget>[];
  for (var p = 0; p < parts.length; p++) {
    for (final w in parts[p].trim().split(RegExp(r'\s+'))) {
      if (w.isEmpty) continue;
      kids.add(Text(w, style: TextStyle(fontSize: fontSize, color: kInk)));
    }
    if (p < parts.length - 1) kids.add(slot(p));
  }
  return Directionality(
    textDirection: dir,
    child: Wrap(
      spacing: 8,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: kids,
    ),
  );
}

/// مكان الفراغ (خط سفلي) مع محتوى اختياري
Widget gapBox({Widget? child, double minWidth = 70}) => Container(
      constraints: BoxConstraints(minWidth: minWidth),
      height: 44,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kLine, width: 2)),
      ),
      child: child,
    );

class WordChip extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool ghost, green;
  const WordChip(this.text,
      {super.key, this.onTap, this.ghost = false, this.green = false});

  @override
  Widget build(BuildContext context) {
    final border = ghost
        ? const Color(0xFFE9E9E9)
        : green
            ? kGreen
            : kLine;
    return GestureDetector(
      onTap: ghost ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: ghost
              ? const Color(0xFFE9E9E9)
              : green
                  ? kGreenSoft
                  : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border, width: 2),
          boxShadow:
              ghost ? null : [BoxShadow(color: border, offset: const Offset(0, 3))],
        ),
        child: Opacity(
          opacity: ghost ? 0 : 1,
          child: Text(text,
              style: const TextStyle(fontSize: 18, color: Colors.black87)),
        ),
      ),
    );
  }
}

class SkipLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const SkipLink(this.text, {super.key, required this.onTap});

  @override
  Widget build(BuildContext context) => Center(
        child: TextButton(
          onPressed: onTap,
          child: Text(text,
              style: const TextStyle(color: Colors.black45, fontSize: 15)),
        ),
      );
}
