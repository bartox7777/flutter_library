import 'dart:convert';

import 'package:flutter/material.dart';

import '../common/book.dart';
import '../handle_api/library_api.dart';
import '../main/book_list_view.dart';

void Function() updateBook(
  BuildContext context,
  GlobalKey<FormState> _formKey,
  Map<String, TextEditingController> _textEditingController,
  Map<String, dynamic>? _book,
) {
  return () {
    if (_formKey.currentState!.validate()) {
      final book = Book(
        bookId: _book!['book_id'],
        addDate: DateTime.now().toString(),
        isbn: _textEditingController['isbn']!.text,
        title: _textEditingController['title']!.text,
        author: {
          'author_id': _textEditingController['author']!.text.split(' ')[0],
          'full_name': _textEditingController['author']!
              .text
              .split(' ')
              .sublist(1)
              .join(' '),
        },
        category: _textEditingController['category']!.text,
        year: _textEditingController['year']!.text,
        pages: _textEditingController['pages']!.text,
        publisher: _textEditingController['publisher']!.text,
        numberOfCopies: _textEditingController['number_of_copies']!.text,
        cover: _textEditingController['cover']!.text,
        description: _textEditingController['description']!.text,
      );

      var resp = LibraryApi().updateBook(book);
      resp.then((value) {
        print(value.body);
        for (var i in jsonDecode(value.body)['flashes']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(i[1]),
            ),
          );
        }
        Navigator.popUntil(context, (route) => false);
        Navigator.pushNamed(
          context,
          BooksListView.routeName,
        );
      }).catchError((error, e) {
        print(error);
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Błąd podczas przetwarzania danych'),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Popraw błędy w formularzu'),
        ),
      );
    }
  };
}
