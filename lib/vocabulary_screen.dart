import 'package:flutter/material.dart';
import 'models/word_model.dart';
import 'services/dictionary_service.dart';
import 'services/tts_service.dart';
import 'utils/app_colors.dart';
import 'utils/language_config.dart';
import 'screens/words_file_screen.dart';
import 'screens/letters_screen.dart';

// ==========================================
// شاشة المفردات والكلمات (Vocabulary Screen)
// القاموس الكامل: 3000 كلمة × 15 لغة + بحث ثنائي + حروف أبجدية
// ==========================================
class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key});

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _LevelFileInfo {
  final String fileName;
  final String levelLabel;
  final int start;
  final int end;

  const _LevelFileInfo(this.fileName, this.levelLabel, this.start, this.end);
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TtsService _tts = TtsService();

  List<WordModel> _searchResults = [];
  bool _isSearching = false;

  static const List<_LevelFileInfo> _easyFiles = [
    _LevelFileInfo('easy_1', 'المستوى 1', 1, 200),
    _LevelFileInfo('easy_2', 'المستوى 2', 201, 400),
    _LevelFileInfo('easy_3', 'المستوى 3', 401, 600),
    _LevelFileInfo('easy_4', 'المستوى 4', 601, 800),
    _LevelFileInfo('easy_5', 'المستوى 5', 801, 1000),
  ];

  static const List<_LevelFileInfo> _mediumFiles = [
    _LevelFileInfo('medium_1', 'المستوى 1', 1001, 1200),
    _LevelFileInfo('medium_2', 'المستوى 2', 1201, 1400),
    _LevelFileInfo('medium_3', 'المستوى 3', 1401, 1600),
    _LevelFileInfo('medium_4', 'المستوى 4', 1601, 1800),
    _LevelFileInfo('medium_5', 'المستوى 5', 1801, 2000),
  ];

  static const List<_LevelFileInfo> _hardFiles = [
    _LevelFileInfo('hard_1', 'المستوى 1', 2001, 2200),
    _LevelFileInfo('hard_2', 'المستوى 2', 2201, 2400),
    _LevelFileInfo('hard_3', 'المستوى 3', 2401, 2600),
    _LevelFileInfo('hard_4', 'المستوى 4', 2601, 2800),
    _LevelFileInfo('hard_5', 'المستوى 5', 2801, 3000),
  ];

  Future<void> _onSearchChanged(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }
    setState(() => _isSearching = true);
    final results = await DictionaryService().search(query);
    if (!mounted) return;
    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  void _openFile(_LevelFileInfo info) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WordsFileScreen(
          fileName: info.fileName,
          levelTitle: info.levelLabel,
        ),
      ),
    );
  }

  void _openLetters() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LettersScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool showingSearch = _searchController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        foregroundColor: AppColors.white,
        elevation: 0,
        title: const Text(
          'قاموس الكلمات',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchBox(),
          Expanded(
            child: showingSearch ? _buildSearchResults() : _buildSectionsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.babyBlue,
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          style: const TextStyle(color: AppColors.navy),
          decoration: const InputDecoration(
            hintText: 'ابحث بأي لغة...',
            hintStyle: TextStyle(color: AppColors.navy),
            prefixIcon: Icon(Icons.search, color: AppColors.navy),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_searchResults.isEmpty) {
      return const Center(child: Text('لا توجد نتائج'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) => _buildResultRow(_searchResults[index]),
    );
  }

  /// كل نتيجة بحث تُعرض دائمًا: [كلمة لغة التعلم] + [معنى لغة الأم]
  /// بغض النظر عن اللغة التي كتب بها المستخدم بحثه
  Widget _buildResultRow(WordModel word) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _SearchResultCard(
              text: word.word,
              backgroundColor: AppColors.babyBlue,
              onSpeak: () =>
                  _tts.speak(word.word, LanguageConfig.learningLangCode),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _SearchResultCard(
              text: word.meaning,
              backgroundColor: AppColors.sage,
              onSpeak: () =>
                  _tts.speak(word.meaning, LanguageConfig.nativeLangCode),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionsList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        _buildSectionTitle('المفردات السهلة'),
        ..._easyFiles.map(_buildLevelTile),
        const SizedBox(height: 20),
        _buildSectionTitle('المفردات المتوسطة'),
        ..._mediumFiles.map(_buildLevelTile),
        const SizedBox(height: 20),
        _buildSectionTitle('المفردات الصعبة'),
        ..._hardFiles.map(_buildLevelTile),
        const SizedBox(height: 20),
        _buildAlphabetCard(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.navy,
        ),
      ),
    );
  }

  Widget _buildLevelTile(_LevelFileInfo info) {
    return Card(
      color: AppColors.babyBlue.withOpacity(0.35),
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: () => _openFile(info),
        leading: const CircleAvatar(
          backgroundColor: AppColors.lilac,
          child: Icon(Icons.description, color: AppColors.white, size: 20),
        ),
        title: Text(
          info.levelLabel,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy),
        ),
        subtitle: Text(
          '${info.fileName}.json · كلمة ${info.start} – ${info.end}',
          style: const TextStyle(color: AppColors.navy, fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_left, color: AppColors.navy),
      ),
    );
  }

  Widget _buildAlphabetCard() {
    return InkWell(
      onTap: _openLetters,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.lilac, width: 1.8),
          color: AppColors.lilac.withOpacity(0.12),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: AppColors.lilac,
              child: Icon(Icons.text_fields, color: AppColors.white),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('الحروف الأبجدية',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
                  Text('حروف لغة التعلم المختارة مع النطق الصحيح',
                      style: TextStyle(fontSize: 12, color: AppColors.navy)),
                ],
              ),
            ),
            const Icon(Icons.chevron_left, color: AppColors.navy),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _SearchResultCard extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final VoidCallback onSpeak;

  const _SearchResultCard({
    required this.text,
    required this.backgroundColor,
    required this.onSpeak,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              text.isEmpty ? '—' : text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.navy,
              ),
            ),
          ),
          InkWell(
            onTap: onSpeak,
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.volume_up, size: 20, color: AppColors.navy),
            ),
          ),
        ],
      ),
    );
  }
}
