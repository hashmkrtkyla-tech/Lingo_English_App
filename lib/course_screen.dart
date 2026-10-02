import 'package:flutter/material.dart';
import '../data/level_config.dart';
import '../main.dart';
import '../models/language_model.dart';
import '../models/lesson_model.dart';
import '../services/course_service.dart';
import '../services/progress_service.dart';
import '../utils/app_colors.dart';
import 'lesson_screen.dart';

/// صفحة الدورة (التبويب الأول). تقرأ اللغة من AppState وتحفظ أي تغيير فيها.
class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  List<LanguageModel> _langs = [];
  String _lang = AppState.currentLanguageCode;
  int _levelIdx = 0;
  List<LessonModel> _lessons = [];
  int _done = 0;
  bool _loading = true;
  final int _streak = 7; // TODO: من بيانات المستخدم لاحقاً

  LevelConfig get _lv => kLevels[_levelIdx];

  // ألوان مشتقة من ألوان التطبيق (AppColors)
  Color get _deep => Color.lerp(AppColors.lilac, Colors.black, 0.3)!;
  Color get _deeper => Color.lerp(AppColors.lilac, Colors.black, 0.55)!;

  LanguageModel? get _current {
    for (final l in _langs) {
      if (l.code == _lang) return l;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _langs = await CourseService.languages();
    await _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    _lessons = await CourseService.lessons(_lang, _lv);
    _done = await ProgressService.completed(_lang, _lv.key);
    if (mounted) setState(() => _loading = false);
  }

  void _pickLanguage() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: _langs
                .map((l) => ListTile(
                      leading: Text(l.flag, style: const TextStyle(fontSize: 26)),
                      title: Text(l.nameAr),
                      subtitle: Text(l.native),
                      trailing: l.code == _lang
                          ? Icon(Icons.check_circle, color: _deep)
                          : null,
                      onTap: () {
                        Navigator.pop(context);
                        _lang = l.code;
                        AppState.currentLanguageCode = l.code;
                        AppState.save();
                        _levelIdx = 0;
                        _load();
                      },
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  Future<void> _openLesson(LessonModel l) async {
    if (l.exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('محتوى هذا الدرس قيد الإعداد')));
      return;
    }
    final done = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => LessonScreen(
          lang: _lang,
          nativeLang: AppState.nativeLanguageCode,
          levelKey: _lv.key,
          lesson: l,
        ),
      ),
    );
    if (done == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.babyBlue,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
            children: [
              _topBar(),
              const SizedBox(height: 16),
              _hero(),
              const SizedBox(height: 28),
              _levelHeader(),
              const SizedBox(height: 16),
              _levelGrid(),
              const SizedBox(height: 18),
              _levelCard(),
              const SizedBox(height: 28),
              _pathHeader(),
              const SizedBox(height: 20),
              if (_loading)
                const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: CircularProgressIndicator()))
              else
                ..._lessons.map(_lessonRow),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar() => Row(children: [
        InkWell(
          onTap: _pickLanguage,
          borderRadius: BorderRadius.circular(22),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(22)),
            child: Row(children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                    color: AppColors.lilac.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12)),
                child: Text(_lang.toUpperCase(),
                    style: TextStyle(
                        color: _deep, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 10),
              Text(_current?.nameAr ?? '',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              const Icon(Icons.keyboard_arrow_down),
            ]),
          ),
        ),
        const Spacer(),
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
              color: _deep,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white, width: 3)),
          alignment: Alignment.center,
          child: const Text('هـ',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
        ),
      ]);

  Widget _chip(IconData i, String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(.14),
            border: Border.all(color: Colors.white24),
            borderRadius: BorderRadius.circular(16)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(i, color: Colors.white, size: 18),
          const SizedBox(width: 6),
          Text(t, style: const TextStyle(color: Colors.white, fontSize: 13)),
        ]),
      );

  Widget _hero() {
    final pct = (_done * 100 / kLessonsPerLevel).round();
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [_deep, _deeper]),
        boxShadow: [
          BoxShadow(
              color: _deep.withOpacity(.3),
              blurRadius: 30,
              offset: const Offset(0, 14))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: const [
          Icon(Icons.auto_awesome, color: Colors.white70),
          SizedBox(width: 8),
          Text('مسارك التعليمي',
              style: TextStyle(color: Colors.white70, fontSize: 16)),
        ]),
        const SizedBox(height: 14),
        Text('تعلّم لتصبح أفضل\nفي ${_current?.nameAr ?? ''}',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                height: 1.35,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        const Text('خطوات صغيرة كل يوم، ونتائج كبيرة مع الوقت.',
            style: TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 22),
        Wrap(spacing: 10, runSpacing: 10, children: [
          _chip(Icons.emoji_events_outlined, 'المستوى ${_lv.code}'),
          _chip(Icons.menu_book_outlined, '$pct% من الدورة'),
          _chip(Icons.star_border, '0 نقطة'),
        ]),
      ]),
    );
  }

  Widget _levelHeader() => Row(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
              color: const Color(0xFFFFF4E0),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFBE3B5))),
          child: Row(children: [
            Text('$_streak',
                style: const TextStyle(
                    color: Color(0xFFD97706),
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            const SizedBox(width: 6),
            const Icon(Icons.local_fire_department, color: Color(0xFFD97706)),
          ]),
        ),
        const Spacer(),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: const [
          Text('رحلتك خطوة بخطوة',
              style: TextStyle(color: Colors.black45, fontSize: 14)),
          SizedBox(height: 4),
          Text('اختر المستوى',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500)),
        ]),
      ]);

  Widget _levelGrid() => GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.7,
        children: List.generate(kLevels.length, (i) {
          final l = kLevels[i];
          final sel = i == _levelIdx;
          return GestureDetector(
            onTap: () {
              _levelIdx = i;
              _load();
            },
            child: Container(
              decoration: BoxDecoration(
                color: sel ? l.soft : AppColors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE6EBF5)),
                boxShadow: sel
                    ? [BoxShadow(color: l.color, offset: const Offset(0, 4))]
                    : null,
              ),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(l.code,
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: sel ? l.color : const Color(0xFF4B5873))),
                Text(l.nameAr,
                    style: TextStyle(
                        fontSize: 13, color: sel ? l.color : Colors.black45)),
              ]),
            ),
          );
        }),
      );

  Widget _levelCard() {
    final lv = _lv;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: lv.soft, borderRadius: BorderRadius.circular(32)),
      child: Column(children: [
        Row(children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
                color: lv.color, borderRadius: BorderRadius.circular(26)),
            alignment: Alignment.center,
            child: Text(lv.code,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 18),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('المستوى ${lv.number} من 6',
                  style: const TextStyle(color: Colors.black45)),
              Text(lv.nameAr,
                  style: const TextStyle(
                      fontSize: 36, fontWeight: FontWeight.w500)),
              Text('${lv.descAr} · $kLessonsPerLevel درساً قصيراً',
                  style: const TextStyle(color: Colors.black54, fontSize: 13)),
            ]),
          ),
        ]),
        const SizedBox(height: 22),
        Row(children: [
          const Text('تقدم المستوى', style: TextStyle(color: Colors.black54)),
          const Spacer(),
          Text('$_done / $kLessonsPerLevel',
              style: TextStyle(color: lv.color, fontWeight: FontWeight.bold)),
        ]),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
              value: _done / kLessonsPerLevel,
              minHeight: 12,
              backgroundColor: Colors.black12,
              color: lv.color),
        ),
      ]),
    );
  }

  Widget _pathHeader() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('المسار الحلزوني',
            style: TextStyle(color: Colors.black45, fontSize: 14)),
        const SizedBox(height: 6),
        Text('دروس ${_lv.nameAr}',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        Row(children: [
          _dot(const Color(0xFF22B573), 'مكتمل'),
          const SizedBox(width: 18),
          _dot(_deep, 'الحالي'),
          const SizedBox(width: 18),
          _dot(const Color(0xFFCBD2E1), 'مقفل'),
        ]),
      ]);

  Widget _dot(Color c, String t) => Row(children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(t, style: const TextStyle(color: Colors.black45)),
      ]);

  Widget _lessonRow(LessonModel l) {
    final done = l.order <= _done;
    final current = l.order == _done + 1;
    final locked = !done && !current;
    final c = _lv.color;

    final circle = Container(
      width: 74,
      height: 74,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done
            ? const Color(0xFF22B573)
            : current
                ? c
                : const Color(0xFFDDE3EF),
        border: Border.all(
            color: current ? c.withOpacity(.35) : Colors.white, width: 6),
      ),
      alignment: Alignment.center,
      child: done
          ? const Icon(Icons.check, color: Colors.white, size: 32)
          : current
              ? Text('${l.order}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold))
              : const Icon(Icons.lock_outline, color: Colors.black38),
    );

    final card = Expanded(
      child: GestureDetector(
        onTap: locked ? null : () => _openLesson(l),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: locked ? const Color(0xFFFAFBFE) : AppColors.white,
            borderRadius: BorderRadius.circular(26),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x14000000), blurRadius: 18, offset: Offset(0, 8))
            ],
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text('الدرس ${l.order}',
                  style: const TextStyle(color: Colors.black38, fontSize: 13)),
              const Spacer(),
              Text(locked ? 'مقفل' : (done ? 'مكتمل' : 'متاح'),
                  style: TextStyle(color: c, fontSize: 13)),
            ]),
            const SizedBox(height: 8),
            Text(kTopicNames[l.topic]![0],
                style: TextStyle(
                    fontSize: 22,
                    color: locked ? Colors.black45 : Colors.black87)),
            Text(l.title,
                style: const TextStyle(color: Colors.black38, fontSize: 13)),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                  value: done ? 1 : 0,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFEDF0F7),
                  color: const Color(0xFF22B573)),
            ),
          ]),
        ),
      ),
    );

    // الفردية: البطاقة يميناً والدائرة يساراً، والعكس للزوجية (مسار حلزوني)
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: l.order.isOdd
            ? [card, const SizedBox(width: 14), circle]
            : [circle, const SizedBox(width: 14), card],
      ),
    );
  }
}
