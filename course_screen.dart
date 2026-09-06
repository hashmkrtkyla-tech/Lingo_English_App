import 'package:flutter/material.dart';

// ==========================================
// 5. شاشة الدورة والدروس (Course Screen)
// ==========================================
class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'دورة التعلم التفاعلية',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 100),
        children: [
          // بنر تقدم الدورة
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C42F5), Color(0xFF8E66FF)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'المستوى الحالي: A1',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'أساسيات المحادثة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: const LinearProgressIndicator(
                          value: 0.4,
                          backgroundColor: Colors.white24,
                          color: Colors.amber,
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.school_rounded, color: Colors.white, size: 36),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'مسار الدروس',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          _buildLessonCard(
            number: '1',
            title: 'التحيات والتعارف',
            subtitle: 'تعلّم كيفية إلقاء التحية والتعريف بنفسك',
            isCompleted: true,
            isLocked: false,
          ),
          _buildLessonCard(
            number: '2',
            title: 'التسوق والمطاعم',
            subtitle: 'جمل شائعة لطلب الطعام والسؤال عن السعر',
            isCompleted: false,
            isActive: true,
            isLocked: false,
          ),
          _buildLessonCard(
            number: '3',
            title: 'الاتجاهات والأماكن',
            subtitle: 'كيف تسأل عن الاتجاهات والتنقل في المدينة',
            isCompleted: false,
            isLocked: true,
          ),
          _buildLessonCard(
            number: '4',
            title: 'العمل والمواعيد',
            subtitle: 'التحدث عن وظيفتك وتنظيم جدول عملك',
            isCompleted: false,
            isLocked: true,
          ),
        ],
      ),
    );
  }

  static Widget _buildLessonCard({
    required String number,
    required String title,
    required String subtitle,
    bool isCompleted = false,
    bool isActive = false,
    bool isLocked = false,
  }) {
    Color statusColor = Colors.grey;
    if (isCompleted) statusColor = Colors.green;
    if (isActive) statusColor = const Color(0xFF6C42F5);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isActive
            ? Border.all(color: const Color(0xFF6C42F5), width: 2)
            : Border.all(color: Colors.transparent),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isLocked ? Colors.grey.shade100 : statusColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isLocked
                  ? const Icon(Icons.lock_outline, color: Colors.grey)
                  : isCompleted
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : Text(
                          number,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isLocked ? Colors.grey : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isLocked ? Colors.grey.shade400 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          if (isActive)
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C42F5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              ),
              child: const Text('ابدأ'),
            ),
        ],
      ),
    );
  }
}
