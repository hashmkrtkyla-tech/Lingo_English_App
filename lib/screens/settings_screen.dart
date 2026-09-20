import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isPasswordVisible = false;
  bool _isLoading = true;

  // Controllers لجلب البيانات ديناميكياً
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // لغة التطبيق (لغة الأم)
  String _selectedNativeLanguage = "العربية";
  // لغة التعلم
  String _selectedLearningLanguage = "الإنجليزية";

  // قائمة شاملة بأهم لغات العالم
  final List<String> _allWorldLanguages = [
    "الأفريقانية", "الألبانية", "الأمهرية", "العربية", "الأرمنية", "الأذربيجانية",
    "الباسكية", "البيالروسية", "البنغالية", "البوسنية", "البلغارية", "البورمية",
    "الكاتالونية", "السيبيونية", "الصينية (المبسطة)", "الصينية (التقليدية)",
    "الكرواتية", "التشيكية", "الدانماركية", "الهولندية", "الإنجليزية", "الإستونية",
    "الفلبينية", "الفنلندية", "الفرنسية", "الجاليكية", "الجورجية", "الألمانية",
    "اليونانية", "الغوجاراتية", "الهيتية", "الهوسا", "العبرية", "الهندية",
    "المجرية", "الأيسلندية", "الإندونيسية", "الأيرلندية", "الإيطالية", "اليابانية",
    "الجاوية", "الكانادية", "الكازاخستانية", "الخميرية", "الروسية", "الكورية",
    "الكردية", "قيرغيزستان", "اللاوية", "اللاتفية", "الليتوانية", "المقدونية",
    "المالايالامية", "المالطية", "الماراثية", "المنغولية", "النيبالية", "النرويجية",
    "الأوكيتانية", "الباشتو", "الفارسية", "البولندية", "البرتغالية", "البنجابية",
    "الرومانية", "الصربية", "السنهالية", "السلوفاكية", "السلوفينية",
    "الصومالية", "الإسبانية", "السوندانية", "السواحيلية", "السويدية", "الطاجيكية",
    "التاميلية", "التتارية", "التيلجو", "التايلاندية", "التركية", "التركمانية",
    "الأوكرانية", "الأردية", "الأويغورية", "الأوزبكية", "الفيتنامية", "الويلزية",
    "اليوروبا", "الزولو", "الأمازيغية", "الكشميرية", "السندية",
    "البشتو", "البلوشية", "الأورومو", "التغرينية", "المالاجاشية",
    "السيشيلية", "الموريشيوسية", "الكريولية", "الاسبرانتو", "اللاتينية",
  ];

  // ✅ لغات التعلم الـ 15 فقط
  final List<String> _learningLanguages = [
    "الإنجليزية", "الإسبانية", "الفرنسية", "الألمانية", "الإيطالية",
    "البرتغالية", "الروسية", "الصينية", "اليابانية", "الكورية",
    "التركية", "الهندية", "العربية", "الهولندية", "السويدية"
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // دالة جلب بيانات المستخدم من Firebase
  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          setState(() {
            _nameController.text = data['name'] ?? "مستخدم جديد";
            _usernameController.text = data['username'] ?? "user_${user.uid.substring(0, 5)}";
            _phoneController.text = data['phone'] ?? "غير محدد";
            _emailController.text = user.email ?? "لا يوجد بريد";
            _selectedNativeLanguage = data['nativeLanguage'] ?? "العربية";
            _selectedLearningLanguage = data['learningLanguage'] ?? "الإنجليزية";
            _passwordController.text = "********";
            _isLoading = false;
          });
        } else {
          setState(() {
            _nameController.text = user.displayName ?? "مستخدم جديد";
            _usernameController.text = "user_${user.uid.substring(0, 5)}";
            _emailController.text = user.email ?? "لا يوجد بريد";
            _phoneController.text = "غير محدد";
            _isLoading = false;
          });
        }
      } catch (e) {
        debugPrint("خطأ في جلب البيانات: $e");
        setState(() => _isLoading = false);
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  // دالة تحديث البيانات في Firebase
  Future<void> _updateProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': _nameController.text.trim(),
        'username': _usernameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'nativeLanguage': _selectedNativeLanguage,
        'learningLanguage': _selectedLearningLanguage,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await user.updateDisplayName(_nameController.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("تم حفظ التعديلات بنجاح", style: GoogleFonts.cairo()),
            backgroundColor: AppColors.sage,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("حدث خطأ أثناء الحفظ", style: GoogleFonts.cairo()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showLanguageDialog({required bool isNative}) {
    List<String> currentList = isNative ? _allWorldLanguages : _learningLanguages;
    String currentValue = isNative ? _selectedNativeLanguage : _selectedLearningLanguage;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                isNative ? "حدد لغة التطبيق (لغة الأم)" : "حدد اللغة التي تريد تعلمها",
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: ListView.builder(
                  itemCount: currentList.length,
                  itemBuilder: (context, index) {
                    bool isSelected = currentList[index] == currentValue;
                    return RadioListTile<String>(
                      title: Text(currentList[index], style: GoogleFonts.cairo(color: AppColors.navy)),
                      value: currentList[index],
                      groupValue: currentValue,
                      activeColor: AppColors.lilac,
                      onChanged: (value) {
                        setStateDialog(() {
                          currentValue = value!;
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("إلغاء", style: GoogleFonts.cairo(color: AppColors.textGrey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lilac,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    setState(() {
                      if (isNative) {
                        _selectedNativeLanguage = currentValue;
                      } else {
                        _selectedLearningLanguage = currentValue;
                      }
                    });
                    Navigator.pop(context);
                    _updateProfile();
                  },
                  child: Text("حفظ", style: GoogleFonts.cairo(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.babyBlue,
        body: Center(child: CircularProgressIndicator(color: AppColors.lilac)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.babyBlue,
      appBar: AppBar(
        backgroundColor: AppColors.babyBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.navy),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("الإعدادات",
            style: GoogleFonts.cairo(color: AppColors.navy, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: AppColors.lilac),
            onPressed: _updateProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("المعلومات الشخصية",
                style: GoogleFonts.cairo(
                    color: AppColors.navy, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.babyBlue,
                          child: Icon(Icons.person, color: AppColors.navy, size: 35)),
                      const SizedBox(width: 10),
                      TextButton(
                          onPressed: () {},
                          child: Text("تغيير",
                              style: GoogleFonts.cairo(color: AppColors.lilac))),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildTextField("الاسم", _nameController),
                  _buildTextField("اسم المستخدم", _usernameController),
                  _buildPasswordField("كلمة المرور", _passwordController),
                  _buildTextField("البريد الإلكتروني", _emailController, readOnly: true),
                  _buildTextField("رقم الهاتف", _phoneController),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lilac,
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: _updateProfile,
                    child: Text("حفظ التعديلات",
                        style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text("إعدادات اللغات",
                style: GoogleFonts.cairo(
                    color: AppColors.navy, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text("لغة التطبيق (لغة الأم)",
                        style: GoogleFonts.cairo(
                            color: AppColors.navy, fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text(_selectedNativeLanguage,
                        style: GoogleFonts.cairo(color: AppColors.lilac, fontSize: 16)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textGrey),
                    onTap: () => _showLanguageDialog(isNative: true),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text("لغة التعلم",
                        style: GoogleFonts.cairo(
                            color: AppColors.navy, fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text(_selectedLearningLanguage,
                        style: GoogleFonts.cairo(color: AppColors.learningTeal, fontSize: 16)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textGrey),
                    onTap: () => _showLanguageDialog(isNative: false),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text("حسابات التواصل الاجتماعي للمالك",
                style: GoogleFonts.cairo(
                    color: AppColors.navy, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  _buildSocialLink("Instagram", "https://www.instagram.com/hshmkrtkyl"),
                  _buildSocialLink("TikTok", "https://www.tiktok.com/@hashmobs1tc"),
                  _buildSocialLink("Telegram", "https://t.me/Scientifl"),
                  _buildSocialLink("Facebook",
                      "https://www.facebook.com/profile.php?id=100079869207285"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  _buildActionRow("الشروط والأحكام", () {}),
                  const Divider(),
                  _buildActionRow("سياسة الخصوصية", () {}),
                  const Divider(),
                  _buildActionRow("اتصل بنا / راسلنا", () {}),
                  const Divider(),
                  _buildActionRow("مركز المساعدة", () {}),
                ],
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 0,
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: Text("تسجيل الخروج",
                  style: GoogleFonts.cairo(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              child: Text("حذف الحساب", style: GoogleFonts.cairo(color: AppColors.textGrey)),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        style: GoogleFonts.cairo(color: AppColors.navy),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.cairo(color: AppColors.textGrey),
          filled: true,
          fillColor: readOnly ? Colors.grey.shade100 : AppColors.babyBlue,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        obscureText: !_isPasswordVisible,
        style: GoogleFonts.cairo(color: AppColors.navy),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.cairo(color: AppColors.textGrey),
          filled: true,
          fillColor: AppColors.babyBlue,
          suffixIcon: IconButton(
            icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: AppColors.navy),
            onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildSocialLink(String title, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.cairo(color: AppColors.navy, fontWeight: FontWeight.bold)),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textGrey),
            onPressed: () async {
              final Uri uri = Uri.parse(url);
              if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                debugPrint("Could not launch $url");
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: GoogleFonts.cairo(color: AppColors.navy, fontWeight: FontWeight.w600)),
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textGrey),
          ],
        ),
      ),
    );
  }
}
