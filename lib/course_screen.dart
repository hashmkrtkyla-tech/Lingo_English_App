import 'package:flutter/material.dart';
import 'data/language_config.dart';
import 'data/course_data.dart';
import 'screens/lesson_screen.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String langCode = AppState.currentLanguageCode;
    final List<UnitData> units = courseDataByLanguage[langCode] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: units.isEmpty
                  ? const Center(child: Text('لا يوجد محتوى بعد لهذه اللغة'))
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100, top: 10),
                      itemCount: units.length,
                      itemBuilder: (context, index) => _UnitSection(unit: units[index]),
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
              Text(AppState.currentLanguage.flagEmoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 6),
              Text(AppState.currentLanguage.name, style: const TextStyle(fontWeight: FontWeight.bold)),
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
}

class _UnitSection extends StatelessWidget {
  final UnitData unit;
  const _UnitSection({required this.unit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: unit.color, borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              const Icon(Icons.menu_book_rounded, color: Colors.white, size: 26),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(unit.title, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    Text(unit.subtitle, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(unit.nodes.length, (i) {
          final alignments = [Alignment.center, const Alignment(0.55, 0), Alignment.center, const Alignment(-0.55, 0)];
          return Padding(
            padding: const EdgeInsets.only(bottom: 28),
            child: Align(
              alignment: alignments[i % alignments.length],
              child: _buildNode(context, unit.nodes[i], unit.color),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildNode(BuildContext context, PathNode node, Color color) {
    final bool locked = node.state == NodeState.locked;
    final bool completed = node.state == NodeState.completed;

    return GestureDetector(
      onTap: locked
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LessonScreen(lessonTitle: node.title)),
              );
            },
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(shape: BoxShape.circle, color: locked ? Colors.grey.shade300 : color),
            child: Icon(completed ? Icons.check_rounded : (locked ? Icons.lock_rounded : node.icon), color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(node.title, style: TextStyle(fontSize: 12, color: locked ? Colors.grey : Colors.black87)),
        ],
      ),
    );
  }
}
