import 'package:flutter/material.dart';

class LevelConfig {
  final String key, code, nameAr, descAr;
  final int number;
  final Color color, soft;
  final List<String> topics; // مفاتيح المواضيع
  const LevelConfig(this.key, this.code, this.nameAr, this.descAr, this.number,
      this.color, this.soft, this.topics);
}

const kLessonsPerLevel = 50; // ✏️ كانت 40

// اسم الموضوع بالعربية + بالإنجليزية (للعرض الاحتياطي)
const kTopicNames = <String, List<String>>{
  'greetings': ['التحيات والتعارف', 'Greetings & introductions'],
  'family': ['العائلة والأصدقاء', 'Family & friends'],
  'numbers': ['الأرقام والأوقات', 'Numbers & time'],
  'home': ['البيت والأشياء اليومية', 'Home & everyday things'],
  'food': ['الطعام والشراب', 'Food & drinks'],
  'verbs': ['الأفعال الأساسية', 'Essential verbs'],
  'city': ['المدينة والاتجاهات', 'The city & directions'],
  'day': ['يوم في حياتي', 'A day in my life'],
  'travel': ['السفر والمواصلات', 'Travel & transport'],
  'shopping': ['التسوق والأسعار', 'Shopping & prices'],
  'work': ['العمل والمهنة', 'Work & professions'],
  'weather': ['الطقس والفصول', 'Weather & seasons'],
  'opinions': ['التعبير عن الآراء', 'Expressing opinions'],
  'past': ['الماضي والذكريات', 'The past & memories'],
  'mastery': ['الإتقان اللغوي', 'Language mastery'],
  'rhetoric': ['الخطابة والإقناع', 'Rhetoric & persuasion'],
  'complex': ['النصوص المعقدة', 'Complex texts'],
};

const kLevels = <LevelConfig>[
  LevelConfig('a1', 'A1', 'مبتدئ', 'العبارات الأساسية', 1, Color(0xFF2563EB),
      Color(0xFFE8EFFD), ['greetings','family','numbers','home','food','verbs','city','day']),
  LevelConfig('a2', 'A2', 'أساسي', 'التواصل اليومي', 2, Color(0xFF0F9D8A),
      Color(0xFFE3F6F3), ['travel','shopping','work','weather','food','city','day','verbs']),
  LevelConfig('b1', 'B1', 'متوسط', 'محادثات بثقة', 3, Color(0xFFD97706),
      Color(0xFFFEF3DC), ['opinions','past','work','travel','day','city','shopping','weather']),
  LevelConfig('b2', 'B2', 'فوق المتوسط', 'نقاش وتعبير متقدم', 4, Color(0xFFDC5A44),
      Color(0xFFFDEEEA), ['opinions','work','past','travel','complex','day','city','shopping']),
  LevelConfig('c1', 'C1', 'متقدم', 'طلاقة واحترافية', 5, Color(0xFF7C5AC7),
      Color(0xFFF0EBFB), ['mastery','rhetoric','complex','opinions','work','past','travel','day']),
  LevelConfig('c2', 'C2', 'احتراف', 'إتقان كامل للغة', 6, Color(0xFFB45309),
      Color(0xFFFEF0DC), ['mastery','rhetoric','complex','opinions','work','past','travel','day']),
];
