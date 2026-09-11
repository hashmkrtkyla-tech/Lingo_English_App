// ==========================================
// نموذج الكلمة الواحدة في القاموس
// ==========================================
class WordEntry {
  final String word;         // الكلمة بلغة التعلم
  final String pronunciation; // النطق الصوتي
  final String meaning;       // المعنى بالعربي
  final String level;         // المستوى: A1, A2, B1...

  const WordEntry({
    required this.word,
    required this.pronunciation,
    required this.meaning,
    required this.level,
  });
}

// ==========================================
// قاعدة بيانات الكلمات مقسّمة حسب رمز اللغة
// نموذج أولي بسيط - سيُوسّع لاحقًا باستخدام ملفات Frequency Words الجاهزة عندك
// ==========================================
final Map<String, List<WordEntry>> wordDatabaseByLanguage = {
  'en': [
    WordEntry(word: 'Hello', pronunciation: '/həˈloʊ/', meaning: 'مرحبًا', level: 'A1'),
    WordEntry(word: 'Thank you', pronunciation: '/θæŋk juː/', meaning: 'شكرًا', level: 'A1'),
    WordEntry(word: 'Friend', pronunciation: '/frɛnd/', meaning: 'صديق', level: 'A1'),
  ],
  'es': [
    WordEntry(word: 'Hola', pronunciation: '/ˈola/', meaning: 'مرحبًا', level: 'A1'),
    WordEntry(word: 'Gracias', pronunciation: '/ˈɡɾasjas/', meaning: 'شكرًا', level: 'A1'),
    WordEntry(word: 'Amigo', pronunciation: '/aˈmiɣo/', meaning: 'صديق', level: 'A1'),
  ],
  'fr': [
    WordEntry(word: 'Bonjour', pronunciation: '/bɔ̃ʒuʁ/', meaning: 'مرحبًا', level: 'A1'),
    WordEntry(word: 'Merci', pronunciation: '/mɛʁsi/', meaning: 'شكرًا', level: 'A1'),
    WordEntry(word: 'Ami', pronunciation: '/ami/', meaning: 'صديق', level: 'A1'),
  ],
  'de': [
    WordEntry(word: 'Hallo', pronunciation: '/ˈhaloː/', meaning: 'مرحبًا', level: 'A1'),
    WordEntry(word: 'Danke', pronunciation: '/ˈdaŋkə/', meaning: 'شكرًا', level: 'A1'),
  ],
  'it': [
    WordEntry(word: 'Ciao', pronunciation: '/ˈtʃaːo/', meaning: 'مرحبًا', lev
