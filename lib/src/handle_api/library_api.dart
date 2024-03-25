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

  Future<void> updateBook(Book book) async {
    final queryParameters = {
      'isbn': book.isbn,
      'title': book.title,
      'author_id': book.author['author_id'],
      'category': book.category,
      'year': book.year,
      'pages': book.pages,
      'publisher': book.publisher,
      'number_of_copies': book.numberOfCopies,
      'cover': book.cover,
      'description': book.description,
    };

    final uri = Uri.https(
      'libsys-api-b88eb4c3d18e.herokuapp.com',
      '/api/edit-book/${book.bookId}',
      queryParameters,
    );

    await http
        .patch(uri, body: jsonEncode(queryParameters))
        .then((value) => print('body: ${value.body}'))
        .catchError((error, e) {
      print(error);
      print(e);
    });

    // return new Future.sync(() => http.patch(uri));
    // return http.patch(uri);
    // final response = await http.patch(uri);
    //
    // print(response.body);
    //
    // return response;
  }
}
