import 'dart:convert';
import 'package:flutter/services.dart';
import '../data/level_config.dart';
import '../models/language_model.dart';
import '../models/lesson_model.dart';
import 'exercise_generator.dart';

class CourseService {
  static Future<List<LanguageModel>> languages() async {
    final raw = await rootBundle.loadString('assets/course/languages.json');
    return (json.decode(raw) as List)
        .map((e) => LanguageModel.fromJson(e))
        .toList();
  }

  // ---------- قراءة الملفات المجزّأة ----------
  // a1.json ثم a1_2.json ثم a1_3.json ... حتى أول ملف غير موجود.
  // هكذا نضيف 5 دروس جديدة بملف جديد دون لمس القديم.
  static Future<List<Map<String, dynamic>>> _parts(
      String dir, String level) async {
    final out = <Map<String, dynamic>>[];
    for (var i = 1; i <= 30; i++) {
      final name = i == 1 ? level : '${level}_$i';
      try {
        final raw = await rootBundle.loadString('$dir/$name.json');
        out.add(Map<String, dynamic>.from(json.decode(raw) as Map));
      } catch (_) {
        break;
      }
    }
    return out;
  }

  static final Map<String, LangPack?> _packCache = {};

  static Future<LangPack?> _pack(String lang, String level) async {
    final key = '$lang/$level';
    if (_packCache.containsKey(key)) return _packCache[key];
    final parts = await _parts('assets/course/packs/$lang', level);
    if (parts.isEmpty) {
      _packCache[key] = null;
      return null;
    }
    final merged = <String, dynamic>{
      'joiner': parts.first['joiner'] ?? ' ',
      'titles': <String, dynamic>{},
      'c': <String, dynamic>{},
    };
    for (final p in parts) {
      (merged['titles'] as Map<String, dynamic>)
          .addAll(Map<String, dynamic>.from((p['titles'] ?? {}) as Map));
      (merged['c'] as Map<String, dynamic>)
          .addAll(Map<String, dynamic>.from((p['c'] ?? {}) as Map));
    }
    final pack = LangPack.fromJson(merged);
    _packCache[key] = pack;
    return pack;
  }

  static Future<List<Map<String, dynamic>>> _blueprintLessons(
      String level) async {
    final parts = await _parts('assets/course/blueprint', level);
    final out = <Map<String, dynamic>>[];
    for (final p in parts) {
      for (final l in (p['lessons'] as List)) {
        out.add(Map<String, dynamic>.from(l as Map));
      }
    }
    return out;
  }

  /// دروس (لغة تعلم + لغة أم + مستوى)
  static Future<List<LessonModel>> lessons(
      String lang, String nativeLang, LevelConfig lv) async {
    // 1) النظام الجديد: هيكل + حزم نصوص
    final bp = await _blueprintLessons(lv.key);
    if (bp.isNotEmpty) {
      final tgt = await _pack(lang, lv.key);
      final nat = await _pack(nativeLang, lv.key);
      return List.generate(kLessonsPerLevel, (i) {
        if (i >= bp.length) {
          return LessonModel(
              id: '${lang}_${lv.key}_${(i + 1).toString().padLeft(2, '0')}',
              order: i + 1,
              topic: 'قريباً',
              title: '',
              exercises: const []);
        }
        final id = bp[i]['id'] as String;
        final exs = <Map<String, dynamic>>[];
        if (tgt != null && nat != null) {
          final gen = ExerciseGenerator(tgt, nat);
          final raw = (bp[i]['exercises'] as List)
              .map((x) => Map<String, dynamic>.from(x as Map))
              .toList();
          final pool = gen.poolOf(raw);
          for (final e in raw) {
            final m = gen.build(e, pool);
            if (m != null) exs.add(m);
          }
        }
        return LessonModel(
          id: '${lang}_$id',
          order: i + 1,
          topic: nat?.titles[id] ?? 'الدرس ${i + 1}',
          title: tgt?.titles[id] ?? '',
          exercises: exs,
        );
      });
    }

    // 2) احتياط: النظام القديم (ملف دروس كامل لكل لغة)
    final fromFile = <int, Map<String, dynamic>>{};
    try {
      final raw =
          await rootBundle.loadString('assets/course/$lang/${lv.key}.json');
      final list = (json.decode(raw)['lessons'] as List);
      for (var i = 0; i < list.length; i++) {
        fromFile[i] = Map<String, dynamic>.from(list[i]);
      }
    } catch (_) {}

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
        topic: names[0],
        title: (f?['title'] ?? names[1]) + suffix,
        exercises: List<Map<String, dynamic>>.from(
            ((f?['exercises'] ?? const []) as List)
                .map((e) => Map<String, dynamic>.from(e as Map))),
      );
    });
  }
}
