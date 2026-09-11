import 'package:flutter/material.dart';

import 'course_screen.dart';
import 'vocabulary_screen.dart';
import 'books_screen.dart';
import 'training_screen.dart';
import 'profile_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const EngoApp());
}

class EngoApp extends StatelessWidget {
  const EngoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Engo Clone',
      theme: ThemeData(
        fontFamily: 'Cairo',
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C42F5)),
        useMaterial3: true,
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: SplashScreen(), // التطبيق يبدأ الآن من شاشة البداية بدل التبويبات مباشرة
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
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF6C42F5),
            unselectedItemColor: Colors.grey.shade400,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            unselectedLabelStyle: const TextStyle(fontSize: 10),
            elevation: 0,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.school_outlined), activeIcon: Icon(Icons.school), label: 'الدورة'),
              BottomNavigationBarItem(icon: Icon(Icons.style_outlined), activeIcon: Icon(Icons.style), label: 'المفردات'),
              BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), activeIcon: Icon(Icons.menu_book), label: 'الكتب'),
              BottomNavigationBarItem(icon: Icon(Icons.fitness_center_outlined), activeIcon: Icon(Icons.fitness_center), label: 'التمارين'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'حسابي'),
            ],
          ),
        ),
      ),
    );
  }
}
