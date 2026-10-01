import 'package:flutter/material.dart';
import '../services/language_service.dart';
import '../models/lesson_model.dart';
import 'lesson_screen.dart'; // سنعدله لاحقاً

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  int _selectedLevelIndex = 0;
  final List<String> _levelNames = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
  final List<Color> _levelColors = [
    Colors.blue, Colors.teal, Colors.green, Colors.orange, Colors.deepOrange, Colors.brown,
  ];

  // افتراضياً، سنستخدم 'english' و 'A1' كتجربة
  String _currentLangCode = 'english';
  String get _currentLevel => _levelNames[_selectedLevelIndex];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildLevelSelector(),
            Expanded(
              child: FutureBuilder<List<Lesson>>(
                // إعادة بناء القائمة عند تغيير المستوى
                key: ValueKey('$_currentLangCode-$_currentLevel'),
                future: LanguageService.loadAllLessons(_currentLangCode, _currentLevel),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('لا يوجد محتوى بعد لهذا المستوى'));
                  }

                  final lessons = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100, top: 10),
                    itemCount: lessons.length,
                    itemBuilder: (context, index) {
                      // عمل التعرج (Zigzag)
                      final alignments = [Alignment.center, const Alignment(0.55, 0), Alignment.center, const Alignment(-0.55, 0)];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 28),
                        child: Align(
                          alignment: alignments[index % alignments.length],
                          child: _buildNode(context, lessons[index], _levelColors[_selectedLevelIndex]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text('🇬🇧', style: TextStyle(fontSize: 22)), // يمكن تغييرها حسب اللغة
              const SizedBox(width: 6),
              Text(_currentLangCode == 'english' ? 'الإنجليزية' : _currentLangCode, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: const [
              Icon(Icons.diamond_rounded, color: Colors.blueAccent, size: 22),
              SizedBox(width: 4),
              Text('100', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLevelSelector() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _levelNames.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          bool isSelected = index == _selectedLevelIndex;
          return GestureDetector(
            onTap: () => setState(() => _selectedLevelIndex = index),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? _levelColors[index] : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _levelNames[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNode(BuildContext context, Lesson lesson, Color color) {
    // للتبسيط، الدرس الأول مفتوح، والباقي مقفل (يمكنك تطوير منطق القفل لاحقاً)
    final bool locked = lesson.id != 1;
    
    return GestureDetector(
      onTap: locked
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LessonScreen(lesson: lesson, levelColor: color),
                ),
              );
            },
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: locked ? Colors.grey.shade300 : color,
              boxShadow: [
                if (!locked) BoxShadow(color: color.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Icon(
              locked ? Icons.lock_rounded : Icons.star_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            lesson.title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: locked ? Colors.grey : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
