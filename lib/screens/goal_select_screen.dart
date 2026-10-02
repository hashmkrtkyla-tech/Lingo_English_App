import 'package:flutter/material.dart';
import '../main.dart';
import '../services/course_service.dart';
import '../utils/app_colors.dart';

class _Goal {
  final String key, title, subtitle;
  final IconData icon;
  const _Goal(this.key, this.title, this.subtitle, this.icon);
}

const List<_Goal> _goals = [
  _Goal('study', 'للدراسة', 'أتعلّم لأنجح في دراستي واختباراتي', Icons.school_rounded),
  _Goal('work', 'للعمل', 'أريد لغة تفتح لي فرص عمل أفضل', Icons.work_rounded),
  _Goal('friends', 'للتواصل مع الأصدقاء', 'أتحدث مع أصدقاء من حول العالم', Icons.forum_rounded),
  _Goal('travel', 'للسفر', 'أريد أن أتدبّر أمري في رحلاتي', Icons.flight_takeoff_rounded),
  _Goal('fun', 'للمتعة', 'أحب اللغات وأتعلّم بدافع الفضول', Icons.emoji_emotions_rounded),
];

/// بعد اختيار لغة التعلم: ما هدفك؟ ثم تفتح الدورة بهذه اللغة
class GoalSelectScreen extends StatefulWidget {
  final String languageCode;
  const GoalSelectScreen({super.key, required this.languageCode});

  @override
  State<GoalSelectScreen> createState() => _GoalSelectScreenState();
}

class _GoalSelectScreenState extends State<GoalSelectScreen> {
  String? _goal;
  String _langName = '';

  @override
  void initState() {
    super.initState();
    _goal = AppState.goal;
    CourseService.languages().then((list) {
      for (final l in list) {
        if (l.code == widget.languageCode && mounted) {
          setState(() => _langName = l.nameAr);
        }
      }
    });
  }

  Future<void> _start() async {
    if (_goal == null) return;
    AppState.currentLanguageCode = widget.languageCode;
    AppState.goal = _goal!;
    await AppState.save();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainNavigation()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final deep = Color.lerp(AppColors.lilac, Colors.black, 0.3)!;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.babyBlue,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: deep),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _langName.isEmpty
                      ? 'لماذا تريد أن تتعلم؟'
                      : 'لماذا تريد تعلّم $_langName؟',
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                const Text('سنرتّب لك الدروس بما يناسب هدفك',
                    style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 22),
                Expanded(
                  child: ListView.separated(
                    itemCount: _goals.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final g = _goals[i];
                      final sel = _goal == g.key;
                      return GestureDetector(
                        onTap: () => setState(() => _goal = g.key),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: sel
                                ? AppColors.lilac.withOpacity(0.18)
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: sel ? deep : Colors.black12, width: 2),
                          ),
                          child: Row(children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: AppColors.lilac.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(g.icon, color: deep, size: 28),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(g.title,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 2),
                                  Text(g.subtitle,
                                      style: const TextStyle(
                                          color: Colors.black54, fontSize: 13)),
                                ],
                              ),
                            ),
                            if (sel) Icon(Icons.check_circle, color: deep),
                          ]),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _goal == null ? null : _start,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: deep,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('ابدأ التعلم',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
