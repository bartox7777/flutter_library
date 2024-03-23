import 'dart:convert';

import 'package:http/http.dart' as http;

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

class Book {
  final String addDate;
  final Map<String, dynamic> author;
  final String bookId;
  final String category;
  final String cover;
  final String description;
  final String isbn;
  final String numberOfCopies;
  final String pages;
  final String publisher;
  final String title;
  final String year;

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
        'book_id': String bookId,
        'category': String category,
        'cover': String cover,
        'description': String description,
        'isbn': String isbn,
        'number_of_copies': String numberOfCopies,
        'pages': String pages,
        'publisher': String publisher,
        'title': String title,
        'year': String year,
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

  Map<String, dynamic> to_map() {
    return {
      'add_date': addDate,
      'author': author,
      'book_id': bookId,
      'category': category,
      'cover': cover,
      'description': description,
      'isbn': isbn,
      'number_of_copies': numberOfCopies,
      'pages': pages,
      'publisher': publisher,
      'title': title,
      'year': year,
    };
  }
}
