import 'package:flutter/material.dart';

/// ألوان صفحة التدريبات — مستوحاة من الأزرق السماوي والأخضر الفاتح والليلك
class PracticeColors {
  PracticeColors._();

  // الهوية الأساسية — أزرق سماوي فاتح (كغلاف الملف الشخصي)
  static const Color primary = Color(0xFF6EC6E8);
  static const Color primaryDark = Color(0xFF4BA3C7);

  // حالات الإجابة
  static const Color correct = Color(0xFF9EE6B8); // أخضر فاتح جداً - إجابة صحيحة
  static const Color correctBg = Color(0xFFEFFCF3);
  static const Color correctText = Color(0xFF2E9E56); // نص أغمق قليلاً لوضوح القراءة
  static const Color wrong = Color(0xFFE88C8C); // أحمر هادئ - إجابة خاطئة
  static const Color wrongBg = Color(0xFFFDEDED);

  // مستويات الصعوبة
  static const Color easyTier = Color(0xFF6EC6E8); // أزرق سماوي - بدائي
  static const Color mediumTier = Color(0xFF9EE6B8); // أخضر فاتح - متوسط
  static const Color hardTier = Color(0xFFB39DDB); // ليلك - صعب

  // القواعد (مقفلة/قيد التنفيذ)
  static const Color grammarLocked = Color(0xFFB39DDB); // ليلك
  static const Color lockedBg = Color(0xFFF3EFFB);

  // شاشة التحدث (خلفية داكنة تبقى كما هي لوضوح التباين مع الأزرار الملوّنة)
  static const Color speakingBg = Color(0xFF14141F);
  static const Color speakingCard = Color(0xFF1E1E2E);
  static const Color recordButtonStart = Color(0xFF9EE6B8);
  static const Color recordButtonEnd = Color(0xFF6EC6E8);

  // عامة
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF8A8A9E);
  static const Color background = Color(0xFFF7FBFD);
  static const Color cardBackground = Colors.white;
  static const Color divider = Color(0xFFE7EEF3);

  // الإعلانات/الاشتراك
  static const Color premiumGold = Color(0xFFFFC24B);
}
