import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ➕ جديد: حفظ اختيارات المستخدم

import 'screens/course_screen.dart'; // ✏️ تغيّر المسار: الدورة الجديدة داخل screens
import 'vocabulary_screen.dart';
import 'books_screen.dart';
import 'training_screen.dart';
import 'profile_screen.dart';
import 'screens/splash_screen.dart';
import 'utils/app_colors.dart'; // ✅ استيراد الألوان الجديدة

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // ✅ تهيئة Firebase
  await AppState.load(); // ➕ جديد: تحميل اللغة والهدف المحفوظين
  runApp(const BrilliantApp());
}

/// حالة عامة بسيطة يمكن لأي شاشة الوصول إليها
/// (لغة التعلم الحالية للمستخدم + رصيد الماس)
class AppState {
  static String currentLanguageCode = 'en';
  static int diamonds = 100;

  // ➕ جديد
  static String nativeLanguageCode = 'ar'; // لغة المستخدم الأم (تظهر بها المعاني والرسائل)
  static String goal = 'study'; // study | work | friends | travel | fun

  /// تحميل الاختيارات المحفوظة عند فتح التطبيق
  static Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    currentLanguageCode = p.getString('learn_lang') ?? currentLanguageCode;
    nativeLanguageCode = p.getString('native_lang') ?? nativeLanguageCode;
    goal = p.getString('goal') ?? goal;
  }

  /// حفظ الاختيارات (استدعِها بعد أي تغيير)
  static Future<void> save() async {
    final p = await SharedPreferences.getInstance();
    await p.setString('learn_lang', currentLanguageCode);
    await p.setString('native_lang', nativeLanguageCode);
    await p.setString('goal', goal);
  }
}

class BrilliantApp extends StatelessWidget {
  const BrilliantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brilliant', // ✅ الاسم الجديد
      theme: ThemeData(
        textTheme: GoogleFonts.cairoTextTheme(), // ✅ استخدام خط Cairo
        scaffoldBackgroundColor: AppColors.babyBlue, // ✅ الخلفية الجديدة
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.lilac, // ✅ اللون الأساسي الجديد
          primary: AppColors.lilac,
          secondary: AppColors.learningTeal,
        ),
        useMaterial3: true,
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: SplashScreen(),
      ),
    );
  }
}

// شاشة التنقل الرئيسية (التبويبات الخمسة) - تظهر بعد اختيار اللغة
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    CourseScreen(),
    VocabularyScreen(),
    BooksScreen(),
    TrainingScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: IndexedStack(index: _selectedIndex, children: _screens),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.white,
            selectedItemColor: AppColors.lilac, // ✅ اللون الجديد
            unselectedItemColor: Colors.grey.shade400,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 10),
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.school_outlined),
                activeIcon: Icon(Icons.school),
                label: 'الدورة',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.style_outlined),
                activeIcon: Icon(Icons.style),
                label: 'المفردات',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book_outlined),
                activeIcon: Icon(Icons.menu_book),
                label: 'الكتب',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.fitness_center_outlined),
                activeIcon: Icon(Icons.fitness_center),
                label: 'التمارين',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'حسابي',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
