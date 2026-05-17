import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/library_provider.dart';
import '../utils/constants.dart';
import '../widgets/book_card.dart';
import '../widgets/error_message.dart';
import './book_detail_screen.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryProvider>(
      builder: (context, provider, child) {
        if (provider.savedBooks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.library_books_outlined,
                  size: 100,
                  color: AppColors.primary.withOpacity(0.3),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your catalog is empty',
                  style: AppTextStyles.headingMedium,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Search for books and save them to your catalog,\nor add a custom book using the + button.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.search),
                  label: const Text('Search Books'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // BOOKS LIST
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: provider.savedBooks.length,
                itemBuilder: (context, index) {
                  final book = provider.savedBooks[index];
                  return BookCard(
                    book: book,
                    showSaveButton: false,
                    showDeleteButton: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailScreen(book: book),
                        ),
                      );
                    },
                    onDelete: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Remove Book'),
                            content: Text('Remove "${book.title}" from your catalog?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  provider.deleteBook(book.id);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('"${book.title}" removed from catalog'),
                                    ),
                                  );
                                },
                                child: const Text('Remove'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
