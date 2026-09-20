import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import 'screens/settings_screen.dart';
import 'screens/auth_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _bannerText = "احصل على حساب PRO";
  String _userName = "My Name Hashem";
  late Timer _timer;
  bool _isBannerPro = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _isBannerPro = !_isBannerPro;
          _bannerText = _isBannerPro ? "احصل على حساب PRO" : "تعلم الإنجليزية بشكل أسرع";
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _showEditNameDialog() {
    TextEditingController controller = TextEditingController(text: _userName);
    bool isChanged = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text("الاسم", style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("أدخل اسمك الأول", style: GoogleFonts.cairo(color: AppColors.textGrey, fontSize: 13)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: controller,
                    onChanged: (value) {
                      setStateDialog(() {
                        isChanged = value != _userName;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.babyBlue,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("إلغاء", style: GoogleFonts.cairo(color: AppColors.navy)),
                ),
                ElevatedButton(
                  onPressed: isChanged ? () {
                    setState(() {
                      _userName = controller.text;
                    });
                    Navigator.pop(context);
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isChanged ? AppColors.lilac : AppColors.babyBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text("حفظ", style: GoogleFonts.cairo(color: isChanged ? Colors.white : AppColors.navy)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _shareApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("تم نسخ رابط الدعوة!", style: GoogleFonts.cairo()),
        backgroundColor: AppColors.sage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.babyBlue,
      appBar: AppBar(
        backgroundColor: AppColors.babyBlue,
        elevation: 0,
        title: Row(
          children: [
            Text("Brilliant", style: GoogleFonts.cairo(color: AppColors.lilac, fontWeight: FontWeight.bold, fontSize: 22)),
            const SizedBox(width: 10),
            Text("الملف الشخصي", style: GoogleFonts.cairo(color: AppColors.navy, fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.navy, size: 28),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {},
              child: const CircleAvatar(
                radius: 45,
                backgroundColor: AppColors.white,
                child: Icon(Icons.person, size: 50, color: AppColors.lilac),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_userName, style: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.navy)),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: _showEditNameDialog,
                  child: const Icon(Icons.edit, size: 18, color: AppColors.textGrey),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // بطاقة المستوى والماس
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem("المستوى", "1", Icons.star, AppColors.sage),
                  Container(height: 30, width: 1, color: Colors.grey.shade300),
                  _buildStatItem("الماس", "100", Icons.diamond, AppColors.lilac),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // زر إنشاء حساب (مرتبط بـ AuthScreen)
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthScreen()));
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("إنشاء حساب", style: GoogleFonts.cairo(color: AppColors.navy, fontWeight: FontWeight.bold)),
                        Text("احفظ تقدمك", style: GoogleFonts.cairo(color: AppColors.textGrey, fontSize: 12)),
                      ],
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textGrey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),

            // إعلان PRO
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.learningTeal, AppColors.lilac]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("احصل على حساب PRO", style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("تعلم الإنجليزية بشكل أسرع", style: GoogleFonts.cairo(color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.workspace_premium, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // السلسلة اليومية
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  Text("السلسلة اليومية", style: GoogleFonts.cairo(color: AppColors.navy, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStreakItem("1", "الحالي", Icons.local_fire_department, AppColors.proOrange),
                      _buildStreakItem("2", "الأفضل", Icons.local_fire_department, AppColors.proOrange),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text("آخر 7 أيام", style: GoogleFonts.cairo(color: AppColors.textGrey, fontSize: 12)),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(7, (index) {
                      bool isActive = index == 5;
                      return Column(
                        children: [
                          Icon(Icons.local_fire_department, color: isActive ? AppColors.proOrange : Colors.grey.shade300, size: 20),
                          Text(["الاثنين", "الثلاثاء", "الأربعاء", "الخميس", "الجمعة", "السبت", "الأحد"][index], 
                              style: GoogleFonts.cairo(fontSize: 9, color: isActive ? AppColors.navy : AppColors.textGrey)),
                          Text("${14 + index}", style: GoogleFonts.cairo(fontSize: 10, color: isActive ? AppColors.navy : AppColors.textGrey)),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // دعوة الأصدقاء
            GestureDetector(
              onTap: _shareApp,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.sage, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.share, color: AppColors.sage),
                        const SizedBox(width: 10),
                        Text("دعوة أصدقاء", style: GoogleFonts.cairo(color: AppColors.navy, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Text("شارك الرابط", style: GoogleFonts.cairo(color: AppColors.textGrey, fontSize: 12)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),

            // لوحة الصدارة
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text("لوحة صدارة Brilliant", style: GoogleFonts.cairo(color: AppColors.navy, fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("تعلم وتدرب لتتقدم وتتفوق على الآخرين", style: GoogleFonts.cairo(color: AppColors.textGrey, fontSize: 12)),
                  const SizedBox(height: 10),
                  _buildLeaderboardItem("1", "Felix", "1", "2", "162"),
                  _buildLeaderboardItem("2", "Yasmin", "1", "2", "148"),
                  _buildLeaderboardItem("3", "Yasmin", "1", "1", "115"),
                  _buildLeaderboardItem("4", "My Name ...", "1", "1", "100", isUser: true),
                  _buildLeaderboardItem("5", "Mateo", "2", "1", "100"),
                  _buildLeaderboardItem("6", "Mila", "2", "1", "100"),
                  _buildLeaderboardItem("7", "Mila", "1", "1", "100"),
                  _buildLeaderboardItem("8", "Mila", "3", "1", "100"),
                  _buildLeaderboardItem("9", "Sofia", "1", "1", "100"),
                  _buildLeaderboardItem("10", "Mateo", "3", "1", "100"),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.cairo(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
        Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 4),
            Text(value, style: GoogleFonts.cairo(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildStreakItem(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        Text(value, style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textGrey)),
      ],
    );
  }

  Widget _buildLeaderboardItem(String rank, String name, String fire, String stars, String diamonds, {bool isUser = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: isUser ? AppColors.babyBlue : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(width: 20, child: Text(rank, style: GoogleFonts.cairo(color: AppColors.textGrey, fontWeight: FontWeight.bold))),
          const CircleAvatar(radius: 15, backgroundColor: AppColors.white, child: Icon(Icons.person, size: 20, color: AppColors.navy)),
          const SizedBox(width: 10),
          Expanded(child: Text(name, style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: AppColors.navy))),
          Row(
            children: [
              const Icon(Icons.local_fire_department, color: AppColors.proOrange, size: 14),
              Text(fire, style: GoogleFonts.cairo(fontSize: 12, color: AppColors.navy)),
              const SizedBox(width: 5),
              const Icon(Icons.star, color: AppColors.sage, size: 14),
              Text(stars, style: GoogleFonts.cairo(fontSize: 12, color: AppColors.navy)),
              const SizedBox(width: 5),
              const Icon(Icons.diamond, color: AppColors.lilac, size: 14),
              Text(diamonds, style: GoogleFonts.cairo(fontSize: 12, color: AppColors.navy)),
            ],
          )
        ],
      ),
    );
  }
}
