import 'package:flutter/material.dart';
import '../utils/practice_colors.dart';
import '../services/practice_service.dart';
import 'listening_exercise_screen.dart';
import 'speaking_exercise_screen.dart';
import 'reorder_exercise_screen.dart';

class LessonListScreen extends StatelessWidget {
  final String difficulty; // easy | medium | hard
  final ExerciseType exerciseType;
  final Color accentColor;

  const LessonListScreen({
    super.key,
    required this.difficulty,
    required this.exerciseType,
    required this.accentColor,
  });

  String get _title {
    switch (exerciseType) {
      case ExerciseType.listening:
        return 'تدريب الاستماع';
      case ExerciseType.speaking:
        return 'تدريب التحدث';
      case ExerciseType.reorder:
        return 'ترتيب الجمل';
      case ExerciseType.grammar:
        return 'القواعد';
    }
  }

  @override
  Widget build(BuildContext context) {
    final lessons = PracticeService.instance.lessonsFor(difficulty);

    return Scaffold(
      backgroundColor: PracticeColors.background,
      appBar: AppBar(
        title: Text(_title),
        backgroundColor: PracticeColors.background,
        foregroundColor: PracticeColors.textPrimary,
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.1,
        ),
        itemCount: lessons.length, // 30
        itemBuilder: (context, index) {
          // TODO: اربط isLocked بحالة تقدم المستخدم الفعلية (SharedPreferences/DB)
          final isLocked = false;
          return Material(
            color: PracticeColors.cardBackground,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: isLocked
                  ? null
                  : () => _openLesson(context, lessons[index], index),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: accentColor.withOpacity(0.3)),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isLocked ? Icons.lock : Icons.play_circle_fill,
                      color: isLocked
                          ? PracticeColors.textSecondary
                          : accentColor,
                    ),
                    const SizedBox(height: 6),
                    Text('${index + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _openLesson(BuildContext context, List sentences, int index) {
    final typedSentences = sentences.cast();
    switch (exerciseType) {
      case ExerciseType.listening:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ListeningExerciseScreen(
              lessonNumber: index + 1,
              sentences: typedSentences,
            ),
          ),
        );
        break;
      case ExerciseType.speaking:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SpeakingExerciseScreen(
              lessonNumber: index + 1,
              sentences: typedSentences,
            ),
          ),
        );
        break;
      case ExerciseType.reorder:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReorderExerciseScreen(
              lessonNumber: index + 1,
              sentences: typedSentences,
            ),
          ),
        );
        break;
      case ExerciseType.grammar:
        break; // مقفل حالياً
    }
  }
}
