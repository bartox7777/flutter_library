import 'dart:convert';

import 'package:http/http.dart' as http;

import '../common/book.dart';

class LibraryApi {
  Uri _baseUri =
      // 'http://127.0.0.1:5000/api';
      Uri.parse('https://libsys-api-b88eb4c3d18e.herokuapp.com/api');

  Future<List<Book>> getBooks() async {
    final response = await http.get(_baseUri);

    if (response.statusCode == 200) {
      var books = jsonDecode(response.body) as List;
      return books.map((book) => Book.fromJson(book)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<http.Response> updateBook(Book book) {
    final queryParameters = {
      'isbn': book.isbn,
      'title': book.title,
      'author': book.author['author_id'],
      'category': book.category,
      'year': book.year,
      'pages': book.pages,
      'publisher': book.publisher,
      'number_of_copies': book.numberOfCopies,
      'cover': book.cover,
      'description': book.description,
    };

    return http.patch(
      Uri.https(
          _baseUri.authority, '/api/edit-book/${book.bookId}', queryParameters),
    );
  }

  Future<http.Response> login(Map<String, String> credentials) {
    return http.post(
      Uri.https(_baseUri.authority, '/api/login', credentials),
    );
  }
}
