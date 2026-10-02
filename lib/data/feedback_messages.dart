/// كل نصوص واجهة الدرس بلغة المستخدم الأم + جمل التحفيز.
/// لإضافة لغة أم جديدة أضف UiText جديداً في kUi.
/// عدّل قوائم praise و retryMsgs بالجمل التي سترسلها أنت، وسيدور التطبيق عليها بالترتيب.
class UiText {
  final String check,
      next,
      retryBtn,
      meaning,
      skipListen,
      skipSpeak,
      tapSpeak,
      listening,
      typeHere,
      exitTitle,
      exitBody,
      exitStay,
      exitLeave,
      micUnavailable,
      comboSuffix;
  final Map<String, String> titles;
  final List<String> praise, retryMsgs;

  const UiText({
    required this.check,
    required this.next,
    required this.retryBtn,
    required this.meaning,
    required this.skipListen,
    required this.skipSpeak,
    required this.tapSpeak,
    required this.listening,
    required this.typeHere,
    required this.exitTitle,
    required this.exitBody,
    required this.exitStay,
    required this.exitLeave,
    required this.micUnavailable,
    required this.comboSuffix,
    required this.titles,
    required this.praise,
    required this.retryMsgs,
  });
}

const UiText _ar = UiText(
  check: 'هيا نرى',
  next: 'رائع لنكمل',
  retryBtn: 'محاولة أخرى',
  meaning: 'تعني:',
  skipListen: 'لا أستطيع الاستماع الآن',
  skipSpeak: 'لا أستطيع التحدث الآن',
  tapSpeak: 'اضغط للتحدث',
  listening: 'أستمع إليك...',
  typeHere: 'اكتب هنا',
  exitTitle: 'هل تريد الخروج؟',
  exitBody: 'سيضيع تقدمك في هذا الدرس.',
  exitStay: 'أكمل الدرس',
  exitLeave: 'خروج',
  micUnavailable: 'التعرف على الصوت غير متاح، تأكد من إذن الميكروفون',
  comboSuffix: 'على التوالي',
  titles: {
    'choice': 'اختر الإجابة الصحيحة',
    'meaning': 'ما معنى هذه الكلمة؟',
    'build': 'ترجم هذه الجملة',
    'buildAudio': 'أدخل ما تسمع',
    'fill': 'أكمل الجملة',
    'listenpick': 'استمع للتعرف على الكلمة الناقصة',
    'typeword': 'اكتب الكلمة الناقصة',
    'speak': 'انطق هذه الجملة',
    'match': 'اضغط على الأزواج المتطابقة',
  },
  // جمل الإجابة الصحيحة (مؤقتة، استبدلها بجمل المستخدم)
  praise: [
    'إجابة ممتازة!',
    'مذهل، استمر!',
    'أبدعت، أنت مذهل!',
    'رائع جداً!',
    'أحسنت عملاً!',
    'صحيح، أنت تتقدم بسرعة!',
  ],
  // جمل الإجابة الخاطئة (مؤقتة)
  retryMsgs: [
    'لا بأس، حاول مرة أخرى',
    'محاولة أخرى، أنت تستطيع!',
    'اقتربت، حاول مجدداً',
  ],
);

const Map<String, UiText> kUi = {'ar': _ar};

UiText uiFor(String nativeLang) => kUi[nativeLang] ?? _ar;
