import 'package:flutter/material.dart';

// استيراد الشاشات الخمس من مجلد المشروع
import 'course_screen.dart';
import 'vocabulary_screen.dart';
import 'books_screen.dart';
import 'training_screen.dart';
import 'profile_screen.dart';

void main() {
  runApp(const EngoApp());
}

class EngoApp extends StatefulWidget {
  const EngoApp({super.key});

  @override
  State<EngoApp> createState() => _EngoAppState();
}

class _EngoAppState extends State<EngoApp> {
  int _selectedIndex = 0;

  // قائمة الشاشات الخمس بالترتيب
  final List<Widget> _screens = const [
    CourseScreen(),
    VocabularyScreen(),
    BooksScreen(),
    TrainingScreen(),
    ProfileScreen(),
  ];

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
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
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
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: const Color(0xFF6C42F5),
              unselectedItemColor: Colors.grey.shade400,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
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
      ),
    );
  }
}
