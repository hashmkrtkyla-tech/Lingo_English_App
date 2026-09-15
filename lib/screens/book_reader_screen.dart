import 'package:flutter/material.dart';
import '../models/book_model.dart';

class BookReaderScreen extends StatefulWidget {
  final BookModel book;
  final bool isAudioMode;

  const BookReaderScreen({
    Key? key,
    required this.book,
    this.isAudioMode = false,
  }) : super(key: key);

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  bool isDarkMode = false;
  double fontSize = 18.0;
  String selectedLanguage = 'عربي';
  bool isPlaying = false;
  double playbackSpeed = 1.0;

  // نص تجريبي للفصل الأول للتمثيل
  final String chapterTitle = "Chapter 1";
  final String pageIndex = "1 / 6";
  final List<String> paragraphs = [
    "In the wilds of Scotland, amid rolling mists and stormy skies, a fierce battle raged between the forces of King Duncan and the rebellious armies.",
    "Leading the king's forces were two brave generals: Macbeth, the Thane of Glamis, and his loyal friend Banquo.",
    "After a bloody struggle, Macbeth and Banquo emerged victorious, having defeated the invading forces and secured peace for Scotland."
  ];

  void _showSettingsBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // أبلغ عن مشكلة
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: const Text('أبلغ عن مشكلة'),
                    onTap: () {},
                  ),
                  const Divider(),
                  // الوضع المظلم
                  SwitchListTile(
                    title: const Text('الوضع المظلم'),
                    value: isDarkMode,
                    onChanged: (val) {
                      setModalState(() => isDarkMode = val);
                      setState(() => isDarkMode = val);
                    },
                  ),
                  const Divider(),
                  // حجم الخط
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('حجم الخط', style: TextStyle(fontSize: 16)),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (fontSize > 12) {
                                setModalState(() => fontSize--);
                                setState(() => fontSize--);
                              }
                            },
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.blue),
                          ),
                          Text('${fontSize.toInt()}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          IconButton(
                            onPressed: () {
                              if (fontSize < 30) {
                                setModalState(() => fontSize++);
                                setState(() => fontSize++);
                              }
                            },
                            icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                          ),
                        ],
                      )
                    ],
                  ),
                  const Divider(),
                  // لغة الترجمة
                  ListTile(
                    title: const Text('لغة الترجمة'),
                    trailing: Text(selectedLanguage, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    onTap: () {
                      _showLanguageSelector();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showLanguageSelector() {
    final List<String> languages = ['الأفريقانية', 'الألبانية', 'العربية', 'البييلاروسية', 'البلغارية', 'البنغالية'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حدد اللغة', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((lang) {
            return ListTile(
              title: Text(lang, textAlign: TextAlign.center),
              selected: selectedLanguage == lang || (lang == 'العربية' && selectedLanguage == 'عربي'),
              onTap: () {
                setState(() => selectedLanguage = lang);
                Navigator.pop(context);
                Navigator.pop(context); // إغلاق الإعدادات أيضاً
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = isDarkMode ? Colors.black : const Color(0xFFFBF4E9); // لون الورق البيج أو المظلم
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.headphones, size: 16),
              const SizedBox(width: 4),
              Text(widget.isAudioMode ? 'Audio' : 'Read', style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: textColor),
            onPressed: _showSettingsBottomSheet,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  Text(
                    chapterTitle,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pageIndex,
                    style: TextStyle(fontSize: 14, color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  ...paragraphs.map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                p,
                                style: TextStyle(
                                  fontSize: fontSize,
                                  height: 1.6,
                                  color: textColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.g_translate, size: 20, color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
          // مشغل الصوت السفلي
          if (widget.isAudioMode)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[900] : Colors.white,
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Slider(
                    value: 0.1,
                    onChanged: (v) {},
                    activeColor: Colors.deepPurple,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('00:01', style: TextStyle(color: textColor, fontSize: 12)),
                      Text('02:28', style: TextStyle(color: textColor, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text('${playbackSpeed}x', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                      ),
                      IconButton(
                        icon: Icon(Icons.fast_rewind, color: textColor, size: 28),
                        onPressed: () {},
                      ),
                      FloatingActionButton(
                        backgroundColor: Colors.deepPurple,
                        onPressed: () {
                          setState(() => isPlaying = !isPlaying);
                        },
                        child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 32),
                      ),
                      IconButton(
                        icon: Icon(Icons.fast_forward, color: textColor, size: 28),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 30), // موازن للشكل
                    ],
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}
