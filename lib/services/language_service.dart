import '../data/language_config.dart';
import '../data/course_data.dart';
import '../data/word_database.dart';

// خدمة اللغة - نقطة مركزية لجلب كل شيء يخص اللغة المختارة حاليًا
// بدل ما كل شاشة تستورد من data مباشرة، تمر عبر هذه الخدمة
class LanguageService {
  // جلب اسم وعلم اللغة الحالية
  static LanguageOption get currentLanguage => AppState.currentLanguage;

  // تغيير اللغة المختارة للتعلم
  static void setLearningLanguage(String languageCode) {
    AppState.currentLanguageCode = languageCode;
  }

  // جلب وحدات الدورة الخاصة باللغة الحالية
  static List<UnitData> getCourseUnits() {
    return courseDataByLanguage[AppState.currentLanguageCode] ?? [];
  }

  // جلب كلمات القاموس الخاصة باللغة الحالية
  static List<WordEntry> getVocabularyWords() {
    return wordDatabaseByLanguage[AppState.currentLanguageCode] ?? [];
  }

  // التحقق: هل يوجد محتوى فعلي جاهز لهذه اللغة؟
  static bool hasContent(String languageCode) {
    final units = courseDataByLanguage[languageCode];
    return units != null && units.isNotEmpty;
  }
}
