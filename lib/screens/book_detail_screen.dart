import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/library_provider.dart';
import '../models/book.dart';
import '../utils/constants.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;

  const BookDetailScreen({
    super.key,
    required this.book,
  });

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late TextEditingController _noteController;
  late Book _book;
  bool _isEditing = false;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _book = widget.book;
    _noteController = TextEditingController(text: _book.personalNote);
    _isSaved = context.read<LibraryProvider>().savedBooks.any((b) => b.id == _book.id);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _toggleSave() {
    final provider = context.read<LibraryProvider>();
    if (_isSaved) {
      provider.deleteBook(_book.id);
      setState(() {
        _isSaved = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removed from catalog')),
      );
    } else {
      provider.addBook(_book);
      setState(() {
        _isSaved = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"${_book.title}" saved to catalog!')),
      );
    }
  }

  void _saveNote() {
    final note = _noteController.text.trim();
    context.read<LibraryProvider>().updateBookNote(_book.id, note);
    setState(() {
      _book = _book.copyWith(personalNote: note);
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note updated successfully!')),
    );
  }

  void _deleteBook() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Book'),
        content: Text('Remove "${_book.title}" from your catalog?'),
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
              context.read<LibraryProvider>().deleteBook(_book.id);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('"${_book.title}" removed from catalog')),
              );
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Book Details', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(_isSaved ? Icons.bookmark : Icons.bookmark_border),
            color: _isSaved ? AppColors.secondary : Colors.white,
            onPressed: _toggleSave,
            tooltip: _isSaved ? 'Remove from catalog' : 'Save to catalog',
          ),
          if (_isSaved)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: _deleteBook,
              tooltip: 'Remove from catalog',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // COVER SECTION
            Container(
              height: 220,
              color: AppColors.primary.withOpacity(0.1),
              child: Stack(
                children: [
                  if (_book.coverUrl != null)
                    Image.network(
                      _book.coverUrl!,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(Icons.book, size: 80, color: Colors.grey),
                      ),
                    ),
                  if (_book.coverUrl == null)
                    Center(
                      child: Icon(
                        Icons.book,
                        size: 80,
                        color: AppColors.primary.withOpacity(0.5),
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black45],
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        _book.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // DETAILS SECTION
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AUTHOR ROW
                  Row(
                    children: [
                      const Icon(Icons.person, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'by ${_book.author}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // INFO CHIPS ROW
                  Wrap(
                    spacing: 8,
                    children: [
                      if (_book.publishYear != null)
                        Chip(
                          avatar: const Icon(Icons.calendar_today, size: 14),
                          label: Text('${_book.publishYear}'),
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          side: BorderSide.none,
                        ),
                      if (_book.subject != null)
                        Chip(
                          avatar: const Icon(Icons.category, size: 14),
                          label: Text(_book.subject!),
                          backgroundColor: AppColors.secondary.withOpacity(0.1),
                          side: BorderSide.none,
                        ),
                    ],
                  ),

                  // DIVIDER
                  const SizedBox(height: 16),
                  const Divider(),

                  // PERSONAL NOTE SECTION
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Personal Note',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.primary,
                        ),
                      ),
                      if (_isSaved && !_isEditing)
                        TextButton.icon(
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text('Edit'),
                          onPressed: () {
                            setState(() {
                              _isEditing = true;
                            });
                          },
                        ),
                      if (_isEditing)
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isEditing = false;
                                  _noteController.text = _book.personalNote;
                                });
                              },
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: _saveNote,
                              child: const Text('Save'),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (_isEditing)
                    TextFormField(
                      controller: _noteController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Write your thoughts about this book...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),

                  if (!_isEditing)
                    if (_book.personalNote.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          _book.personalNote,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                  if (!_isEditing && _book.personalNote.isEmpty)
                    const Text(
                      'No personal note added yet.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),

                  if (!_isSaved) ...[
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.bookmark_add, color: Colors.white),
                        label: const Text(
                          'Save to My Catalog',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _toggleSave,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
