import 'package:shared_preferences/shared_preferences.dart';

/// تقدم الدروس لكل (لغة + مستوى): عدد الدروس المكتملة
class ProgressService {
  static String _k(String lang, String level) => 'done_${lang}_$level';

  static Future<int> completed(String lang, String level) async {
    final p = await SharedPreferences.getInstance();
    return p.getInt(_k(lang, level)) ?? 0;
  }

  static Future<void> completeLesson(
      String lang, String level, int order) async {
    final p = await SharedPreferences.getInstance();
    final cur = p.getInt(_k(lang, level)) ?? 0;
    if (order > cur) await p.setInt(_k(lang, level), order);
  }
}
