import 'dart:convert';

import 'package:http/http.dart' as http;

class LibraryApi {
  static const String _baseUrl =
      'https://libsys-api-b88eb4c3d18e.herokuapp.com/api';
  // 'http://localhost:5000/api';

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

class Book {
  final String addDate;
  final Map<String, dynamic> author;
  final int bookId;
  final String category;
  final String cover;
  final String description;
  final String isbn;
  final int numberOfCopies;
  final int pages;
  final String publisher;
  final String title;
  final int year;

  Book(
      {required this.addDate,
      required this.author,
      required this.bookId,
      required this.category,
      required this.cover,
      required this.description,
      required this.isbn,
      required this.numberOfCopies,
      required this.pages,
      required this.publisher,
      required this.title,
      required this.year});

  factory Book.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'add_date': String addDate,
        'author': Map<String, dynamic> author,
        'book_id': int bookId,
        'category': String category,
        'cover': String cover,
        'description': String description,
        'isbn': String isbn,
        'number_of_copies': int numberOfCopies,
        'pages': int pages,
        'publisher': String publisher,
        'title': String title,
        'year': int year,
      } =>
        Book(
          addDate: addDate,
          author: author,
          bookId: bookId,
          category: category,
          cover: cover,
          description: description,
          isbn: isbn,
          numberOfCopies: numberOfCopies,
          pages: pages,
          publisher: publisher,
          title: title,
          year: year,
        ),
      _ => throw Exception('Failed to load books'),
    };
  }
}
