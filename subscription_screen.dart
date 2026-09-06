import 'package:flutter/material.dart';

// ==========================================
// 6. شاشة الاشتراك والدفع الشاملة (Subscription & Payment)
// ==========================================
class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int _selectedPlan = 1; // 0 للشهري، 1 للسنوي

  // الأسعار (تستطيع تعديلها بنفسك)
  final String monthlyPriceSDG = "15,000 جنيه / شهرياً";
  final String yearlyPriceSDG = "120,000 جنيه / سنوياً";
  final String monthlyPriceUSD = "\$4.99 / شهرياً";
  final String yearlyPriceUSD = "\$39.99 / سنوياً";

  // بيانات الاستلام (تعدلها بنفسك)
  final String bankOfKhartoumAcc = "ضع_رقم_حسابك_هنا"; 
  final String omdurmanBankAcc = "ضع_رقم_حسابك_هنا"; 
  final String binancePayId = "ضع_رقم_باينانس_هنا"; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'اشتراك ENGO PRO',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بنر ترقية الحساب
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C42F5), Color(0xFF8E66FF)],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ترقية الحساب إلى PRO',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'وصول كامل لكافة الكورس والكتب والتمارين بدون حدود',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.stars_rounded, color: Colors.amber, size: 48),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'اختر خطة الاشتراك:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            _buildPlanOption(0, 'الاشتراك الشهري', monthlyPriceSDG, monthlyPriceUSD),
            const SizedBox(height: 8),
            _buildPlanOption(1, 'الاشتراك السنوي (توفير أكبر 🔥)', yearlyPriceSDG, yearlyPriceUSD),

            const SizedBox(height: 24),
            const Text(
              'اختر طريقة الدفع المناسبة لك:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // 1. بنك الخرطوم (بنكك)
            _buildPaymentMethodTile(
              title: 'تطبيق بنكك (بنك الخرطوم)',
              subtitle: 'تحويل مباشر عبر رقم الحساب',
              icon: Icons.account_balance,
              color: Colors.green.shade700,
              onTap: () => _showBankDialog('بنك الخرطوم (بنكك)', bankOfKhartoumAcc),
            ),

            // 2. بنك أمدرمان الوطني
            _buildPaymentMethodTile(
              title: 'بنك أمدرمان الوطني',
              subtitle: 'تحويل عبر الحساب أو أوكاش',
              icon: Icons.account_balance_wallet,
              color: Colors.blue.shade800,
              onTap: () => _showBankDialog('بنك أمدرمان الوطني', omdurmanBankAcc),
            ),

            // 3. Binance Pay
            _buildPaymentMethodTile(
              title: 'Binance Pay / العملات الرقمية',
              subtitle: 'تحويل USDT أو عبر ID باينانس',
              icon: Icons.currency_bitcoin,
              color: Colors.amber.shade800,
              onTap: () => _showBinanceDialog(),
            ),

            // 4. البطاقات العالمية وباي بال
            _buildPaymentMethodTile(
              title: 'الفيزا، ماستر كارد، وباي بال',
              subtitle: 'الدفع الإلكتروني الدولي',
              icon: Icons.credit_card,
              color: Colors.purple,
              onTap: () => _showInternationalDialog(),
            ),

            // 5. مشاهدة إعلان كبديل مجاني
            _buildPaymentMethodTile(
              title: 'شاهد إعلانًا واكسب ماسات مجانية',
              subtitle: 'احصل على 50 ماسة بلمسة واحدة',
              icon: Icons.play_circle_fill,
              color: Colors.deepOrange,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('جاري فتح الإعلان ورصد المكافأة...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanOption(int index, String title, String sdgPrice, String usdPrice) {
    bool isSelected = _selectedPlan == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = index),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? const Color(0xFF6C42F5) : Colors.grey.shade200, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Radio(
              value: index,
              groupValue: _selectedPlan,
              activeColor: const Color(0xFF6C42F5),
              onChanged: (val) => setState(() => _selectedPlan = val as int),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text('$sdgPrice  |  $usdPrice', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      ),
    );
  }

  void _showBankDialog(String bankName, String accNumber) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('الدفع عبر $bankName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('قم بتحويل المبلغ إلى رقم الحساب التالي:'),
            const SizedBox(height: 8),
            SelectableText(accNumber, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(labelText: 'رقم الإشعار / التحويل', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم استلام إشعارك وسيتم تفعيل الحساب فوراً!')));
            },
            child: const Text('تأكيد التحويل'),
          ),
        ],
      ),
    );
  }

  void _showBinanceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('الدفع عبر Binance Pay'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Binance Pay ID الخاص بنا:'),
            SelectableText(binancePayId, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(labelText: 'أدخل رقم العملية TxID', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('جاري التأكد من تحويل باينانس...')));
            },
            child: const Text('إرسال وتأكيد'),
          ),
        ],
      ),
    );
  }

  void _showInternationalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('الفيزا، ماستر كارد وباي بال'),
        content: const Text('يمكنك الدفع عبر رابط الباي بال أو البطاقات العالمية المباشرة. اضغط على استمرار للتحويل إلى بوابات الدفع الآمنة.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('جاري الانتقال لبوابة الدفع الإلكترونية...')));
            },
            child: const Text('استمرار للدفع'),
          ),
        ],
      ),
    );
  }
}
