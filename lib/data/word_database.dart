class WordEntry {
  final String word;
  final String pronunciation;
  final String meaning;
  final String level;

  const WordEntry({
    required this.word,
    required this.pronunciation,
    required this.meaning,
    required this.level,
  });
}

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
    WordEntry(word: 'Ciao', pronunciation: '/tʃaːo/', meaning: 'مرحبًا', level: 'A1'),
    WordEntry(word: 'Grazie', pronunciation: '/ˈɡrattsje/', meaning: 'شكرًا', level: 'A1'),
  ],
  'ja': [
    WordEntry(word: 'こんにちは', pronunciation: 'Konnichiwa', meaning: 'مرحبًا', level: 'A1'),
    WordEntry(word: 'ありがとう', pronunciation: 'Arigatou', meaning: 'شكرًا', level: 'A1'),
  ],
  'ko': [
    WordEntry(word: '안녕하세요', pronunciation: 'Annyeonghaseyo', meaning: 'مرحبًا', level: 'A1'),
    WordEntry(word: '감사합니다', pronunciation: 'Gamsahamnida', meaning: 'شكرًا', level: 'A1'),
  ],
  'tr': [
    WordEntry(word: 'Merhaba', pronunciation: '/mer.haˈba/', meaning: 'مرحبًا', level: 'A1'),
    WordEntry(word: 'Teşekkürler', pronunciation: '/teʃekˈkyɾ.leɾ/', meaning: 'شكرًا', level: 'A1'),
  ],
  'ru': [
    WordEntry(word: 'Привет', pronunciation: 'Privet', meaning: 'مرحبًا', level: 'A1'),
    WordEntry(word: 'Спасибо', pronunciation: 'Spasibo', meaning: 'شكرًا', level: 'A1'),
  ],
  'pt': [
    WordEntry(word: 'Olá', pronunciation: '/oˈla/', meaning: 'مرحبًا', level: 'A1'),
    WordEntry(word: 'Obrigado', pronunciation: '/obɾiˈɡadu/', meaning: 'شكرًا', level: 'A1'),
  ],
};

List<WordEntry> getWordsForLanguage(String languageCode) {
  return wordDatabaseByLanguage[languageCode] ?? [];
}
