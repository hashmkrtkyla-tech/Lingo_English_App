// نموذج بيانات المستخدم - يمثل حساب المستخدم داخل التطبيق
class UserModel {
  final String uid;              // معرّف فريد للمستخدم (يأتي من Firebase لاحقًا)
  final String name;             // اسم المستخدم
  final String email;            // البريد الإلكتروني
  final String interfaceLanguage; // لغة واجهة التطبيق (مثلاً: ar, en)
  final String learningLanguage;  // اللغة التي يتعلمها حاليًا (مثلاً: en, fr)
  final int xp;                   // مجموع نقاط الخبرة
  final int currentStreak;        // السلسلة اليومية الحالية
  final int bestStreak;           // أفضل سلسلة حققها
  final int diamonds;             // رصيد الماس
  final List<String> completedLessonIds; // معرّفات الدروس المكتملة

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.interfaceLanguage = 'ar',
    this.learningLanguage = 'en',
    this.xp = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.diamonds = 100,
    this.completedLessonIds = const [],
  });

  // تحويل من/إلى Map - لتخزين بيانات المستخدم في Firebase لاحقًا
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      interfaceLanguage: map['interfaceLanguage'] ?? 'ar',
      learningLanguage: map['learningLanguage'] ?? 'en',
      xp: map['xp'] ?? 0,
      currentStreak: map['currentStreak'] ?? 0,
      bestStreak: map['bestStreak'] ?? 0,
      diamonds: map['diamonds'] ?? 100,
      completedLessonIds: List<String>.from(map['completedLessonIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'interfaceLanguage': interfaceLanguage,
      'learningLanguage': learningLanguage,
      'xp': xp,
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'diamonds': diamonds,
      'completedLessonIds': completedLessonIds,
    };
  }

  // نسخة معدّلة من نفس المستخدم (مفيدة عند تحديث نقطة بيانات واحدة فقط)
  UserModel copyWith({
    int? xp,
    int? currentStreak,
    int? bestStreak,
    int? diamonds,
    String? learningLanguage,
    List<String>? completedLessonIds,
  }) {
    return UserModel(
      uid: uid,
      name: name,
      email: email,
      interfaceLanguage: interfaceLanguage,
      learningLanguage: learningLanguage ?? this.learningLanguage,
      xp: xp ?? this.xp,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      diamonds: diamonds ?? this.diamonds,
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
    );
  }
}
