import 'package:flutter/material.dart';
import '../utils/practice_colors.dart';
import '../services/practice_service.dart';
import 'lesson_list_screen.dart';
import 'quick_challenge_screen.dart';

class TrainingScreen extends StatefulWidget {
  final int dailyGoalMinutes;
  final int minutesCompletedToday;

  const TrainingScreen({
    super.key,
    this.dailyGoalMinutes = 20,
    this.minutesCompletedToday = 0,
  });

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    PracticeService.instance.loadAll().then((_) {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final percent = (widget.minutesCompletedToday / widget.dailyGoalMinutes)
        .clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: PracticeColors.background,
      appBar: AppBar(
        title: const Text('التدريبات'),
        backgroundColor: PracticeColors.background,
        foregroundColor: PracticeColors.textPrimary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _DailyGoalCard(percent: percent, widget: widget),
          const SizedBox(height: 14),
          Material(
            color: PracticeColors.mediumTier.withOpacity(0.12),
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QuickChallengeScreen()),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.bolt_rounded, color: PracticeColors.mediumTier, size: 28),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text('التحدي السريع',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    const Icon(Icons.chevron_left, color: PracticeColors.textSecondary),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('أنواع التدريبات',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _TierSection(
            title: 'التدريبات البدائية',
            color: PracticeColors.easyTier,
            difficulty: 'easy',
          ),
          const SizedBox(height: 20),
          _TierSection(
            title: 'التدريبات المتوسطة',
            color: PracticeColors.mediumTier,
            difficulty: 'medium',
          ),
          const SizedBox(height: 20),
          _TierSection(
            title: 'التدريبات الصعبة',
            color: PracticeColors.hardTier,
            difficulty: 'hard',
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _DailyGoalCard extends StatelessWidget {
  final double percent;
  final TrainingScreen widget;
  const _DailyGoalCard({required this.percent, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: PracticeColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('الهدف اليومي',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(
                  'أكملت ${widget.minutesCompletedToday} من أصل ${widget.dailyGoalMinutes} دقيقة اليوم',
                  style: const TextStyle(color: PracticeColors.textSecondary),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 72,
            height: 72,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: percent,
                  strokeWidth: 7,
                  backgroundColor: PracticeColors.divider,
                  valueColor:
                      const AlwaysStoppedAnimation(PracticeColors.primary),
                ),
                Text('${(percent * 100).round()}%',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TierSection extends StatelessWidget {
  final String title;
  final Color color;
  final String difficulty; // easy | medium | hard

  const _TierSection({
    required this.title,
    required this.color,
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    final types = [
      ExerciseType.listening,
      ExerciseType.speaking,
      ExerciseType.reorder,
      ExerciseType.grammar,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 10),
        ...types.map((t) => _ExerciseTile(type: t, difficulty: difficulty, tierColor: color)),
      ],
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  final ExerciseType type;
  final String difficulty;
  final Color tierColor;

  const _ExerciseTile({
    required this.type,
    required this.difficulty,
    required this.tierColor,
  });

  ({String title, IconData icon}) get _meta {
    switch (type) {
      case ExerciseType.listening:
        return (title: 'تدريب الاستماع', icon: Icons.headphones);
      case ExerciseType.speaking:
        return (title: 'تدريب التحدث', icon: Icons.mic);
      case ExerciseType.reorder:
        return (title: 'تدريب ترتيب الجمل', icon: Icons.swap_horiz);
      case ExerciseType.grammar:
        return (title: 'تدريب القواعد', icon: Icons.rule_folder);
    }
  }

  @override
  Widget build(BuildContext context) {
    final meta = _meta;
    final isLocked = type == ExerciseType.grammar;
    final color = isLocked ? PracticeColors.grammarLocked : tierColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: PracticeColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (isLocked) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('قيد التنفيذ، سيُطلق قريباً 🚧')),
              );
              return;
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LessonListScreen(
                  difficulty: difficulty,
                  exerciseType: type,
                  accentColor: color,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(meta.icon, color: color),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(meta.title,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
                if (isLocked)
                  const Text('قريباً',
                      style: TextStyle(color: PracticeColors.textSecondary))
                else
                  const Icon(Icons.chevron_left, color: PracticeColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
