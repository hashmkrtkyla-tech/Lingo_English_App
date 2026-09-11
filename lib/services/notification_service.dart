// خدمة الإشعارات (Notification Service)
// حاليًا: هيكل جاهز بدون تفعيل فعلي
// لاحقًا: سيتم ربطه بمكتبة flutter_local_notifications في pubspec.yaml

class NotificationService {
  // رسائل تذكير متنوعة تظهر عشوائيًا - نفس فكرة دولينجو
  static const List<String> reminderMessages = [
    'حان وقت التدريب! لا تفقد سلسلتك 🔥',
    'صديقك القديم البومة يشتاق لك 🦉',
    'تعلّم 5 دقائق اليوم فقط وحافظ على تقدمك',
    '3 أيام مرت بدون تدريب... هيا نكمل!',
    'كلمة جديدة كل يوم = لغة كاملة بعد سنة 🌍',
  ];

  // تهيئة خدمة الإشعارات (يُستدعى مرة واحدة عند بدء التطبيق)
  static Future<void> initialize() async {
    // TODO: تهيئة flutter_local_notifications هنا
    // + طلب إذن الإشعارات صراحة (مطلوب في أندرويد 13 فما فوق)
  }

  // جدولة تذكير يومي في وقت محدد
  static Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    // TODO: استخدام zonedSchedule من flutter_local_notifications
    // لعرض إشعار يومي متكرر في الوقت المحدد
  }

  // إلغاء كل التذكيرات (مثلًا عند إكمال المستخدم لهدفه اليومي بالفعل)
  static Future<void> cancelAllReminders() async {
    // TODO: flutterLocalNotificationsPlugin.cancelAll()
  }

  // إرسال إشعار فوري تجريبي (مفيد للاختبار)
  static Future<void> showTestNotification() async {
    // TODO: عرض إشعار فوري باستخدام رسالة عشوائية من reminderMessages
  }
}
