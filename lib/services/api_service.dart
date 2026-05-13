import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class ApiService {
  static const String baseUrl = 'https://openlibrary.org';

  Future<List<Book>> searchBooks(String query) async {
    try {
      final url = Uri.parse('$baseUrl/search.json?q=${Uri.encodeQueryComponent(query)}&limit=20');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> docs = data['docs'] ?? [];
        
        return docs.map((doc) => Book.fromApi(doc as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to load books. Please try again.');
      }
    } on SocketException {
      throw Exception('No internet connection.');
    } on FormatException {
      throw Exception('Failed to parse response.');
    } catch (e) {
      rethrow;
    }
  }
}
