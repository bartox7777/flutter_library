import 'dart:convert';

import 'package:http/http.dart' as http;

import '../common/book.dart';

class LibraryApi {
  static const String _baseUrl =
      // 'http://127.0.0.1:5000/api';
      'https://libsys-api-b88eb4c3d18e.herokuapp.com/api';

  Future<List<Book>> getBooks() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      var books = jsonDecode(response.body) as List;
      return books.map((book) => Book.fromJson(book)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }
}
