import 'package:flutter/foundation.dart';
import '../models/book.dart';
import '../services/api_service.dart';

class LibraryProvider extends ChangeNotifier {
  List<Book> _searchResults = [];
  List<Book> _savedBooks = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  final ApiService _apiService = ApiService();

  List<Book> get searchResults => _searchResults;
  List<Book> get savedBooks => _savedBooks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  // READ - Search books from Open Library API
  Future<void> searchBooks(String query) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _searchResults = await _apiService.searchBooks(query);
      _searchQuery = query;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CREATE - Add a book to saved list
  void addBook(Book book) {
    if (!_savedBooks.any((b) => b.id == book.id)) {
      _savedBooks.add(book);
      notifyListeners();
    }
  }

  // UPDATE - Update personal note on a saved book
  void updateBookNote(String id, String note) {
    final index = _savedBooks.indexWhere((book) => book.id == id);
    if (index != -1) {
      _savedBooks[index] = _savedBooks[index].copyWith(personalNote: note);
      notifyListeners();
    }
  }

  // DELETE - Remove a book from saved list
  void deleteBook(String id) {
    _savedBooks.removeWhere((book) => book.id == id);
    notifyListeners();
  }

  // UTILITY - Clear search results
  void clearSearch() {
    _searchResults = [];
    _searchQuery = '';
    notifyListeners();
  }

  // UTILITY - Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
