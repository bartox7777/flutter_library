import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../common/book.dart';

class LibraryApi {
  Uri _baseUri =
      // 'http://127.0.0.1:5000/api';
      Uri.parse('https://libsys-api-b88eb4c3d18e.herokuapp.com/api');

  Future<List<Book>> getBooks({String phrase = ""}) async {
    final response = await http
        .get(Uri.https(_baseUri.authority, "/api/search", {"phrase": phrase}));

    if (response.statusCode == 200) {
      var books = jsonDecode(response.body) as List;
      return books.map((book) => Book.fromJson(book)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<http.Response> getBookByIsbn(String isbn) async {
    return http.post(
      Uri.https(_baseUri.authority, '/api/add-book', {'isbn': isbn}),
    );
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

  Future<http.Response> addBook(Book book) {
    var queryParameters = {
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

    if (book.author['author_id'] == '-1') {
      queryParameters['add_author'] = book.author['full_name'];
    }

    return http.put(
      Uri.https(_baseUri.authority, '/api/add-book', queryParameters),
    );
  }

  Future<http.Response> login(Map<String, String> credentials) {
    return http.post(
      Uri.https(_baseUri.authority, '/api/login', credentials),
    );
  }

  Future<List<dynamic>> getAuthors() async {
    var resp = await http.get(
      Uri.https(_baseUri.authority, '/api/add-book'),
    );
    return jsonDecode(resp.body)['authors'];
  }

  Future<List<dynamic>> getUsers() async {
    var resp = await http.get(
      Uri.https(_baseUri.authority, '/api/list-users'),
    );
    return jsonDecode(resp.body)['users'];
  }
}
