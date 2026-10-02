import 'package:shared_preferences/shared_preferences.dart';

/// يعطي جملة تحفيز جديدة في كل مرة بالترتيب،
/// وبعد آخر جملة يعود إلى الأولى (ويحفظ المكان بين الجلسات).
class FeedbackService {
  static Future<String> nextPraise(List<String> list) => _next('fb_praise', list);
  static Future<String> nextRetry(List<String> list) => _next('fb_retry', list);

  static Future<String> _next(String key, List<String> list) async {
    if (list.isEmpty) return '';
    final p = await SharedPreferences.getInstance();
    final i = (p.getInt(key) ?? 0) % list.length;
    await p.setInt(key, (i + 1) % list.length);
    return list[i];
  }
}
