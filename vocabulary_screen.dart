import 'package:flutter/material.dart';

// ==========================================
// 2. شاشة المفردات والكلمات (Vocabulary Screen)
// ==========================================
class VocabularyScreen extends StatelessWidget {
  const VocabularyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'قاموس الكلمات',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 100),
        children: [
          // كارت البحث والتصفية
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'ابحث عن كلمة...',
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // قسم المفردات المحفوظة
          const Text(
            'الكلمات المحفوظة مؤخراً',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          _buildVocabCard(
            word: 'Resilience',
            translation: 'المرونة / القدرة على التكيف',
            phonetic: '/rɪˈzɪl.jəns/',
            level: 'B2',
            isFavorite: true,
          ),
          _buildVocabCard(
            word: 'Ambition',
            translation: 'الطموح',
            phonetic: '/æmˈbɪʃ.ən/',
            level: 'A2',
            isFavorite: true,
          ),
          _buildVocabCard(
            word: 'Fluency',
            translation: 'الطلاقة اللغوية',
            phonetic: '/ˈfluː.ən.si/',
            level: 'B1',
            isFavorite: false,
          ),
          _buildVocabCard(
            word: 'Perseverance',
            translation: 'المثابرة',
            phonetic: '/ˌpɜː.sɪˈvɪə.rəns/',
            level: 'C1',
            isFavorite: true,
          ),
          _buildVocabCard(
            word: 'Consistency',
            translation: 'الاستمرارية',
            phonetic: '/kənˈsɪs.tən.si/',
            level: 'B2',
            isFavorite: false,
          ),
        ],
      ),
    );
  }

  static Widget _buildVocabCard({
    required String word,
    required String translation,
    required String phonetic,
    required String level,
    required bool isFavorite,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              level,
              style: TextStyle(
                color: Colors.purple.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      word,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      phonetic,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  translation,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.volume_up_rounded,
              color: Colors.blue.shade600,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.bookmark : Icons.bookmark_border,
              color: isFavorite ? Colors.orange : Colors.grey,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
