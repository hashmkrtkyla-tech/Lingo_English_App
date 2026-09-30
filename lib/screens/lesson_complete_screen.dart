import 'package:flutter/material.dart';
import '../main.dart';
import '../utils/practice_colors.dart';

class LessonCompleteScreen extends StatefulWidget {
  final int correctCount;
  final int total;
  final int pointsEarned;

  const LessonCompleteScreen({
    super.key,
    required this.correctCount,
    required this.total,
    required this.pointsEarned,
  });

  @override
  State<LessonCompleteScreen> createState() => _LessonCompleteScreenState();
}

class _LessonCompleteScreenState extends State<LessonCompleteScreen> {
  @override
  void initState() {
    super.initState();
    AppState.diamonds += widget.pointsEarned;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PracticeColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, color: PracticeColors.premiumGold, size: 96),
              const SizedBox(height: 16),
              const Text('أكملت الدرس بنجاح! 🎉',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('${widget.correctCount} من أصل ${widget.total} إجابات صحيحة',
                  style: const TextStyle(color: PracticeColors.textSecondary)),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  color: PracticeColors.premiumGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.diamond, color: PracticeColors.premiumGold),
                    const SizedBox(width: 8),
                    Text('+${widget.pointsEarned} ماس',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showAdGate(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PracticeColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('الدرس التالي', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                child: const Text('العودة للتدريبات'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAdGate(BuildContext context) {
    // TODO: استبدل هذا بمنطق فعلي: تحقق من حالة الاشتراك أولاً،
    // فإن لم يكن مشتركاً اعرض هذه الشاشة، وإن كان مشتركاً انتقل مباشرة للدرس التالي.
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('الاستمرار إلى الدرس التالي',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: شغّل إعلان مكافأة (Rewarded Ad) عبر Google Mobile Ads
                  // مدة الإعلان المقترحة: 15-30 ثانية (ليست قصيرة جداً ولا طويلة)
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.play_circle_fill),
                label: const Text('مشاهدة إعلان'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: PracticeColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: افتح شاشة الاشتراك (خطط الأسعار وطرق الدفع)
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.workspace_premium, color: PracticeColors.premiumGold),
                label: const Text('اشتراك لإزالة الإعلانات'),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ليس الآن'),
            ),
          ],
        ),
      ),
    );
  }
}
