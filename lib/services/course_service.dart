import 'dart:convert';
import 'package:flutter/services.dart';
import '../data/level_config.dart';
import '../models/language_model.dart';
import '../models/lesson_model.dart';

class CourseService {
  static Future<List<LanguageModel>> languages() async {
    final raw = await rootBundle.loadString('assets/course/languages.json');
    return (json.decode(raw) as List)
        .map((e) => LanguageModel.fromJson(e))
        .toList();
  }

  /// يحمّل دروس (لغة + مستوى). ما لم يوجد في الملف يُولَّد تلقائياً (40 درساً).
  static Future<List<LessonModel>> lessons(String lang, LevelConfig lv) async {
    final fromFile = <int, Map<String, dynamic>>{};
    try {
      final raw =
          await rootBundle.loadString('assets/course/$lang/${lv.key}.json');
      final list = (json.decode(raw)['lessons'] as List);
      for (var i = 0; i < list.length; i++) {
        fromFile[i] = Map<String, dynamic>.from(list[i]);
      }
    } catch (_) {
      // لا يوجد ملف بعد: نستخدم الدروس المولّدة
    }

    return List.generate(kLessonsPerLevel, (i) {
      final topic = lv.topics[i % lv.topics.length];
      final round = i ~/ lv.topics.length + 1;
      final names = kTopicNames[topic]!;
      final f = fromFile[i];
      final suffix = round > 1 ? ' $round' : '';
      return LessonModel(
        id: f?['id'] ??
            '${lang}_${lv.key}_${(i + 1).toString().padLeft(2, '0')}',
        order: i + 1,
        topic: topic,
        title: (f?['title'] ?? names[1]) + suffix,
        exercises: List<Map<String, dynamic>>.from(
            (f?['exercises'] ?? const []).map((e) => Map<String, dynamic>.from(e))),
      );
    });
  }
}
