import 'package:flutter/material.dart';

enum LessonState { completed, active, locked }

class LessonCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final LessonState state;
  final Color color;
  final VoidCallback? onTap;

  const LessonCard({
    super.key,
    required this.title,
    required this.icon,
    required this.state,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool locked = state == LessonState.locked;
    final bool completed = state == LessonState.completed;

    return Column(
      children: [
        GestureDetector(
          onTap: locked ? null : onTap,
          child: Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: locked ? Colors.grey.shade300 : color,
              boxShadow: state == LessonState.active
                  ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 12)]
                  : const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 3))],
            ),
            child: Icon(
              completed ? Icons.check_rounded : (locked ? Icons.lock_rounded : icon),
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 90,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: locked ? Colors.grey : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
