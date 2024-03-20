import 'dart:convert';

import 'package:http/http.dart' as http;

class LibraryApi {
  static const String _baseUrl = 'http://127.0.0.1:5000/api';

  Future<List<Book>> getBooks() async {
    print("getBooks");
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      var books = jsonDecode(response.body) as List;
      return books.map((book) => Book.fromJson(book)).toList();
      // return Book.fromJson(
      //     jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load books');
    }
  }
}

class Book {
  final String addDate;
  final String authorId;
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
      required this.authorId,
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
        'author_id': String authorId,
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
          authorId: authorId,
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
