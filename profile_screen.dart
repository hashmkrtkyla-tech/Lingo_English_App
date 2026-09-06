import 'package:flutter/material.dart';

// ==========================================
// 1. شاشة الملف الشخصي (Profile Screen)
// ==========================================
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const Text(
              'الملف الشخصي ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'ENGO',
              style: TextStyle(
                color: Colors.purple.shade700,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: IconButton(
              icon: const Icon(Icons.settings_outlined, color: Colors.redAccent),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Directionality(
                      textDirection: TextDirection.rtl,
                      child: SettingsScreen(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 100),
        child: Column(
          children: [
            // صورة الملف الشخصي والاسم
            const Center(
              child: CircleAvatar(
                radius: 45,
                backgroundColor: Color(0xFFE3F2FD),
                child: Icon(Icons.person, size: 55, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'My Name Hashem',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.edit_outlined, size: 18, color: Colors.grey.shade400),
              ],
            ),
            const SizedBox(height: 16),

            // كارت الإحصائيات (الماس والمستوى)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  // المستوى
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'المستوى',
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.stars, color: Colors.green, size: 22),
                            SizedBox(width: 6),
                            Text(
                              '1',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: 0.3,
                            backgroundColor: Colors.grey.shade200,
                            color: Colors.greenAccent,
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 1,
                    color: Colors.grey.shade200,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  // الماس
                  const Expanded(
                    child: Column(
                      children: [
                        Text(
                          'الماس',
                          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.diamond, color: Colors.deepPurpleAccent, size: 22),
                            SizedBox(width: 6),
                            Text(
                              '100',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // بنر حساب PRO
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF5252), Color(0xFFFF7A00)],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'احصل على حساب PRO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'تعلّم الإنجليزية بشكل أسرع',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.crown_rounded, color: Colors.orange, size: 30),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // بنر إنشاء حساب
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'إنشاء حساب',
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'احفظ تقدمك',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward_rounded, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // قسم السلسلة اليومية
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'السلسلة اليومية',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.local_fire_department, color: Colors.orange, size: 28),
                              Text('1', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange)),
                            ],
                          ),
                          Text('الأفضل', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.local_fire_department, color: Colors.orange, size: 28),
                              Text('1', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange)),
                            ],
                          ),
                          Text('الحالي', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text('آخر 7 أيام', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDayItem('الخميس', '03', false),
                      _buildDayItem('الأربعاء', '02', true),
                      _buildDayItem('الثلاثاء', '01', false),
                      _buildDayItem('الاثنين', '31', false),
                      _buildDayItem('الأحد', '30', false),
                      _buildDayItem('السبت', '29', false),
                      _buildDayItem('الجمعة', '28', false),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // قسم لوحة الصدارة ENGO
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    'لوحة صدارة ENGO',
                    style: TextStyle(
                      color: Colors.purple.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'احصل على المزيد من الماس لتتقدم على الآخرين',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  _buildLeaderboardRow('1', 'Antonio', '2', '2', '162', Colors.orange, false),
                  _buildLeaderboardRow('2', 'Yasmin', '2', '2', '148', Colors.pinkAccent, false),
                  _buildLeaderboardRow('3', 'Victoria', '3', '1', '115', Colors.brown, false),
                  _buildLeaderboardRow('4', 'My Name ...', '1', '1', '100', Colors.blue, true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildDayItem(String day, String num, bool isToday) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: isToday ? Colors.orange.shade50 : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.local_fire_department,
            color: isToday ? Colors.orange : Colors.grey.shade300,
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            day,
            style: TextStyle(
              fontSize: 10,
              color: isToday ? Colors.orange : Colors.grey,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            num,
            style: TextStyle(
              fontSize: 11,
              color: isToday ? Colors.orange : Colors.grey,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildLeaderboardRow(
    String rank,
    String name,
    String fire,
    String star,
    String diamond,
    Color avatarColor,
    bool isCurrentUser,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.purple.shade50 : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            rank,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isCurrentUser ? Colors.purple : Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 18,
            backgroundColor: avatarColor.withOpacity(0.2),
            child: Icon(Icons.person, color: avatarColor, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Row(
            children: [
              const Icon(Icons.local_fire_department, color: Colors.orange, size: 16),
              Text(' $fire ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const Icon(Icons.stars, color: Colors.green, size: 16),
              Text(' $star ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const Icon(Icons.diamond, color: Colors.purple, size: 16),
              Text(' $diamond', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 2. شاشة الإعدادات (Settings Screen)
// ==========================================
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          'الإعدادات',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingsTile('الاسم', value: 'My Name Hash...'),
          _buildSettingsTile('اللغة الأم', value: 'عربي'),
          _buildSettingsTile('المستوى', value: 'A1'),
          _buildSettingsTile('الاشتراك', value: 'غير نشط'),
          const SizedBox(height: 10),
          _buildSettingsTile('Instagram', value: '@engo.app'),
          _buildSettingsTile('TikTok', value: '@engo.app'),
          _buildSettingsTile('Facebook'),
          _buildSettingsTile('Telegram'),
          const SizedBox(height: 10),
          _buildSettingsTile('الشروط والأحكام'),
          _buildSettingsTile('سياسة الخصوصية'),
          _buildSettingsTile('اتصل بنا', value: 'support@engo...'),
          const SizedBox(height: 10),
          _buildSettingsTile('تسجيل الدخول'),
          _buildSettingsTile('إنشاء حساب'),
          _buildSettingsTile('حذف الحساب', isDanger: true),
        ],
      ),
    );
  }

  static Widget _buildSettingsTile(String title, {String? value, bool isDanger = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDanger ? Colors.red : Colors.black87,
            ),
          ),
          Row(
            children: [
              if (value != null)
                Text(
                  value,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              const SizedBox(width: 8),
              if (!isDanger)
                const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }
}
