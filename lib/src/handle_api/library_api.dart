import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

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
      'cover':
          "iVBORw0KGgoAAAANSUhEUgAAAQAAAAEACAIAAADTED8xAAAEW0lEQVR4nOzcz+sYchzH8X3XlMmmTFsONCVx2oFkW5SFyUEUJ1lTM0Wa5Ub5UUuiVsNRa2HiotWSA4ukaGVWlmZzQMvKNjRsmou/4l3q+Xj8Aa/P6dn79lny7q+7Fk166ouvRvdXXf7a6P4zT7w8un/87MbR/YPfrRvd33V06ej+k1uOje4vHl2H/zkBkCYA0gRAmgBIEwBpAiBNAKQJgDQBkCYA0gRAmgBIEwBpAiBNAKQJgDQBkCYA0gRAmgBIEwBpAiBNAKQJgDQBkCYA0gRAmgBIEwBpAiBt4dw7p0Yf+Oz8ptH9k5fN/q//wk9vje5f/9JVo/u7D30+ur/it79H959f/ejovgtAmgBIEwBpAiBNAKQJgDQBkCYA0gRAmgBIEwBpAiBNAKQJgDQBkCYA0gRAmgBIEwBpAiBNAKQJgDQBkCYA0gRAmgBIEwBpAiBNAKQJgDQBkLaw9JWTow/8cuai0f2V7+8f3X/2scdH95c/cHh0/8L3d4zunz789Oj+2sVvj+67AKQJgDQBkCYA0gRAmgBIEwBpAiBNAKQJgDQBkCYA0gRAmgBIEwBpAiBNAKQJgDQBkCYA0gRAmgBIEwBpAiBNAKQJgDQBkCYA0gRAmgBIEwBpC39esXH0gb/WHx/df+7IH6P7G+7fOrq/973R+UVHTtw2un/13mWj+8uv3DO67wKQJgDSBECaAEgTAGkCIE0ApAmANAGQJgDSBECaAEgTAGkCIE0ApAmANAGQJgDSBECaAEgTAGkCIE0ApAmANAGQJgDSBECaAEgTAGkCIE0ApC256a5HRh94eM2Do/s7dt4yuv/6jfeN7i+7/ezo/vnTF4/uL35ox+j+pv3nRvddANIEQJoASBMAaQIgTQCkCYA0AZAmANIEQJoASBMAaQIgTQCkCYA0AZAmANIEQJoASBMAaQIgTQCkCYA0AZAmANIEQJoASBMAaQIgTQCkCYC0JXevPzD6wJ2XfDi6v+/3ZaP7X544Obq/9OPNo/sHVq0b3d/27Zuj+xu3bxvddwFIEwBpAiBNAKQJgDQBkCYA0gRAmgBIEwBpAiBNAKQJgDQBkCYA0gRAmgBIEwBpAiBNAKQJgDQBkCYA0gRAmgBIEwBpAiBNAKQJgDQBkCYA0hYO3nps9IF7f1g7uv/Btd+M7n+05ebR/dUvXjO6f8+hzaP7W9ccHd0/c+kbo/suAGkCIE0ApAmANAGQJgDSBECaAEgTAGkCIE0ApAmANAGQJgDSBECaAEgTAGkCIE0ApAmANAGQJgDSBECaAEgTAGkCIE0ApAmANAGQJgDSBEDawqobfh59YM8n+2b3d346uv/1ht2j+/+s2Da6v/3UhdH9H1deN7r/7/JXR/ddANIEQJoASBMAaQIgTQCkCYA0AZAmANIEQJoASBMAaQIgTQCkCYA0AZAmANIEQJoASBMAaQIgTQCkCYA0AZAmANIEQJoASBMAaQIgTQCkCYC0/wIAAP//evRjjD/ccRsAAAAASUVORK5CYII="
      // 'cover': book.cover,
      ,
      'description': book.description,
    };

    // var uri = Uri.parse(_baseUrl);

    // var resp = http.patch(
    //     Uri.https('libsys-api-b88eb4c3d18e.herokuapp.com',
    //         'api/edit-book/${book.bookId}', queryParameters),
    //     headers: {'Content-Type': 'application/json'});

    var resp = http.patch(
      Uri.https('libsys-api-b88eb4c3d18e.herokuapp.com',
          '/api/edit-book/${book.bookId}', queryParameters),
    );

    resp.then((value) => {print(value.body)}).catchError((error, e) {
      print(error);
      print(e);
    });

    return resp;

    // final uri = Uri.https(
    //   'libsys-api-b88eb4c3d18e.herokuapp.com',
    //   '/api/edit-book/${book.bookId}',
    //   queryParameters,
    // );

    // final uri =
    //     Uri.http('127.0.0.1', '/api/edit-book/${book.bookId}', queryParameters);

    // await http
    //     .patch(uri, body: jsonEncode(queryParameters))
    //     .then((value) => print('body: ${value.body}'))
    //     .catchError((error, e) {
    //   print(error);
    //   print(e);
    // });

    // return new Future.sync(() => http.patch(uri));
    // return http.patch(uri);
    // final response = await http.patch(uri);
    //
    // print(response.body);
    //
    // return response;
  }
}
