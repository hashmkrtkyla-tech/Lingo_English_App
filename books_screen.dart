import 'package:flutter/material.dart';

// ==========================================
// 3. شاشة الكتب والمكتبة (Books Screen)
// ==========================================
class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'المكتبة والكتب',
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
          // بنر التوصية
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade700, Colors.indigo.shade900],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'كتاب الأسبوع',
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Sherlock Holmes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'مستوى متوسط • B1-B2',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.menu_book_rounded, color: Colors.white, size: 50),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'جميع الكتب المتاحة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          _buildBookItem(
            title: 'The Little Prince',
            author: 'Antoine de Saint-Exupéry',
            level: 'مبتدئ A1',
            progress: 0.7,
            color: Colors.amber.shade700,
          ),
          _buildBookItem(
            title: 'Animal Farm',
            author: 'George Orwell',
            level: 'متوسط B1',
            progress: 0.2,
            color: Colors.orange.shade800,
          ),
          _buildBookItem(
            title: 'The Great Gatsby',
            author: 'F. Scott Fitzgerald',
            level: 'متقدم C1',
            progress: 0.0,
            color: Colors.purple.shade700,
          ),
        ],
      ),
    );
  }

  static Widget _buildBookItem({
    required String title,
    required String author,
    required String level,
    required double progress,
    required Color color,
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
            width: 50,
            height: 65,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(Icons.book, color: color, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  author,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      level,
                      style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade200,
                    color: color,
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
