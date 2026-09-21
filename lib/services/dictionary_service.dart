import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/word_model.dart';

class DictionaryService {
  static final DictionaryService _instance = DictionaryService._internal();
  factory DictionaryService() => _instance;
  DictionaryService._internal();

  // أسماء الملفات الـ15 بنفس ترتيبها في المستودع
  static const List<String> wordFiles = [
    'easy_1', 'easy_2', 'easy_3', 'easy_4', 'easy_5',
    'medium_1', 'medium_2', 'medium_3', 'medium_4', 'medium_5',
    'hard_1', 'hard_2', 'hard_3', 'hard_4', 'hard_5',
  ];

  final Map<String, List<WordModel>> _cache = {};
  List<WordModel>? _allWordsCache;

  /// يحمّل ملف كلمات واحد (مثلاً "easy_1") ويخزّنه مؤقتًا
  Future<List<WordModel>> loadFile(String fileName) async {
    if (_cache.containsKey(fileName)) return _cache[fileName]!;

    final raw = await rootBundle
        .loadString('assets/vocabulary/words/$fileName.json');
    final List<dynamic> data = jsonDecode(raw);
    final words = data.map((e) => WordModel.fromJson(e)).toList();

    _cache[fileName] = words;
    return words;
  }

  /// يحمّل كل الملفات الـ15 مرة واحدة (للبحث الشامل)
  Future<List<WordModel>> loadAllWords() async {
    if (_allWordsCache != null) return _allWordsCache!;

    final List<WordModel> all = [];
    for (final file in wordFiles) {
      all.addAll(await loadFile(file));
    }
    _allWordsCache = all;
    return all;
  }

  /// بحث يطابق أي لغة من اللغات الـ15
  Future<List<WordModel>> search(String query) async {
    if (query.trim().isEmpty) return [];
    final all = await loadAllWords();
    final q = query.trim().toLowerCase();

    return all.where((w) {
      return w.translations.values
          .any((val) => val.toLowerCase().contains(q));
    }).toList();
  }
}
