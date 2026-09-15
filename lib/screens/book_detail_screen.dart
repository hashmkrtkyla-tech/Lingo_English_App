import 'package:flutter/material.dart';
import '../models/book_model.dart';
import 'book_reader_screen.dart'; // سننشئ هذه الشاشة في الخطوة القادمة

class BookDetailScreen extends StatelessWidget {
  final BookModel book;

  const BookDetailScreen({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          children: [
            // غلاف الكتاب
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  book.coverImage,
                  height: 260,
                  width: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(height: 260, width: 180, color: Colors.grey[300]),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // عنوان الكتاب والكاتب
            Text(
              book.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              book.author,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),

            // أزرار التفاعل (مفضلة ومشاركة)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.blue, size: 28),
                  onPressed: () {},
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.blue, size: 28),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),

            // شريط المعلومات الفريدة والتفاصيل
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: const [
                    Icon(Icons.star, size: 20, color: Colors.black87),
                    SizedBox(width: 4),
                    Text('1435 كلمات فريدة', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.signal_cellular_alt, size: 20, color: Colors.black87),
                    const SizedBox(width: 4),
                    Text(book.level, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
                Row(
                  children: const [
                    Icon(Icons.access_time, size: 20, color: Colors.black87),
                    SizedBox(width: 4),
                    Text('23:59', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // زر فتح الاشتراك إذا كان الكتاب بريميوم
            if (book.isPremium)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    // TODO: فتح شاشة الاشتراك Subscription Screen
                  },
                  icon: const Icon(Icons.lock, color: Colors.white),
                  label: const Text(
                    'افتح الآن ->',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

            // أزرار اقرأ واستمع
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookReaderScreen(book: book, isAudioMode: false),
                        ),
                      );
                    },
                    icon: const Icon(Icons.menu_book, color: Colors.white),
                    label: const Text('اقرأ', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookReaderScreen(book: book, isAudioMode: true),
                        ),
                      );
                    },
                    icon: const Icon(Icons.headphones, color: Colors.white),
                    label: const Text('استمع', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
