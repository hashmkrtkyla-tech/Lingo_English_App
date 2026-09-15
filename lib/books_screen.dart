import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/book_model.dart';
import 'widgets/book_card.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({Key? key}) : super(key: key);

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  Map<String, List<BookModel>> groupedBooks = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBooksData();
  }

  Future<void> loadBooksData() async {
    try {
      final String response = await rootBundle.loadString('assets/books/books_index.json');
      final List<dynamic> data = json.decode(response);
      List<BookModel> books = data.map((json) => BookModel.fromJson(json)).toList();

      Map<String, List<BookModel>> tempGrouped = {};
      for (var book in books) {
        if (!tempGrouped.containsKey(book.level)) {
          tempGrouped[book.level] = [];
        }
        tempGrouped[book.level]!.add(book);
      }

      setState(() {
        groupedBooks = tempGrouped;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('الكتب الصوتية والمقروءة', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : groupedBooks.isEmpty
              ? const Center(child: Text('لا توجد كتب متاحة حالياً'))
              : ListView(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  children: groupedBooks.keys.map((level) {
                    final levelBooks = groupedBooks[level]!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'مستوى: $level',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // TODO: Navigate to Grid View for all books in this level
                                },
                                child: const Text('شاهد الكل'),
                              ),
                            ],
                          ),
                        ),
                        // Horizontal Books Scroll
                        SizedBox(
                          height: 230,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(left: 16),
                            itemCount: levelBooks.length,
                            itemBuilder: (context, index) {
                              final book = levelBooks[index];
                              return BookCard(
                                book: book,
                                onTap: () {
                                  // TODO: Navigate to Book Details Screen
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
                ),
    );
  }
}
