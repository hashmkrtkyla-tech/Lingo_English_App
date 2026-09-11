import 'package:flutter/material.dart';
import 'celebration_screen.dart';

class LessonScreen extends StatefulWidget {
  final String lessonTitle;
  const LessonScreen({super.key, required this.lessonTitle});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int currentQuestion = 0;
  final int totalQuestions = 5; // لاحقًا سيأتي هذا الرقم من data/course_data.dart

  void _nextQuestion() {
    if (currentQuestion < totalQuestions - 1) {
      setState(() => currentQuestion++);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CelebrationScreen(xpEarned: 20)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        title: LinearProgressIndicator(
          value: (currentQuestion + 1) / totalQuestions,
          backgroundColor: Colors.grey.shade200,
          color: const Color(0xFF58CC02),
          minHeight: 10,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'سؤال ${currentQuestion + 1} من $totalQuestions',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            // TODO: هنا سيأتي محتوى السؤال الفعلي من data/course_data.dart
            const Text('محتوى السؤال هنا (تجريبي)', style: TextStyle(fontSize: 16)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF58CC02),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('تحقق'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
