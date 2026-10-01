

import 'dart:convert';
import 'package:flutter/services.dart';
import '../data/language_config.dart';
import '../data/course_data.dart';
import '../data/word_database.dart';
import '../models/lesson_model.dart';

class LanguageService {
  
  // ==========================================
  // 1. الدوال القديمة (التي تستخدمها الصفحات الأخرى)
  // ==========================================

  // جلب اسم وعلم اللغة الحالية
  static LanguageOption get currentLanguage => AppState.currentLanguage;

  // تغيير اللغة المختارة للتعلم
  static void setLearningLanguage(String languageCode) {
    AppState.currentLanguageCode = languageCode;
  }

  // جلب وحدات الدورة الخاصة باللغة الحالية (الطريقة القديمة - Static)
  static List<UnitData> getCourseUnits() {
    return courseDataByLanguage[AppState.currentLanguageCode] ?? [];
  }

  // جلب كلمات القاموس الخاصة باللغة الحالية
  static List<WordEntry> getVocabularyWords() {
    return wordDatabaseByLanguage[AppState.currentLanguageCode] ?? [];
  }

  // التحقق: هل يوجد محتوى فعلي جاهز لهذه اللغة؟ (للطريقة القديمة)
  static bool hasContent(String languageCode) {
    final units = courseDataByLanguage[languageCode];
    return units != null && units.isNotEmpty;
  }

  // ==========================================
  // 2. الدوال الجديدة (التي تعتمد على ملفات JSON)
  // ==========================================

  /// تحميل جميع دروس مستوى معين (مثلاً A1) للغة معينة (مثلاً english)
  /// هذه الدالة تُستخدم في صفحة الدورة الجديدة (CourseScreen)
  static Future<List<Lesson>> loadAllLessons(String langCode, String level) async {
    try {
      final String path = 'assets/data/$langCode/$level.json';
      final String jsonString = await rootBundle.loadString(path);
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      final List<dynamic> lessons = jsonData['lessons'];
      return lessons.map((l) => Lesson.fromJson(l)).toList();
    } catch (e) {
      // إذا لم يوجد الملف، نرجع قائمة فارغة (لكي لا يتعطل التطبيق)
      print('ملاحظة: لم يتم العثور على ملف المحتوى للغة $langCode في المستوى $level');
      return [];
    }
  }

  /// تحميل درس واحد بالتفصيل (للانتقال إلى صفحة التمارين)
  static Future<Lesson?> loadLesson(String langCode, String level, int lessonId) async {
    try {
      final List<Lesson> lessons = await loadAllLessons(langCode, level);
      return lessons.firstWhere(
        (l) => l.id == lessonId,
        orElse: () => throw Exception('الدرس غير موجود'),
      );
    } catch (e) {
      print('خطأ في تحميل الدرس: $e');
      return null;
    }
  }
}
