import 'package:flutter/material.dart';

// ==========================================
// 4. شاشة التمارين والتمارين اليومية (Training Screen)
// ==========================================
class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'التمارين اليومية',
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
          // كارت الهدف اليومي
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        value: 0.65,
                        strokeWidth: 6,
                        backgroundColor: Colors.grey.shade200,
                        color: Colors.deepOrange,
                      ),
                    ),
                    const Text(
                      '65%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الهدف اليومي',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'أكملت 13 من أصل 20 دقيقة اليوم',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'أنواع التدريبات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          _buildTrainingCard(
            title: 'تمرين الاستماع',
            subtitle: 'استمع إلى مقاطع صوتية واستخرج المفردات',
            icon: Icons.headphones_rounded,
            color: Colors.blue,
            count: '15 سؤال',
          ),
          _buildTrainingCard(
            title: 'مراجعة القواعد',
            subtitle: 'اختبر مدى استيعابك لقواعد الأزمنة',
            icon: Icons.rule_folder_rounded,
            color: Colors.purple,
            count: '10 أسئلة',
          ),
          _buildTrainingCard(
            title: 'نطق الكلمات',
            subtitle: 'تسجيل صوتي وتصحيح التلفظ التلقائي',
            icon: Icons.mic_rounded,
            color: Colors.teal,
            count: '5 دقائق',
          ),
          _buildTrainingCard(
            title: 'التحدي السريع',
            subtitle: 'أسئلة سريعة لزيادة النقاط والماس',
            icon: Icons.bolt_rounded,
            color: Colors.amber.shade800,
            count: 'تحدي يومي',
          ),
        ],
      ),
    );
  }

  static Widget _buildTrainingCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String count,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        count,
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
