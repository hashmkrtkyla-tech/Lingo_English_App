import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/alphabet_model.dart';

class AlphabetService {
  static final AlphabetService _instance = AlphabetService._internal();
  factory AlphabetService() => _instance;
  AlphabetService._internal();

  final Map<String, List<AlphabetLetter>> _cache = {};

  Future<List<AlphabetLetter>> loadAlphabet(String langCode) async {
    if (_cache.containsKey(langCode)) return _cache[langCode]!;

    final raw = await rootBundle
        .loadString('assets/data/alphabets/$langCode.json');
    final List<dynamic> data = jsonDecode(raw);
    final letters = data.map((e) => AlphabetLetter.fromJson(e)).toList();

    _cache[langCode] = letters;
    return letters;
  }
}
