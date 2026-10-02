import 'package:flutter/material.dart';
import '../widgets/exercises/ex_common.dart';

/// شاشة نهاية الدرس: بلا أخطاء! + الوقت + الدقة + نقاط الـXP
class LessonResultScreen extends StatelessWidget {
  final int seconds, right, wrong;
  const LessonResultScreen(
      {super.key,
      required this.seconds,
      required this.right,
      required this.wrong});

  Widget _stat(String label, String value, Color c) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: c,
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.all(2.5),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700)),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(value,
                  style: TextStyle(
                      color: c, fontSize: 22, fontWeight: FontWeight.w800)),
            ),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final perfect = wrong == 0;
    final total = right + wrong;
    final acc = total == 0 ? 100 : (right * 100 / total).round();
    final xp = (30 - wrong * 3).clamp(10, 30).toInt();
    final time = '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              const Spacer(),
              const Text('🦉', style: TextStyle(fontSize: 120)),
              const SizedBox(height: 20),
              Text(perfect ? 'بلا أخطاء!' : 'أحسنت!',
                  style: const TextStyle(
                      color: Color(0xFFFFC800),
                      fontSize: 34,
                      fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text(perfect ? 'أداء مثالي، استمر هكذا.' : 'أكملت الدرس، وتتحسن في كل مرة.',
                  style: const TextStyle(color: Colors.black54, fontSize: 16)),
              const SizedBox(height: 32),
              SizedBox(
                height: 100,
                child: Row(children: [
                  _stat('إجمالي نقاط الـXP', '$xp ⚡', const Color(0xFFFFC800)),
                  _stat('مذهل', '$acc%', kGreen),
                  _stat('سريع', time, kBlue),
                ]),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: kBlue,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(color: Color(0xFF1899D6), offset: Offset(0, 4))
                    ],
                  ),
                  child: const Text('احصل على نقاط الـXP',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800)),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
